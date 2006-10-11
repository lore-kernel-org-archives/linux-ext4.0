From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: [PATCH] null dereference in fs/jbd2/journal.c
Date: Wed, 11 Oct 2006 15:17:07 -0500
Message-ID: <1160597827.12884.15.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161222AbWJKURN@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is Eric Sesterhenn's jbd patch applied to jbd2.
Commit: 41716c7c21b15e7ecf14f0caf1eef3980707fb74

His words:

Since commit d1807793e1e7e502e3dc047115e9dbc3b50e4534 we dereference a NULL
pointer.  Coverity id #1432.  We set journal to NULL, and use it directly
afterwards.

Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 10db92c..c60f378 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -725,6 +725,7 @@ journal_t * jbd2_journal_init_dev(struct
 			__FUNCTION__);
 		kfree(journal);
 		journal = NULL;
+		goto out;
 	}
 	journal->j_dev = bdev;
 	journal->j_fs_dev = fs_dev;
@@ -735,7 +736,7 @@ journal_t * jbd2_journal_init_dev(struct
 	J_ASSERT(bh != NULL);
 	journal->j_sb_buffer = bh;
 	journal->j_superblock = (journal_superblock_t *)bh->b_data;
-
+out:
 	return journal;
 }
 

-- 
David Kleikamp
IBM Linux Technology Center
