From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/3] ext4: (V2) store maxbytes for bitmapped  files and
 return EFBIG as appropriate
Date: Tue, 04 Dec 2007 13:31:01 -0600
Message-ID: <4755AAF5.3010607@redhat.com>
References: <47557870.9060405@redhat.com> <475579A2.2090301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbXLDTbC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2007 14:31:02 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB4JV2DI010932
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 14:31:02 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB4JV1gS010239
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 14:31:01 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB4JV119029763
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 14:31:01 -0500
In-Reply-To: <475579A2.2090301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Crud, minor off-by-one in ext4_file_write.  V2 below:

===============================

Calculate & store the max offset for bitmapped files, and
catch too-large seeks, truncates, and writes in ext4, shortening
or rejecting as appropriate.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc3/fs/ext4/super.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ext4/super.c
+++ linux-2.6.24-rc3/fs/ext4/super.c
@@ -1979,6 +1979,7 @@ static int ext4_fill_super (struct super
 		}
 	}
 
+	sbi->s_bitmap_maxbytes = ext4_max_bitmap_size(sb->s_blocksize_bits);
 	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
Index: linux-2.6.24-rc3/fs/ext4/file.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ext4/file.c
+++ linux-2.6.24-rc3/fs/ext4/file.c
@@ -56,8 +56,29 @@ ext4_file_write(struct kiocb *iocb, cons
 	ssize_t ret;
 	int err;
 
-	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+	/*
+ 	 * If we have encountered a bitmap-format file, the size limit
+	 * is smaller than s_maxbytes, which is for extent-mapped files.
+	 */
 
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)) {
+		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+		size_t length = iov_length(iov, nr_segs);
+
+		if (pos >= sbi->s_bitmap_maxbytes) {
+			if (length || pos > sbi->s_bitmap_maxbytes) {
+				return -EFBIG;
+			}
+			/* zero-length writes at maxbytes are OK */
+		}
+
+		if (pos + length > sbi->s_bitmap_maxbytes) {
+			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
+					      sbi->s_bitmap_maxbytes - pos);
+		}
+	}
+
+	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
 	/*
 	 * Skip flushing if there was an error, or if nothing was written.
 	 */
Index: linux-2.6.24-rc3/fs/ext4/inode.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/ext4/inode.c
+++ linux-2.6.24-rc3/fs/ext4/inode.c
@@ -309,7 +309,9 @@ static int ext4_block_to_path(struct ino
 		offsets[n++] = i_block & (ptrs - 1);
 		final = ptrs;
 	} else {
-		ext4_warning(inode->i_sb, "ext4_block_to_path", "block > big");
+		ext4_warning(inode->i_sb, "ext4_block_to_path", "block %u > max",
+				i_block + direct_blocks +
+				indirect_blocks + double_blocks);
 	}
 	if (boundary)
 		*boundary = final - 1 - (i_block & (ptrs - 1));
@@ -3212,6 +3214,17 @@ int ext4_setattr(struct dentry *dentry, 
 		ext4_journal_stop(handle);
 	}
 
+	if (attr->ia_valid & ATTR_SIZE) {
+		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)) {
+			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+
+			if (attr->ia_size > sbi->s_bitmap_maxbytes) {
+				error = -EFBIG;
+				goto err_out;
+			}
+		}
+	}
+
 	if (S_ISREG(inode->i_mode) &&
 	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
 		handle_t *handle;
Index: linux-2.6.24-rc3/include/linux/ext4_fs_sb.h
===================================================================
--- linux-2.6.24-rc3.orig/include/linux/ext4_fs_sb.h
+++ linux-2.6.24-rc3/include/linux/ext4_fs_sb.h
@@ -38,6 +38,7 @@ struct ext4_sb_info {
 	ext4_group_t s_groups_count;	/* Number of groups in the fs */
 	unsigned long s_overhead_last;  /* Last calculated overhead */
 	unsigned long s_blocks_last;    /* Last seen block count */
+	loff_t s_bitmap_maxbytes;	/* max bytes for bitmap files */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
