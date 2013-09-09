From: jon ernst <jonernst07@gmail.com>
Subject: [PATCH] make new_inode call a little bit clearer.
Date: Mon, 9 Sep 2013 20:21:21 +0000
Message-ID: <CAGW2f1Gat4KJYOvrKmNRjuNeXcPJ75hpH2-ozzXPX7hCuo5GTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58184 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3IIUVX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Sep 2013 16:21:23 -0400
Received: by mail-wi0-f175.google.com with SMTP id ez12so3947917wid.2
        for <linux-ext4@vger.kernel.org>; Mon, 09 Sep 2013 13:21:21 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Zheng,
on e2fsprog pu branch,
I know it not worth to commit this alone, maybe you combine with you
future commit later.

thank you!

diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index ea3736c..4bf19c1 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -933,7 +933,7 @@ static errcode_t test_file(ext2_filsys fs)
     char *buf, *cmpbuf;
     int inline_size;

-    retval = ext2fs_new_inode(fs, 2, 010755, 0, &newfile);
+    retval = ext2fs_new_inode(fs, EXT2_ROOT_INO, 010755, 0, &newfile);
     if (retval) {
         com_err("test_file", retval,
             "While creating a new file");



Best,
Jon
