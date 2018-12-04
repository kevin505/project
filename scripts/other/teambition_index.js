db.activations.createIndex({_userId:1})
db.activenesses.createIndex({
                "_organizationId" : 1,
                "created" : 1
        })
db.activenesses.createIndex({
                "_projectId" : 1,
                "created" : 1
        }      )
db.activities.createIndex( {
                "_creatorId" : 1
        })
db.activities.createIndex({
                "action" : 1
        })
db.activities.createIndex({
                "boundToObjects._objectId" : 1
        })
db.activities.createIndex({
                "rootId" : 1,
                "action" : 1,
                "_id" : -1
        })
db.activities.createIndex({
                "rootId" : 1,
                "action" : 1,
                "created" : 1,
                "_id" : -1
        })
db.activities.createIndex( {
                "boundToObjects._objectId" : 1,
                "created" : -1
        } )
db.aliens.createIndex({
                "_userId" : 1
        })
db.aliens.createIndex({
                "openId" : 1,
                "refer" : 1
        } )
db.articles.createIndex({ "sourceId" : 1 })
db.articles.createIndex({ "_userId" : 1 })
db.bookkeepings.createIndex({ "_projectId" : 1 })
db.collections.createIndex({ "_projectId" : 1 })
db.collections.createIndex({ "_parentId" : 1 })
db.consumers.createIndex({ "clientKey" : 1 })
db.contacts.createIndex({
                "me" : 1,
                "other" : 1
        })
db.contacts.createIndex({
                "lastInviteDate" : 1
        })
db.contacts.createIndex({
                "me" : 1,
                "isDeleted" : 1
        })
db.contacts.createIndex({
                "me" : 1,
                "lastInviteDate" : -1
        })
db.devicetokens.createIndex({ "_userId" : 1 })
db.devicetokens.createIndex({ "token" : 1 })
db.entries.createIndex({ "_projectId" : 1, "tagIds" : 1 })
db.events.createIndex({
                "_sourceId" : 1
        })
db.events.createIndex({
                "involveMembers" : 1
        })
db.events.createIndex({
                "_projectId" : 1,
                "tagIds" : 1
        })
db.events.createIndex({_projectId:1,endDate:1})
db.events.createIndex({_projectId:1,startDate:1,endDate:1})
db.favorites.createIndex({ "_refId" : 1, "_creatorId" : 1 })
db.feeds.createIndex({ "_ownerId" : 1 })
db.forks.createIndex({ "_userId" : 1 })
db.hooks.createIndex({ "_projectId" : 1 })
db.linkprojects.ensureIndex({_linkedId:1,linkedType:1})
db.linkprojects.ensureIndex({_projectId:1,_linkedId:1})
db.likes.createIndex({
                "_creatorId" : 1,
                "_objectId" : 1
        })
db.likes.createIndex({
                "_objectId" : 1,
                "like" : 1
        })
db.members.createIndex({
                "_boundToObjectId" : 1
        })
db.members.createIndex({
                "_userId" : 1,
                "boundToObjectType" : 1
        })
db.members.createIndex({
                "_teamId" : 1
        })
db.members.createIndex({
                "_userId" : 1,
                "_boundToObjectId" : 1,
                "isQuited" : 1
        })
db.members.createIndex({
                "_roleId" : 1
        })
db.members.createIndex({
                        "_boundToObjectId" : 1,
                        "_teamId" : 1,
                        "isQuited" : 1
                })
db.messages.ensureIndex( {_userId:1,isAted:1,isArchived:1},{background:1})
 
db.messages.createIndex({
                "_userId" : 1,
                "_id" : 1
        })
db.messages.createIndex({
                "rootId" : 1
        })
db.messages.createIndex({
                "_boundToObjectId" : 1,
                "_userId" : 1
        })
db.messages.createIndex({
                "_userId" : 1,
                "isArchived" : 1,
                "unreadActivitiesCount" : -1,
                "updated" : -1
        })
db.messages.createIndex({ "_userId" : 1, "isRead" : 1, "updated" : -1, "boundToObjectType" : 1, "isLater" : 1, "isArchived" : 1 },{background:1})
db.messages.createIndex({_userId:1, boundToObjectUpdated:-1, isLater:1,boundToObjectType:1},{background:1})
db.messages.createIndex({
                "_userId" : 1,
                "isRead" : 1,
                "isArchived" : 1
        })
db.notes.createIndex({ "_userId" : 1, "_id" : -1 })
db.objectlinks.createIndex({
                "_projectId" : 1
        })
db.objectlinks.createIndex({
                "_parentId" : 1
        })
db.objectlinks.createIndex({
                "_linkedId" : 1
        })
