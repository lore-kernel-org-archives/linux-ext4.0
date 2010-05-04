From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Add data string to mount message, and new remount
	message
Date: Tue, 4 May 2010 08:57:02 -0700
Message-ID: <AANLkTinOCWC_gnQlfwjH7wYgoJkZY3mOEhOV8r3GfaC6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:47294 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab0EDP5J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 11:57:09 -0400
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id o44Fv5k1005725
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 08:57:05 -0700
Received: from vws18 (vws18.prod.google.com [10.241.21.146])
	by wpaz13.hot.corp.google.com with ESMTP id o44Ftwhi016790
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 08:57:04 -0700
Received: by vws18 with SMTP id 18so446441vws.20
        for <linux-ext4@vger.kernel.org>; Tue, 04 May 2010 08:57:03 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This adds a "re-mounted" message to ext4_remount(), and both it and the
mount message in ext4_fill_super() now have the original data string.

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

We've found that printing the original data string is very helpful in
disambiguating mount messages, especially as remounts are done to change
mount options.

diff -uprN orig/fs/ext4/super.c new/fs/ext4/super.c
--- orig/fs/ext4/super.c	2010-05-04 08:31:43.000000000 -0700
+++ new/fs/ext4/super.c	2010-05-04 08:36:28.000000000 -0700
@@ -2430,6 +2430,7 @@ static int ext4_fill_super(struct super_
 				__releases(kernel_lock)
 				__acquires(kernel_lock)
 {
+	char *orig_data = kstrdup(data, GFP_KERNEL);
 	struct buffer_head *bh;
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi;
@@ -3040,9 +3041,12 @@ no_journal:
 	} else
 		descr = "out journal";

-	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s", descr);
+	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
+		"Opts: %s", descr, orig_data);

 	lock_kernel();
+	if (orig_data)
+		kfree(orig_data);
 	return 0;

 cantfind_ext4:
@@ -3089,6 +3093,8 @@ out_fail:
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	lock_kernel();
+	if (orig_data)
+		kfree(orig_data);
 	return ret;
 }

@@ -3580,6 +3586,7 @@ static int ext4_remount(struct super_blo
 #ifdef CONFIG_QUOTA
 	int i;
 #endif
+	char *orig_data = kstrdup(data, GFP_KERNEL);

 	lock_kernel();

@@ -3713,6 +3720,9 @@ static int ext4_remount(struct super_blo
 #endif
 	unlock_super(sb);
 	unlock_kernel();
+
+	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
+	kfree(orig_data);
 	return 0;

 restore_opts:
@@ -3734,6 +3744,8 @@ restore_opts:
 #endif
 	unlock_super(sb);
 	unlock_kernel();
+	if (orig_data)
+		kfree(orig_data);
 	return err;
 }
