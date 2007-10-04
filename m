From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] JBD2/Ext4: Convert kmalloc to kzalloc in jbd2/ext4
Date: Thu,  4 Oct 2007 01:50:38 -0400
Message-ID: <1191477059-5357-4-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
 <1191477059-5357-3-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44791 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXJDFvJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:09 -0400
In-Reply-To: <1191477059-5357-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Mingming Cao <cmm@us.ibm.com>

Convert kmalloc to kzalloc() and get rid of the memset().

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/xattr.c       |    3 +--
 fs/jbd2/journal.c     |    3 +--
 fs/jbd2/transaction.c |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b10d68f..12c7d65 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -750,12 +750,11 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */
-		s->base = kmalloc(sb->s_blocksize, GFP_KERNEL);
+		s->base = kzalloc(sb->s_blocksize, GFP_KERNEL);
 		/* assert(header == s->base) */
 		error = -ENOMEM;
 		if (s->base == NULL)
 			goto cleanup;
-		memset(s->base, 0, sb->s_blocksize);
 		header(s->base)->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
 		header(s->base)->h_blocks = cpu_to_le32(1);
 		header(s->base)->h_refcount = cpu_to_le32(1);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0e329a3..f12c65b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -654,10 +654,9 @@ static journal_t * journal_init_common (void)
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
+	journal = kzalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
 	if (!journal)
 		goto fail;
-	memset(journal, 0, sizeof(*journal));
 
 	init_waitqueue_head(&journal->j_wait_transaction_locked);
 	init_waitqueue_head(&journal->j_wait_logspace);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a5fb70f..b1fcf2b 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -96,13 +96,12 @@ static int start_this_handle(journal_t *journal, handle_t *handle)
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kmalloc(sizeof(*new_transaction),
+		new_transaction = kzalloc(sizeof(*new_transaction),
 						GFP_NOFS|__GFP_NOFAIL);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
 		}
-		memset(new_transaction, 0, sizeof(*new_transaction));
 	}
 
 	jbd_debug(3, "New handle %p going live.\n", handle);
-- 
1.5.3.2.81.g17ed
