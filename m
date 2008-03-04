From: Josef Bacik <jbacik@redhat.com>
Subject: [RFC PATCH 1/1] add a jbd option to force an unclean journal state
Date: Tue, 4 Mar 2008 13:39:41 -0500
Message-ID: <200803041339.42544.jbacik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759035AbYCDSwC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Mar 2008 13:52:02 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm fixing to go through and muck with some of the transaction handling stuff in 
jbd and I want a way to verify that I'm not screwing anything up in the 
process, and this is what I came up with.  Basically this option would only be 
used in the case where someone mounts an ext3 image or fs, does a specific IO 
operation (create 100 files, write data to a few files etc), unmounts the fs 
and remounts so that jbd does its journal recovery and then check the status of 
the fs to make sure its exactly the way its expected to be.  I'm not entirely 
sure how usefull of an option like this would be (or if I did it right :) ), 
but I thought I'd throw it out there in case anybody thinks it may be useful, 
and in case there is some case that I'm missing so I can fix it and better make 
sure I don't mess anything up while doing stuff.  Basically this patch keeps us 
from resetting the journal's tail/transaction sequence when we destroy the 
journal so when we mount the fs again it will look like we didn't unmount 
properly and recovery will occur.  Any comments are much appreciated,

Josef

Index: linux-2.6/fs/jbd/journal.c
===================================================================
--- linux-2.6.orig/fs/jbd/journal.c
+++ linux-2.6/fs/jbd/journal.c
@@ -1146,9 +1146,12 @@ void journal_destroy(journal_t *journal)
 	J_ASSERT(journal->j_checkpoint_transactions == NULL);
 	spin_unlock(&journal->j_list_lock);
 
-	/* We can now mark the journal as empty. */
-	journal->j_tail = 0;
-	journal->j_tail_sequence = ++journal->j_transaction_sequence;
+	if (!(journal->j_flags & JFS_UNCLEAN)) {
+		/* We can now mark the journal as empty. */
+		journal->j_tail = 0;
+		journal->j_tail_sequence = ++journal->j_transaction_sequence;
+	}
+
 	if (journal->j_sb_buffer) {
 		journal_update_superblock(journal, 1);
 		brelse(journal->j_sb_buffer);
Index: linux-2.6/include/linux/jbd.h
===================================================================
--- linux-2.6.orig/include/linux/jbd.h
+++ linux-2.6/include/linux/jbd.h
@@ -825,6 +825,7 @@ struct journal_s
 #define JFS_FLUSHED	0x008	/* The journal superblock has been flushed */
 #define JFS_LOADED	0x010	/* The journal superblock has been loaded */
 #define JFS_BARRIER	0x020	/* Use IDE barriers */
+#define JFS_UNCLEAN	0x040	/* Don't clean up the journal on umount */
 
 /*
  * Function declarations for the journaling transaction and buffer
Index: linux-2.6/fs/jbd/checkpoint.c
===================================================================
--- linux-2.6.orig/fs/jbd/checkpoint.c
+++ linux-2.6/fs/jbd/checkpoint.c
@@ -423,10 +423,14 @@ int cleanup_journal_tail(journal_t *jour
 	} else if ((transaction = journal->j_running_transaction) != NULL) {
 		first_tid = transaction->t_tid;
 		blocknr = journal->j_head;
-	} else {
+	} else if (!(journal->j_flags & JFS_UNCLEAN)) {
 		first_tid = journal->j_transaction_sequence;
 		blocknr = journal->j_head;
+	} else {
+		first_tid = journal->j_tail_sequence;
+		blocknr = journal->j_tail;
 	}
+
 	spin_unlock(&journal->j_list_lock);
 	J_ASSERT(blocknr != 0);
 
