From: Nicolas Dechesne <nicolas.dechesne@linaro.org>
Subject: e2fsprogs: building ext2simg
Date: Sun, 8 Oct 2017 22:04:21 +0200
Message-ID: <CAP71WjzSUxbK1mpv_bTuZd6W4xV2zNEEQN0GtmEp7iMTyhi9zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:50051 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753058AbdJHUEn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Oct 2017 16:04:43 -0400
Received: by mail-qk0-f178.google.com with SMTP id s14so8725646qks.6
        for <linux-ext4@vger.kernel.org>; Sun, 08 Oct 2017 13:04:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

ext2simg.c file was moved from android (system/extras) into e2fsprogs.
however it seems that it cannot be compiled outside of android (it
uses sparse/sparse.h). some distro used to build/package this utility
(e.g. debian has it in android-tools-fsutils).

what was the main reason why it was moved into e2fsprogs in the first
place, given that it cannot be compiled (easily) outside of AOSP?

Also, the commit that brought this file has the following reference:

    From AOSP commit: c1b7d19958dc3dbe53810811ea3dcc4f04f85c73

However I don't think this commit in AOSP.

thanks!
