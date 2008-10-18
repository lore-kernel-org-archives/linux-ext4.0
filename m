From: roel kluin <roel.kluin@gmail.com>
Subject: [PATCH] ext4: simple_strtol returns signed.
Date: Sat, 18 Oct 2008 16:21:44 -0400
Message-ID: <48FA4558.2020603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:39566 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbYJROVl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Oct 2008 10:21:41 -0400
Received: by nf-out-0910.google.com with SMTP id d3so533961nfc.21
        for <linux-ext4@vger.kernel.org>; Sat, 18 Oct 2008 07:21:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

simple_strtol returns signed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9b2b2bc..1789dec 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3516,7 +3516,7 @@ static ssize_t ext4_ui_proc_write(struct file *file, const char __user *buf,
 {
 	unsigned int *p = PDE(file->f_path.dentry->d_inode)->data;
 	char str[32];
-	unsigned long value;
+	long value;
 
 	if (cnt >= sizeof(str))
 		return -EINVAL;

