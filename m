From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] Fix oops with jbd-stats-through-procfs and external journal
Date: Thu, 25 Oct 2007 11:39:56 -0500
Message-ID: <4720C6DC.7010803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: johann.lombardi@bull.net, Mingming Cao <cmm@us.ibm.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762526AbXJYQlm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 12:41:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When using an external device for the journal,
jbd2_stats_proc_init() wants to use journal->j_dev in its call
to bdevname() but it's not assigned yet, resulting in an oops.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

--- linux.orig/fs/jbd2/journal.c	2007-10-25 11:36:25.772354262 -0500
+++ linux/fs/jbd2/journal.c	2007-10-25 11:36:35.058278242 -0500
@@ -1035,11 +1035,11 @@
 		journal = NULL;
 		goto out;
 	}
-	jbd2_stats_proc_init(journal);
 	journal->j_dev = bdev;
 	journal->j_fs_dev = fs_dev;
 	journal->j_blk_offset = start;
 	journal->j_maxlen = len;
+	jbd2_stats_proc_init(journal);
 
 	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
 	J_ASSERT(bh != NULL);
