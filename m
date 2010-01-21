From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] Add flag to files with blocks intentionally past EOF
Date: Thu, 21 Jan 2010 12:00:30 -0600
Message-ID: <4B58963E.4080007@redhat.com>
References: <4B5627EF.3080804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jiaying Zhang <jiayingz@google.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0AUSAk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jan 2010 13:00:40 -0500
In-Reply-To: <4B5627EF.3080804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jiaying Zhang <jiayingz@google.com>

fallocate() may potentially instantiate blocks past EOF, depending
on the flags used when it is called.

e2fsck currently has a test for blocks past i_size, and it
sometimes trips up - noticeably on xfstests 013 which runs fsstress.

This patch from Jiayang does fix it up - it (along with
e2fsprogs updates and other patches recently from Aneesh) has
survived many fsstress runs in a row.


(Eric Sandeen: removed ioctl interface and minor cleanups)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 874d169..1f6b936 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -284,6 +284,7 @@ struct flex_groups {
 #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 765a482..95e94ae 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3185,7 +3185,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent_header *eh;
-	struct ext4_extent newex, *ex;
+	struct ext4_extent newex, *ex, *last_ex;
 	ext4_fsblk_t newblock;
 	int err = 0, depth, ret, cache_type;
 	unsigned int allocated = 0;
@@ -3366,6 +3366,19 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 					EXT4_STATE_DIO_UNWRITTEN;;
 		}
 	}
+
+	if (unlikely(EXT4_I(inode)->i_flags & EXT4_EOFBLOCKS_FL)) {
+                if (eh->eh_entries) {
+			last_ex = EXT_LAST_EXTENT(eh);
+		    	if (iblock + ar.len > le32_to_cpu(last_ex->ee_block)
+					    + ext4_ext_get_actual_len(last_ex))
+				EXT4_I(inode)->i_flags &= ~EXT4_EOFBLOCKS_FL;
+		} else {
+                	WARN_ON(eh->eh_entries == 0);
+			ext4_error(inode->i_sb, __func__,
+				"inode#%lu, eh->eh_entries = 0!", inode->i_ino);
+		}
+	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
 		/* free data blocks we just allocated */
@@ -3499,6 +3512,13 @@ static void ext4_falloc_update_inode(struct inode *inode,
 			i_size_write(inode, new_size);
 		if (new_size > EXT4_I(inode)->i_disksize)
 			ext4_update_i_disksize(inode, new_size);
+	} else {
+		/*
+		 * Mark that we allocate beyond EOF so the subsequent truncate
+		 * can proceed even if the new size is the same as i_size.
+		 */
+		if (new_size > i_size_read(inode))
+			EXT4_I(inode)->i_flags |= EXT4_EOFBLOCKS_FL;
 	}
 
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cbf56da..f5802e9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4429,6 +4429,8 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;
 
+	EXT4_I(inode)->i_flags &= ~EXT4_EOFBLOCKS_FL;
+
 	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
 		ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;
 
@@ -5284,7 +5286,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (S_ISREG(inode->i_mode) &&
-	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
+	    attr->ia_valid & ATTR_SIZE &&
+	    (attr->ia_size < inode->i_size ||
+	     (EXT4_I(inode)->i_flags & EXT4_EOFBLOCKS_FL))) {
 		handle_t *handle;
 
 		handle = ext4_journal_start(inode, 3);
@@ -5315,6 +5319,9 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				goto err_out;
 			}
 		}
+		/* ext4_truncate will clear the flag */
+		if ((EXT4_I(inode)->i_flags & EXT4_EOFBLOCKS_FL))
+			ext4_truncate(inode);
 	}
 
 	rc = inode_setattr(inode, attr);

