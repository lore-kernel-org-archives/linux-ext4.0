From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd2: Add pid and journal device name to the "kjournald2 starting" message
Date: Sun,  4 Jan 2009 15:34:45 -0500
Message-ID: <1231101285-14003-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40635 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbZADUer (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Jan 2009 15:34:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/journal.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b10d728..fe20e40 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -131,8 +131,9 @@ static int kjournald2(void *arg)
 	journal->j_task = current;
 	wake_up(&journal->j_wait_done_commit);
 
-	printk(KERN_INFO "kjournald2 starting.  Commit interval %ld seconds\n",
-			journal->j_commit_interval / HZ);
+	printk(KERN_INFO "kjournald2 starting: pid %d, dev %s, "
+	       "commit interval %ld seconds\n", current->pid,
+	       journal->j_devname, journal->j_commit_interval / HZ);
 
 	/*
 	 * And now, wait forever for commit wakeup events.
-- 
1.6.0.4.8.g36f27.dirty

