From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH] Endianness bugs in e2fsck
Date: Wed, 20 Jun 2007 15:03:08 +0530
Message-ID: <1182331988.9772.7.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: TheodoreTso <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:36989 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbXFTJcs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2007 05:32:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In ext2fs_swap_inode_full() if to and from inodes are not the same (which is the case when called from e2fsck_get_next_inode_full), then e2fsck cannot recognize any in-inode EAs since the un-swabbed i_extra_isize was being used. So corrected that to use swabbed values all the time.

Also in ext2fs_read_inode_full(), ext2fs_swap_inode_full() should be called with bufsize instead of with length argument. length was coming out to be 128 even with 512 byte inodes thus leaving the rest of the inode unswabbed.

On big-endian machines, ext2fs_get_next_inode_full() calls this for copying the inode:
ext2fs_swap_inode_full(scan->fs,
		       (struct ext2_inode_large *) inode,
		       (struct ext2_inode_large *) scan->ptr,
			0, bufsize);
In ext2fs_swap_inode_full() only the first (GOOD_OLD_INODE_SIZE + i_extra_isize)bytes are copied into inode. The rest of the inode is not zeroed. So memset the inode to zero if swapfs is enabled. On little endian machines, memcpy(inode, scan->ptr, bufsize); is executed thereby hiding this error.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: e2fsprogs-1.39/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/swapfs.c     2007-06-19 22:31:20.000000000 -0700
+++ e2fsprogs-1.39/lib/ext2fs/swapfs.c  2007-06-19 22:41:43.628732192 -0700
@@ -261,13 +261,13 @@ void ext2fs_swap_inode_full(ext2_filsys
                return; /* no space for EA magic */

        eaf = (__u32 *) (((char *) f) + sizeof(struct ext2_inode) +
-                                       f->i_extra_isize);
+                                       t->i_extra_isize);

        if (ext2fs_swab32(*eaf) != EXT2_EXT_ATTR_MAGIC)
                return; /* it seems no magic here */

        eat = (__u32 *) (((char *) t) + sizeof(struct ext2_inode) +
-                                       f->i_extra_isize);
+                                       t->i_extra_isize);
        *eat = ext2fs_swab32(*eaf);

        /* convert EA(s) */
Index: e2fsprogs-1.39/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/inode.c      2007-06-19 22:31:21.000000000 -0700
+++ e2fsprogs-1.39/lib/ext2fs/inode.c   2007-06-20 01:06:18.017788976 -0700
@@ -471,6 +471,7 @@ errcode_t ext2fs_get_next_inode_full(ext
                scan->bytes_left -= scan->inode_size - extra_bytes;

 #ifdef EXT2FS_ENABLE_SWAPFS
+               memset(inode, 0, bufsize);
                if ((scan->fs->flags & EXT2_FLAG_SWAP_BYTES) ||
                    (scan->fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
                        ext2fs_swap_inode_full(scan->fs,
@@ -485,6 +486,7 @@ errcode_t ext2fs_get_next_inode_full(ext
                scan->scan_flags &= ~EXT2_SF_BAD_EXTRA_BYTES;
        } else {
 #ifdef EXT2FS_ENABLE_SWAPFS
+               memset(inode, 0, bufsize);
                if ((scan->fs->flags & EXT2_FLAG_SWAP_BYTES) ||
                    (scan->fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
                        ext2fs_swap_inode_full(scan->fs,
@@ -603,7 +605,7 @@ errcode_t ext2fs_read_inode_full(ext2_fi
            (fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
                ext2fs_swap_inode_full(fs, (struct ext2_inode_large *) inode,
                                       (struct ext2_inode_large *) inode,
-                                      0, length);
+                                      0, bufsize);
 #endif

        /* Update the inode cache */
