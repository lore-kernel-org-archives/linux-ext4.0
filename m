From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/4 v2] ext4: Remove unnecessary wait_event ext4_run_lazyinit_thread()
Date: Mon,  9 May 2011 17:57:08 +0200
Message-ID: <1304956630-20384-2-git-send-email-lczerner@redhat.com>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1EIP5l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 11:57:41 -0400
In-Reply-To: <1304956630-20384-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For some reason we have been waiting for lazyinit thread to start in the
ext4_run_lazyinit_thread() but it is not needed anymore so get rid of
it. We can also remove li_task and li_wait_task since it is not used
anymore.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h  |    2 --
 fs/ext4/super.c |   10 ----------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1e37c09..8689f97 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1590,8 +1590,6 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
  */
 struct ext4_lazy_init {
 	unsigned long		li_state;
-	wait_queue_head_t	li_wait_task;
-	struct task_struct	*li_task;
 	struct list_head	li_request_list;
 	struct mutex		li_list_mtx;
 };
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f0e4c3a..6ccf0e2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2754,9 +2754,6 @@ static int ext4_lazyinit_thread(void *arg)
 
 	BUG_ON(NULL == eli);
 
-	eli->li_task = current;
-	wake_up(&eli->li_wait_task);
-
 cont_thread:
 	while (true) {
 		next_wakeup = MAX_JIFFY_OFFSET;
@@ -2819,9 +2816,6 @@ exit_thread:
 		goto cont_thread;
 	}
 	mutex_unlock(&eli->li_list_mtx);
-	eli->li_task = NULL;
-	wake_up(&eli->li_wait_task);
-
 	kfree(ext4_li_info);
 	ext4_li_info = NULL;
 	mutex_unlock(&ext4_li_mtx);
@@ -2858,8 +2852,6 @@ static int ext4_run_lazyinit_thread(void)
 		return err;
 	}
 	ext4_li_info->li_state |= EXT4_LAZYINIT_RUNNING;
