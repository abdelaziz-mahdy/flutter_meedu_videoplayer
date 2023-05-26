package com.zezo357.flutter_meedu_videoplayer;

import android.content.res.Configuration;

import io.flutter.embedding.android.FlutterActivity;

public class MeeduPlayerFlutterActivity extends FlutterActivity {

    OnPictureInPictureListener onPictureInPictureListener;


    @Override
    public void onPictureInPictureModeChanged(boolean isInPictureInPictureMode, Configuration newConfig) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig);
        if (onPictureInPictureListener != null) {
            onPictureInPictureListener.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig);
        }
    }
}


interface OnPictureInPictureListener {
    void onPictureInPictureModeChanged(boolean isInPictureInPictureMode, Configuration newConfig);
}