From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCHv4 5/5] ext4: simplify superblock dirtying
Date: Wed,  4 Jul 2012 15:21:54 +0300
Message-ID: <1341404514-13660-6-git-send-email-dedekind1@gmail.com>
References: <1341404514-13660-1-git-send-email-dedekind1@gmail.com>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45031 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab2GDMUa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jul 2012 08:20:30 -0400
In-Reply-To: <1341404514-13660-1-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The '__ext4_handle_dirty_metadata()' takes a 'now' argument which does not add
any value anymore (after we removed 'ext4_write_super()'). First of all, it
only affects the non-journalled file-system case.
1. If 'now' is true, we just re-calculate the superblock checksum and submit
   it down for asynchronous I/O.
2. If 'now' is false, we call 'ext4_commit_super()' which essentially does the
   same, but it performs better error checking and additionally updates few
   counters like 's_kbytes_written'.

So we can simplify the code a bit by killing the 'now' argument.

This change was suggested by Jan Kara <jack@suse.cz>.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/ext4_jbd2.c |    7 +------
 fs/ext4/ext4_jbd2.h |    7 ++-----
 fs/ext4/inode.c     |    2 +-
 fs/ext4/namei.c     |    4 ++--
 fs/ext4/resize.c    |    2 +-
 5 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 27354df..ce169e6 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -138,8 +138,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 }
 
 int __ext4_handle_dirty_super(const char *where, unsigned int line,
-			      handle_t *handle, struct super_block *sb,
-			      int now)
+			      handle_t *handle, struct super_block *sb)
 {
 	struct buffer_head *bh = EXT4_SB(sb)->s_sbh;
 	int err = 0;
@@ -151,10 +150,6 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__,
 						  bh, handle, err);
-	} else if (now) {
-		ext4_superblock_csum_set(sb,
-				(struct ext4_super_block *)bh->b_data);
-		mark_buffer_dirty(bh);
 	} else
 		err = ext4_commit_super(sb, 0);
 	return err;
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index f440e8f1..83b20fc 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -213,8 +213,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 				 struct buffer_head *bh);
 
 int __ext4_handle_dirty_super(const char *where, unsigned int line,
-			      handle_t *handle, struct super_block *sb,
-			      int now);
+			      handle_t *handle, struct super_block *sb);
 
 #define ext4_journal_get_write_access(handle, bh) \
 	__ext4_journal_get_write_access(__func__, __LINE__, (handle), (bh))
@@ -226,10 +225,8 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 #define ext4_handle_dirty_metadata(handle, inode, bh) \
 	__ext4_handle_dirty_metadata(__func__, __LINE__, (handle), (inode), \
 				     (bh))
-#define ext4_handle_dirty_super_now(handle, sb) \
-	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb), 1)
 #define ext4_handle_dirty_super(handle, sb) \
-	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb), 0)
+	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))
 
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 02bc8cb..b1bd96f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4034,7 +4034,7 @@ static int ext4_do_update_inode(handle_t *handle,
 			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
 			ext4_handle_sync(handle);
-			err = ext4_handle_dirty_super_now(handle, sb);
+			err = ext4_handle_dirty_super(handle, sb);
 		}
 	}
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5845cd9..f155d57 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2397,7 +2397,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
 	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
-	err = ext4_handle_dirty_super_now(handle, sb);
+	err = ext4_handle_dirty_super(handle, sb);
 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
 	if (!err)
 		err = rc;
@@ -2470,7 +2470,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		if (err)
 			goto out_brelse;
 		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
-		err = ext4_handle_dirty_super_now(handle, inode->i_sb);
+		err = ext4_handle_dirty_super(handle, inode->i_sb);
 	} else {
 		struct ext4_iloc iloc2;
 		struct inode *i_prev =
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 7ea6cbb..09c7aae 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -798,7 +798,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	ext4_kvfree(o_group_desc);
 
 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
-	err = ext4_handle_dirty_super_now(handle, sb);
+	err = ext4_handle_dirty_super(handle, sb);
 	if (err)
 		ext4_std_error(sb, err);
 
-- 
1.7.7.6

