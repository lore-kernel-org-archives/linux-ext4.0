From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: [PATCH v2] ext4: add checks of block references for non-extent inodes
Date: Fri, 20 Mar 2009 15:15:56 +0100
Message-ID: <49C3A51C.1030201@ph.tum.de>
References: <49B94396.2020800@ph.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050703030800000200040908"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:35627 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbZCTOQF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Mar 2009 10:16:05 -0400
In-Reply-To: <49B94396.2020800@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050703030800000200040908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Ted,

I'm sending an improved patch as I've come to the conclusion that the 
previous patch is too lenient in two ways:
* off-by-one in the check of the upper block limit
* it shouldn't stop when encountering a reference to block number zero 
because, if I'm not mistaken, references behind it still might be 
accessed in sparse files / when seeking behind the end of a file.

On the other hand, I decided to drop the check against 
s_first_data_block at the low end to improve performance, since the 
purpose of the patch is to prevent access to blocks outside the 
filesystem, and not to do the best-possible consistency check against 
indirect blocks, which probably is better done in fsck.

Anyways, in case you would be interested in having more checks here (eg. 
as a compile-time option), I have available a more sophisticated patch 
which also checks for non-zero block references behind the end of the file.

Kind regards,

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>



--------------050703030800000200040908
Content-Type: text/plain;
 name="add-blockref-checks.patch2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-blockref-checks.patch2"

--- linux-2.6.29-rc7/fs/ext4/inode.c.orig	2009-03-20 11:35:45.000000000 +0100
+++ linux-2.6.29-rc7/fs/ext4/inode.c	2009-03-20 13:48:25.000000000 +0100
@@ -371,6 +371,34 @@
 	return n;
 }
 
+static int __ext4_check_blockref(const char *function, struct inode *inode,
+				 unsigned int *p, unsigned int max) {
+
+	unsigned int maxblocks = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es);
+	unsigned int *bref = p;
+	while (bref < p+max) {
+		if (unlikely(*bref >= maxblocks)) {
+			ext4_error(inode->i_sb, function,
+				   "block reference %u >= max (%u) "
+				   "in inode #%lu, offset=%u",
+				   *bref, maxblocks,
+				   inode->i_ino, bref-p);
+ 			return -EIO;
+ 		}
+		bref++;
+ 	}
+ 	return 0;
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
--------------050703030800000200040908--
