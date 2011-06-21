From: amir73il@users.sourceforge.net
Subject: [PATCH 3/4] ext4: clone indirect.c file from inode.c
Date: Tue, 21 Jun 2011 12:39:27 +0300
Message-ID: <1308649168-12543-4-git-send-email-amir73il@users.sourceforge.net>
References: <1308649168-12543-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62796 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab1FUJjy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 05:39:54 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so2252744wyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 02:39:53 -0700 (PDT)
In-Reply-To: <1308649168-12543-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

The next patch is going to move ext4_ind_ functions to
indirect.c. First, we clone the file from inode.c and
only leave code that is going to be duplicated in both files.
This should keep the deleted lines count from inode.c in the next
patch the same as the added lines count to indirect.c.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/indirect.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 fs/ext4/indirect.c

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
new file mode 100644
index 0000000..98cf221
--- /dev/null
+++ b/fs/ext4/indirect.c
@@ -0,0 +1,92 @@
+/*
+ *  linux/fs/ext4/indirect.c
+ *
+ *  from
+ *
+ *  linux/fs/ext4/inode.c
+ *
+ * Copyright (C) 1992, 1993, 1994, 1995
+ * Remy Card (card@masi.ibp.fr)
+ * Laboratoire MASI - Institut Blaise Pascal
+ * Universite Pierre et Marie Curie (Paris VI)
+ *
+ *  from
+ *
+ *  linux/fs/minix/inode.c
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ *  Goal-directed block allocation by Stephen Tweedie
+ *	(sct@redhat.com), 1993, 1998
+ *  Big-endian to little-endian byte-swapping/bitmaps by
+ *        David S. Miller (davem@caip.rutgers.edu), 1995
+ *  64-bit file support on 64-bit platforms by Jakub Jelinek
+ *	(jj@sunsite.ms.mff.cuni.cz)
+ *
+ *  Assorted race fixes, rewrite of ext4_get_block() by Al Viro, 2000
+ */
+
+#include <linux/module.h>
+#include "ext4_jbd2.h"
+
+#include <trace/events/ext4.h>
+
+static int __ext4_check_blockref(const char *function, unsigned int line,
+				 struct inode *inode,
+				 __le32 *p, unsigned int max)
+{
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
+	__le32 *bref = p;
+	unsigned int blk;
+
+	while (bref < p+max) {
+		blk = le32_to_cpu(*bref++);
+		if (blk &&
+		    unlikely(!ext4_data_block_valid(EXT4_SB(inode->i_sb),
+						    blk, 1))) {
+			es->s_last_error_block = cpu_to_le64(blk);
+			ext4_error_inode(inode, function, line, blk,
+					 "invalid block");
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
+
+/*
+ * Truncate blocks that were not used by write. We have to truncate the
+ * pagecache as well so that corresponding buffers get properly unmapped.
+ */
+static void ext4_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	ext4_truncate(inode);
+}
+
+/*
+ * Work out how many blocks we need to proceed with the next chunk of a
+ * truncate transaction.
+ */
+static unsigned long blocks_for_truncate(struct inode *inode)
+{
+	ext4_lblk_t needed;
+
+	needed = inode->i_blocks >> (inode->i_sb->s_blocksize_bits - 9);
+
+	/* Give ourselves just enough room to cope with inodes in which
+	 * i_blocks is corrupt: we've seen disk corruptions in the past
+	 * which resulted in random data in an inode which looked enough
+	 * like a regular file for ext4 to try to delete it.  Things
+	 * will go a bit crazy if that happens, but at least we should
+	 * try not to panic the whole kernel. */
+	if (needed < 2)
+		needed = 2;
+
+	/* But we need to bound the transaction so we don't overflow the
+	 * journal. */
+	if (needed > EXT4_MAX_TRANS_DATA)
+		needed = EXT4_MAX_TRANS_DATA;
+
+	return EXT4_DATA_TRANS_BLOCKS(inode->i_sb) + needed;
+}
-- 
1.7.4.1

