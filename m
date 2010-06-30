From: "Amir G." <amir73il@users.sourceforge.net>
Subject: yet another Next3 on-disk format change request
Date: Wed, 30 Jun 2010 19:16:34 +0300
Message-ID: <AANLkTimlQ6JTZnL9V3KAK-6L3ZZn7UBwAiEIvfoszSlH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61750 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab0F3QQg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2010 12:16:36 -0400
Received: by bwz1 with SMTP id 1so462322bwz.19
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jun 2010 09:16:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I have another on-disk format change request.
This time I would like to add 3 extra i_block fields to the ext4 large
inode struct.
I have a patch that enables snapshots on 16TB file systems.
The patch uses the huge_file feature to break the 2TB i_blocks limit
and 3 extra triple indirect blocks to map offsets 4TB to 16TB of the
file system.

As a matter of fact, I stored the 3 extra blocks in direct blocks 0-2.
Direct blocks are not in use by snapshot files, so there is a waste of
12 empty i_block fields.
However, for the long run, I think that putting them in the inode
extra space is a better idea (please see attached patch).
Putting the extra blocks on extra inode space would mean that user
with file system >4TB and inode size 128,
would not be able to use snapshots, but that's ok with me.

Please let me know if you can accept this change or if you think
that using the empty direct blocks is a better idea.

Amir.

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index c1c9231..f1a5c68 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -254,6 +254,18 @@ struct ext2_dx_countlimit {
 #define EXT2_DIND_BLOCK                        (EXT2_IND_BLOCK + 1)
 #define EXT2_TIND_BLOCK                        (EXT2_DIND_BLOCK + 1)
 #define EXT2_N_BLOCKS                  (EXT2_TIND_BLOCK + 1)
+/*
+ * Snapshot files have larger indirection mapping that can map up to 2^32
+ * logical blocks, so they can cover the filesystem block address space.
+ * Next3 must use either 4K or 8K blocks (depending on PAGE_SIZE).
+ * With 8K blocks, 1 triple indirect block maps 2^33 logical blocks.
+ * With 4K blocks (the system default), each triple indirect block maps 2^30
+ * logical blocks, so 3 extra triple indirect blocks are needed to map the
+ * entire filesystem.
+ */
+#define EXT2_EXTRA_TIND_BLOCKS         3
+#define EXT2_SNAPFILE_BLOCKS           (EXT2_N_BLOCKS + EXT2_EXTRA_TIND_BLOCKS)
+

 /*
  * Inode flags
@@ -430,6 +442,8 @@ struct ext2_inode_large {
        __u32   i_crtime;       /* File creation time */
        __u32   i_crtime_extra; /* extra File creation time (nsec << 2
| epoch)*/
        __u32   i_version_hi;   /* high 32 bits for 64-bit version */
+       __u32   i_block_extra[EXT2_EXTRA_TIND_BLOCKS]; /* extra
Pointers to blocks
+                                               (snapshot file offset
4TB..16TB) */
 };

 #define i_dir_acl      i_size_high
