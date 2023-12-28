import 'package:bloc_state_mgt/05-main-exercise/bloc/app_bloc.dart';
import 'package:bloc_state_mgt/05-main-exercise/bloc/app_event.dart';
import 'package:bloc_state_mgt/05-main-exercise/bloc/app_state.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/view/main_pop_up_menu_button.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/view/storage_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends HookWidget {
  PhotoGalleryView({super.key});

  final GlobalKey myWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) {
                return;
              }

              final context = myWidgetKey.currentContext;
              context
                  ?.read<AppBloc>()
                  .add(AppEventUploadImage(filePathToUpload: image.path));
            },
            icon: const Icon(Icons.upload),
          ),
          MainPopUpMenuButton()
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images.map((img) => StorageImageView(image: img)).toList(),
      ),
    );
  }
}
