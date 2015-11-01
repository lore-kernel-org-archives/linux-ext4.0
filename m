From: Xu Cang <cangxumu@gmail.com>
Subject: [PATCH] ext4: add "static" to ext4_seq_##name##_fops struct
Date: Sun, 1 Nov 2015 11:23:20 -0500
Message-ID: <CAOjcEBJ10SNdHwHH8mHxF5r3Zvz--UF8H7gdiv7T07T7y9=JuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33977 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbbKAQXV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Nov 2015 11:23:21 -0500
Received: by wmeg8 with SMTP id g8so5920046wme.1
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2015 08:23:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

to fix sparse warning, add static to ext4_seq_##name##_fops struct.

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 1b57c72..1420a3c 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -358,7 +358,7 @@ static int name##_open(struct inode *inode, struct
file *file) \
        return single_open(file, ext4_seq_##name##_show, PDE_DATA(inode)); \
 } \
 \
-const struct file_operations ext4_seq_##name##_fops = { \
+static const struct file_operations ext4_seq_##name##_fops = { \
        .owner          = THIS_MODULE, \
        .open           = name##_open, \
        .read           = seq_read, \
