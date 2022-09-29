import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:mm/shared/cubit/cubit.dart';

Widget defaultButton({
   double width = double.infinity,
   Color background = Colors.blue,
  double radius =10.0,
  required VoidCallback function, // we can replace it with Function()
  required String buttonText,
  bool isUpperCase = true,

}) => Container(
  width: width,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
  child: MaterialButton(
    onPressed: function,
    child: Text(
      isUpperCase ? buttonText.toUpperCase() :buttonText,
      style:const TextStyle(
        color: Colors.white,
      ),
    ) ,
  ),
);



Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType textInputType,
  Function(String newValue)? onSubmit,
  Function(String newValue)? onChange,
  Function()? onTap,
  required final String? Function(String?)? validate,
  bool obscureText = false,
  required String label,
  required IconData prefixIcon,
  IconData? suffixIcon,
  Function()? suffixPress,

})=> TextFormField(
  controller: controller,
  keyboardType: textInputType,
  onFieldSubmitted: onSubmit,
  onTap: onTap,
  onChanged: onChange,
  validator: validate,
  obscureText: obscureText,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefixIcon),
    suffixIcon: suffixIcon != null ? IconButton(
      onPressed: suffixPress,
      icon: Icon(suffixIcon),
    ) : null,

    border: const OutlineInputBorder(),
  ),
);


Widget buildTaskItem(Map model , context){
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction){
      AppCubit.get(context).deleteData(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           CircleAvatar (
            child: Text('${model['time']}'),
            radius: 40.0,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(
              onPressed: (){
                AppCubit.get(context).updateData(status: 'done', id:model['id'] );
              },
              icon: Icon(Icons.check_box, color: Colors.green,),
          ),
          IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(status: 'archive', id:model['id'] );
            },
            icon: Icon(Icons.archive, color: Colors.red,),
          ),

        ],
      ),
    ),
  );
}

Widget tasksBuilder({
  required List<Map> tasks,
}) =>ConditionalBuilder(
  condition: tasks.length >0,
  builder: (context) =>ListView.separated(
    itemBuilder: (context , index)=> buildTaskItem(tasks[index], context),
    separatorBuilder: (context , index) => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20,end: 20),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:const [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        )
      ],
    ),
  ),
);
