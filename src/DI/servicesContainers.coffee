class serviceContainers
    services:{}
    instances:{}

    register: (name,constructor) =>
        service :
            name : name
            constructor : constructor
        @services[name] = service

    get : (name)=>
        instance = new @services[name].constructor() unless @instances[name]
        #if instance then @instances[name] = instance
        @instances[name]



