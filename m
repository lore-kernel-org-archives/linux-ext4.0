From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 02/40] ext4: Fix BUG_ON at fs/buffer.c:652 in no journal mode
Date: Tue,  1 Jun 2010 08:02:49 -0400
Message-ID: <1275393807-14369-2-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47268 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Curt Wohlgemuth <curtw@google.com>

commit 73b50c1c92666d326b5fa2c945d46509f2f6d91f upstream (as of v2.6.33-git11)

Calls to ext4_handle_dirty_metadata should only pass in an inode
pointer for inode-specific metadata, and not for shared metadata
blocks such as inode table blocks, block group descriptors, the
superblock, etc.

The BUG_ON can get tripped when updating a special device (such as a
block device) that is opened (so that i_mapping is set in
fs/block_dev.c) and the file system is mounted in no journal mode.

Addresses-Google-Bug: #2404870

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4_jbd2.c |    2 +-
 fs/ext4/ialloc.c    |    2 +-
 fs/ext4/inode.c     |    6 +++---
 fs/ext4/namei.c     |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index b57e5c7..98033d9 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -125,7 +125,7 @@ int __ext4_handle_dirty_metadata(const char *where, handle_t *handle,
 			ext4_journal_abort_handle(where, __func__, bh,
 						  handle, err);
 	} else {
-		if (inode && bh)
+		if (inode)
 			mark_buffer_dirty_inode(bh, inode);
 		else
 			mark_buffer_dirty(bh);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2fab5ad..179e45c 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -904,7 +904,7 @@ repeat_in_this_group:
 				BUFFER_TRACE(inode_bitmap_bh,
 					"call ext4_handle_dirty_metadata");
 				err = ext4_handle_dirty_metadata(handle,
-								 inode,
+								 NULL,
 							inode_bitmap_bh);
 				if (err)
 					goto fail;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6a7694e..7128506 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5102,7 +5102,7 @@ static int ext4_do_update_inode(handle_t *handle,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
 			sb->s_dirt = 1;
 			ext4_handle_sync(handle);
-			err = ext4_handle_dirty_metadata(handle, inode,
+			err = ext4_handle_dirty_metadata(handle, NULL,
 					EXT4_SB(sb)->s_sbh);
 		}
 	}
@@ -5131,7 +5131,7 @@ static int ext4_do_update_inode(handle_t *handle,
 	}
 
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-	rc = ext4_handle_dirty_metadata(handle, inode, bh);
+	rc = ext4_handle_dirty_metadata(handle, NULL, bh);
 	if (!err)
 		err = rc;
 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
@@ -5685,7 +5685,7 @@ static int ext4_pin_inode(handle_t *handle, struct inode *inode)
 			err = jbd2_journal_get_write_access(handle, iloc.bh);
 			if (!err)
 				err = ext4_handle_dirty_metadata(handle,
-								 inode,
+								 NULL,
 								 iloc.bh);
 			brelse(iloc.bh);
 		}
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 17a17e1..8bd1e20 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2024,7 +2024,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
-	err = ext4_handle_dirty_metadata(handle, inode, EXT4_SB(sb)->s_sbh);
+	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
 		err = rc;
@@ -2096,7 +2096,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		if (err)
 			goto out_brelse;
 		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
-		err = ext4_handle_dirty_metadata(handle, inode, sbi->s_sbh);
+		err = ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
 	} else {
 		struct ext4_iloc iloc2;
 		struct inode *i_prev =
-- 
1.6.6.1.1.g974db.dirty

