From: Xu Cang <cangxumu@gmail.com>
Subject: [PATCH] ext4: crypto return correct error for file_mmap when
 get_encryption_info failed.
Date: Sun, 1 Nov 2015 17:01:37 -0500
Message-ID: <CAOjcEBL6QQYdSpVq_6mSuzyMq6XO6kJGhseF6bD3WOeYLgC6Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36448 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbbKAWBi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Nov 2015 17:01:38 -0500
Received: by wmec75 with SMTP id c75so6546427wme.3
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2015 14:01:37 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 113837e..1c0086a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -295,7 +295,7 @@ static int ext4_file_mmap(struct file *file,
struct vm_area_struct *vma)
        if (ext4_encrypted_inode(inode)) {
                int err = ext4_get_encryption_info(inode);
                if (err)
-                       return 0;
+                       return -EACCES;
                if (ext4_encryption_info(inode) == NULL)
                        return -ENOKEY;
        }
