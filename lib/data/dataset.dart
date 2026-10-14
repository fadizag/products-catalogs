class Dataset {
 const Dataset({required this.id,required this.name,this.description='',required this.createdAt});
 final String id,name,description,createdAt;
 Map<String,Object?> toMap()=>{'id':id,'name':name,'description':description,'created_at':createdAt};
 factory Dataset.fromMap(Map<String,Object?> m)=>Dataset(id:'${m['id']??''}',name:'${m['name']??''}',description:'${m['description']??''}',createdAt:'${m['created_at']??''}');
}
