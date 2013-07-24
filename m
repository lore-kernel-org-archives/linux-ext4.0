From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] debugfs: properly set up extent header in do_write
Date: Wed, 24 Jul 2013 10:11:25 -0500
Message-ID: <51EFEE9D.9070501@redhat.com>
References: <51EF975E.2090700@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Darren Hart <dvhart@linux.intel.com>
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3GXPLb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jul 2013 11:11:31 -0400
In-Reply-To: <51EF975E.2090700@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

do_write doesn't fully set up the first extent header on a new
inode, so if we write a 0-length file, and don't write any data
to the new file, we end up creating something that looks corrupt
to kernelspace:

EXT4-fs error (device loop0): ext4_ext_check_inode:464: inode #12: comm ls: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)

Do something similar to ext4_ext_tree_init() here, and
fill out the first extent header upon creation to avoid this.

Reported-by: Robert Yang <liezhi.yang@windriver.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index dcf16e2..2660218 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1677,8 +1677,19 @@ void do_write(int argc, char *argv[])
 	inode.i_links_count = 1;
 	inode.i_size = statbuf.st_size;
 	if (current_fs->super->s_feature_incompat &
-	    EXT3_FEATURE_INCOMPAT_EXTENTS)
+	    EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		int i;
+		struct ext3_extent_header *eh;
+
+		eh = (struct ext3_extent_header *) &inode.i_block[0];
+		eh->eh_depth = 0;
+		eh->eh_entries = 0;
+		eh->eh_magic = EXT3_EXT_MAGIC;
+		i = (sizeof(inode.i_block) - sizeof(*eh)) /
+			sizeof(struct ext3_extent);
+		eh->eh_max = ext2fs_cpu_to_le16(i);
 		inode.i_flags |= EXT4_EXTENTS_FL;
+	}
 	if (debugfs_write_new_inode(newfile, &inode, argv[0])) {
 		close(fd);
 		return;

