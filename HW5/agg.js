db.tags.count()
db.tags.find({name:'woman'}).count()
db.tags.aggregate([ {$group: {_id: "$name", tag_count: {$sum: 1}}} , {$sort: {tag_count: -1} } , {$limit : 3} ])