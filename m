From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: [PATCH] ext4: add checks of block references for non-extent inodes
Date: Thu, 12 Mar 2009 18:17:10 +0100
Message-ID: <49B94396.2020800@ph.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090208080305050304040301"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:45623 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbZCLRRN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 13:17:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090208080305050304040301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Ted,

this follows your suggestion from 2009-02-05.  The patch is done 
analogous to Aneesh Kumar's patches for extent validation.  It is based 
on 2.6.29-rc7 with Aneesh's patches:
ext4: Add checks to validate extent entries
ext4: Validate extent details only when read from the disk

Kind regards,

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>

--------------090208080305050304040301
Content-Type: text/x-patch;
 name="add-blockrefs-checks_vs_2.6.29-rc7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-blockrefs-checks_vs_2.6.29-rc7.patch"

--- download/linux-2.6.29-rc7-vanilla-extcheck/fs/ext4/inode.c	2009-03-12 16:10:31.000000000 +0100
+++ linux-2.6.29-rc7/fs/ext4/inode.c	2009-03-12 16:09:27.000000000 +0100
@@ -371,6 +371,34 @@
 	return n;
 }
 
+static int __ext4_check_blockref(const char *function, struct inode *inode,
+				 unsigned int *p, unsigned int max) {
+
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
+	unsigned int offset = 0;
+	while (offset < max && p[offset]) {
+		if (unlikely(p[offset] < le32_to_cpu(es->s_first_data_block) ||
+			     (p[offset] > ext4_blocks_count(es)))) {
+			ext4_error(inode->i_sb, function,
+				   "bad block reference in inode #%lu, "
+				   "offset=%u, blockref=%u",
+				   inode->i_ino, offset, p[offset]);
+			return -EIO;
+		}
+		offset++;
+	}
+	return 0;
+}
+
+
+#define ext4_check_indirect_blockref(inode, bh)                         \
+        __ext4_check_blockref(__func__, inode, (__le32 *)(bh)->b_data,  \
+			      EXT4_ADDR_PER_BLOCK((inode)->i_sb))
+
+#define ext4_check_inode_blockref(inode)                                \
+        __ext4_check_blockref(__func__, inode, EXT4_I(inode)->i_data,   \
+			      EXT4_NDIR_BLOCKS)
+
 /**
  *	ext4_get_branch - read the chain of indirect blocks leading to data
  *	@inode: inode in question
@@ -418,6 +446,9 @@
 		bh = sb_bread(sb, le32_to_cpu(p->key));
 		if (!bh)
 			goto failure;
+		if (ext4_check_indirect_blockref(inode, bh))
+			goto failure;
+                  
 		add_chain(++p, bh, (__le32 *)bh->b_data + *++offsets);
 		/* Reader: end */
 		if (!p->key)
@@ -4302,11 +4333,13 @@
 	if (ei->i_flags & EXT4_EXTENTS_FL) {
 		/* Validate extent which is part of inode */
 		ret = ext4_ext_check_inode(inode);
-		if (ret) {
-			brelse(bh);
-			goto bad_inode;
-		}
--------------090208080305050304040301--
