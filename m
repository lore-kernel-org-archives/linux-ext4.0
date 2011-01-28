From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27652] 38-rc1: umount+rmmod cause ext4 error.
Date: Fri, 28 Jan 2011 22:07:57 GMT
Message-ID: <201101282207.p0SM7vIV004578@demeter1.kernel.org>
References: <bug-27652-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:42391 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1A1WH7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jan 2011 17:07:59 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0SM7wip004579
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 28 Jan 2011 22:07:58 GMT
In-Reply-To: <bug-27652-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27652





--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2011-01-28 22:07:53 ---
Ok it is in fact lazyinit uninit that's falling down, the wait_event is waiting
on something that gets freed.

This fixes it up for me:

Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c
+++ linux-2.6/fs/ext4/super.c
@@ -77,6 +77,7 @@ static struct dentry *ext4_mount(struct 
                const char *dev_name, void *data);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
+static void ext4_clear_request_list(void);

 #if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) &&
defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext3_fs_type = {
@@ -2704,6 +2705,8 @@ static void ext4_unregister_li_request(s
     mutex_unlock(&ext4_li_info->li_list_mtx);
 }

+static struct task_struct *ext4_lazyinit_task;
+
 /*
  * This is the function where ext4lazyinit thread lives. It walks
  * through the request list searching for next scheduled filesystem.
@@ -2772,6 +2775,10 @@ cont_thread:
         if (time_before(jiffies, next_wakeup))
             schedule();
         finish_wait(&eli->li_wait_daemon, &wait);
+        if (kthread_should_stop()) {
+            ext4_clear_request_list();
+            goto exit_thread;
+        }
     }

 exit_thread:
@@ -2796,6 +2803,7 @@ exit_thread:
     wake_up(&eli->li_wait_task);

     kfree(ext4_li_info);
+    ext4_lazyinit_task = NULL;
     ext4_li_info = NULL;
     mutex_unlock(&ext4_li_mtx);

@@ -2818,11 +2826,10 @@ static void ext4_clear_request_list(void

 static int ext4_run_lazyinit_thread(void)
 {
-    struct task_struct *t;
-
-    t = kthread_run(ext4_lazyinit_thread, ext4_li_info, "ext4lazyinit");
-    if (IS_ERR(t)) {
-        int err = PTR_ERR(t);
+    ext4_lazyinit_task = kthread_run(ext4_lazyinit_thread,
+                     ext4_li_info, "ext4lazyinit");
+    if (IS_ERR(ext4_lazyinit_task)) {
+        int err = PTR_ERR(ext4_lazyinit_task);
         ext4_clear_request_list();
         del_timer_sync(&ext4_li_info->li_timer);
         kfree(ext4_li_info);
@@ -2976,13 +2983,7 @@ static void ext4_destroy_lazyinit_thread
     if (!ext4_li_info)
         return;

-    ext4_clear_request_list();
