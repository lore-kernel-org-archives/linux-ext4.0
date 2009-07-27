From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] JBD2: round commit timer up to avoid uncommitted	transaction
Date: Mon, 27 Jul 2009 14:22:09 -0600
Message-ID: <20090727202209.GU4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Alex Zhuravlev <Alex.Zhuravlev@sun.com>
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63076 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZG0UWl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jul 2009 16:22:41 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6RKMeHG025862
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2009 13:22:40 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KNG00500IX8JV00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 27 Jul 2009 13:22:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jbd and jbd2 fixes: fix jiffie rounding in jbd commit timer setup code.
Rounding down could cause the timer to be fired before the corresponding
transaction has expired.  That transaction can stay not committed forever if
no new transaction is created or expicit sync/umount happens.

Signed-off-by: Alex Zhuravlev (Tomas) <alex.zhuravlev@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: linux-2.6.27.21-0.1/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.27.21-0.1.orig/fs/jbd2/transaction.c	2009-06-10 11:11:41.000000000 -0600
+++ linux-2.6.27.21-0.1/fs/jbd2/transaction.c	2009-06-10 11:12:32.000000000 -0600
@@ -54,7 +54,7 @@
 	INIT_LIST_HEAD(&transaction->t_inode_list);
 
 	/* Set up the commit timer for the new transaction. */
-	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
+	journal->j_commit_timer.expires = round_jiffies_up(transaction->t_expires);
 	add_timer(&journal->j_commit_timer);
 
 	J_ASSERT(journal->j_running_transaction == NULL);

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