db.oldusers.createIndex({ "email" : 1 })
db.organizations.createIndex({
                "_creatorId" : 1
        })
db.organizations.createIndex({
                "isDeleted" : 1,
                "created" : -1
        })
db.organizations.createIndex({
                "name" : "hashed"
        })
db.plans.createIndex({
                "_boundToObjectId" : 1
        })
db.plans.createIndex({
                "boundToObjectType" : 1
        } )
db.posts.createIndex({
                "relatedObjects._id" : 1,
                "type" : 1
        })
db.posts.createIndex({
                "updated" : 1
        })
db.posts.createIndex({
                "_projectId" : 1,
                "tagIds" : 1
        })
db.posts.createIndex({
                "_projectId" : 1,
                "pin" : -1,
                "created" : -1
        })
db.preferences.createIndex({ "_userId" : 1 })
db.preferences.createIndex({ "showProjects" : 1 })
db.projects.createIndex({
                "_organizationId" : 1
        })
db.projects.createIndex({
                "_creatorId" : 1
        })
db.projects.createIndex({
                "starredUsers._creatorId" : 1
        })
db.recipients.createIndex({
                "_feedId" : 1
        })
db.recipients.createIndex({
                "_recipientId" : 1
        })
db.recipients.createIndex({
                "_userId" : 1
        })
db.reports.createIndex({ "_organizationId" : 1, "startDate" : 1 } )
db.resources.createIndex({ "_feedId" : 1 })
db.roles.createIndex({ "_organizationId" : 1 })
db.sources.createIndex({ "_userId" : 1 })
db.sources.createIndex({ "created" : 1 })
db.stages.createIndex({ "_tasklistId" : 1 })
db.stages.createIndex({ "_nextId" : 1 } )
db.stagetemplates.createIndex({ "_userId" : 1 } )
db.subtasks.createIndex({
                "_taskId" : 1
        })
db.subtasks.createIndex({
                "_projectId" : 1
        })
db.subtasks.createIndex({
                "_executorId" : 1
        })
db.tags.createIndex({ "_projectId" : 1 })
db.tasklists.createIndex({ "_projectId" : 1 })
db.tasks.createIndex({
                "_sourceId" : 1
        })
db.tasks.createIndex({
                "updated" : 1
        })
db.tasks.createIndex({
                "_stageId" : 1,
                "accomplished" : -1
        })
db.tasks.createIndex({
                "_executorId" : 1,
                "dueDate" : 1
        })
db.tasks.createIndex({
                "_projectId" : 1,
                "tagIds" : 1
        })
db.tasks.createIndex({
                "_projectId" : 1,
                "isDeleted" : 1,
                "isArchived" : 1,
                "isDone" : 1,
                "accomplished" : -1
        })
db.tasks.createIndex({
                "_projectId" : 1,
                "isDeleted" : 1,
                "isArchived" : 1,
                "isDone" : 1,
                "priority" : -1,
                "dueDate" : -1
        })
db.tasks.createIndex({
                "_projectId" : 1,
                "involveMembers" : 1,
                "created" : -1
        })
db.tasks.createIndex({
                "_executorId" : 1,
                "_projectId" : 1,
                "priority" : -1,
                "dueDate" : -1
        })
db.tasks.createIndex({
                "_projectId" : 1,
                "updated" : 1,
                "created" : 1
        })
 db.tasks.createIndex({
                "_tasklistId" : 1,
                "isArchived" : 1,
                "isDeleted" : 1,
                 "isDone" : 1,
                "priority" : -1,
                "dueDate" : -1
        },{background:true})
db.tasks.createIndex({
                "_executorId" : 1,
                "updated" : 1
        })
db.tasks.createIndex({
                "_stageId" : 1,
                "isDeleted" : 1
        })
db.teams.createIndex({ "_organizationId" : 1 })
db.tokens.createIndex({
                "key" : 1
        })
db.tokens.createIndex({
                "consumerKey" : 1,
                "_userId" : 1
        })
db.tokens.createIndex({
                "_userId" : 1
        })
db.users.createIndex({
                "email" : 1
        })
db.users.createIndex({
                "emails.email" : 1
        })
db.users.createIndex({
                "name" : 1
        })
db.users.createIndex({
                "phoneForLogin" : 1
        })
db.versions.createIndex({ "_workId" : 1 })
db.works.createIndex({
                "_projectId" : 1,
                "tagIds" : 1
        })
db.works.createIndex({
                "_projectId" : 1,
                "updated" : 1,
                "created" : 1
        })
db.works.createIndex({
                "_parentId" : 1,
                "_id" : -1
        })
db.works.createIndex({
                "_parentId" : 1,
                "isDeleted" : 1
        })
db.records.createIndex( { created: 1 }, { background: true } )
