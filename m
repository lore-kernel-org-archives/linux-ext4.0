From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: fix panic on module unload when stopping lazyinit thread
Date: Fri, 28 Jan 2011 16:16:13 -0600
Message-ID: <4D43402D.2000004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1A1WQO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Jan 2011 17:16:14 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0SMGE7H028764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 28 Jan 2011 17:16:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is for the latest reported module unload oops in
kernel.org bugzilla #27652

If the lazyinit thread is running, the teardown
function ext4_destroy_lazyinit_thread() has problems:

        ext4_clear_request_list();
        while (ext4_li_info->li_task) {
                wake_up(&ext4_li_info->li_wait_daemon);
                wait_event(ext4_li_info->li_wait_task,
                           ext4_li_info->li_task == NULL);
        }

clearing the request list will cause the thread to exit
and free ext4_li_info, so then we're waiting on something
which is getting freed.

Fix this up by making the thread respond to kthread_stop,
and exit, without the need to wait for that exit in some
other homegrown way.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c
+++ linux-2.6/fs/ext4/super.c
@@ -77,6 +77,7 @@ static struct dentry *ext4_mount(struct 
 		       const char *dev_name, void *data);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
+static void ext4_clear_request_list(void);
 
 #if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
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
+		if (kthread_should_stop()) {
+			ext4_clear_request_list();
+			goto exit_thread;
+		}
 	}
 
 exit_thread:
@@ -2796,6 +2803,7 @@ exit_thread:
 	wake_up(&eli->li_wait_task);
 
 	kfree(ext4_li_info);
+	ext4_lazyinit_task = NULL;
 	ext4_li_info = NULL;
 	mutex_unlock(&ext4_li_mtx);
 
@@ -2818,11 +2826,10 @@ static void ext4_clear_request_list(void
 
 static int ext4_run_lazyinit_thread(void)
 {
-	struct task_struct *t;
-
-	t = kthread_run(ext4_lazyinit_thread, ext4_li_info, "ext4lazyinit");
-	if (IS_ERR(t)) {
-		int err = PTR_ERR(t);
+	ext4_lazyinit_task = kthread_run(ext4_lazyinit_thread,
+					 ext4_li_info, "ext4lazyinit");
+	if (IS_ERR(ext4_lazyinit_task)) {
+		int err = PTR_ERR(ext4_lazyinit_task);
 		ext4_clear_request_list();
 		del_timer_sync(&ext4_li_info->li_timer);
 		kfree(ext4_li_info);
@@ -2973,16 +2980,10 @@ static void ext4_destroy_lazyinit_thread
 	 * If thread exited earlier
 	 * there's nothing to be done.
 	 */
-	if (!ext4_li_info)
+	if (!ext4_li_info || !ext4_lazyinit_task)
 		return;
 
-	ext4_clear_request_list();
