class RoleProxy
  # Wraps a Role in the context of a Host: calls to the RoleProxy are passed to
  # the Role it wraps, but called with the host as the first argument. This
  # allows role-method chaining for nice namespaces.
  #
  # RoleProxy.new(host, role).some_task(*args) =>
  #   role.some_task(host, *args)
  #
  # RoleProxies are created on the fly by Hosts; you shouldn't have to
  # instantiate them directly. They're involved when you do something like:
  #
  # host :foo do
  #   my_role.some_task
  # end
  
  def initialize(host, role)
    @host = host
    @role = role
  end

  def method_missing(meth, *args, &block)
    @role.tasks.find{|t| t.name == meth.to_s}.run(@host, *args, &block)
  end
end
