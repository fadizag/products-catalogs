class Product {
  const Product({required this.id,required this.datasetId,required this.name,required this.barcode,this.brand='',this.category='',this.frontImage='',this.backImage='',this.ingredientsImage='',required this.createdAt,required this.updatedAt});
  final String id,datasetId,name,barcode,brand,category,frontImage,backImage,ingredientsImage,createdAt,updatedAt;
  Map<String,Object?> toMap()=>{'id':id,'dataset_id':datasetId,'name':name,'barcode':barcode,'brand':brand,'category':category,'front_image':frontImage,'back_image':backImage,'ingredients_image':ingredientsImage,'created_at':createdAt,'updated_at':updatedAt};
  factory Product.fromMap(Map<String,Object?> m)=>Product(id:'${m['id']??''}',datasetId:'${m['dataset_id']??''}',name:'${m['name']??''}',barcode:'${m['barcode']??''}',brand:'${m['brand']??''}',category:'${m['category']??''}',frontImage:'${m['front_image']??''}',backImage:'${m['back_image']??''}',ingredientsImage:'${m['ingredients_image']??''}',createdAt:'${m['created_at']??''}',updatedAt:'${m['updated_at']??''}');
}
