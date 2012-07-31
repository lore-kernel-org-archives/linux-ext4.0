From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: use s_csum_seed instead of i_csum_seed for xattr block
Date: Tue, 31 Jul 2012 13:27:04 -0400
Message-ID: <1343755624-26583-2-git-send-email-tytso@mit.edu>
References: <1343755624-26583-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Tao Ma <boyu.mt@taobao.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42315 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab2GaR1I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 13:27:08 -0400
In-Reply-To: <1343755624-26583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

commit 41eb70dde42b2360074a559a6f1fc49860a50179 upstream.

In xattr block operation, we use h_refcount to indicate whether the
xattr block is shared among many inodes. And xattr block csum uses
s_csum_seed if it is shared and i_csum_seed if it belongs to
one inode. But this has a problem. So consider the block is shared
first bewteen inode A and B, and B has some xattr update and CoW
the xattr block. When it updates the *old* xattr block(because
of the h_refcount change) and calls ext4_xattr_release_block, we
has no idea that inode A is the real owner of the *old* xattr
block and we can't use the i_csum_seed of inode A either in xattr
block csum calculation. And I don't think we have an easy way to
find inode A.

So this patch just removes the tricky i_csum_seed and we now uses
s_csum_seed every time for the xattr block csum. The corresponding
patch for the e2fsprogs will be sent in another patch.

This is spotted by xfstests 117.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Darrick J. Wong <djwong@us.ibm.com>
---
[ Sorry, I forgot to tag these with stable@vger.kernel.org -- Ted ]

 fs/ext4/xattr.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e56c9ed..2cdb98d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -127,19 +127,16 @@ static __le32 ext4_xattr_block_csum(struct inode *inode,
 				    struct ext4_xattr_header *hdr)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct ext4_inode_info *ei = EXT4_I(inode);
 	__u32 csum, old;
 
 	old = hdr->h_checksum;
 	hdr->h_checksum = 0;
-	if (le32_to_cpu(hdr->h_refcount) != 1) {
-		block_nr = cpu_to_le64(block_nr);
-		csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&block_nr,
-				   sizeof(block_nr));
-	} else
-		csum = ei->i_csum_seed;
+	block_nr = cpu_to_le64(block_nr);
+	csum = ext4_chksum(sbi, sbi->s_csum_seed, (__u8 *)&block_nr,
+			   sizeof(block_nr));
 	csum = ext4_chksum(sbi, csum, (__u8 *)hdr,
 			   EXT4_BLOCK_SIZE(inode->i_sb));
+
 	hdr->h_checksum = old;
 	return cpu_to_le32(csum);
 }
-- 
1.7.12.rc0.22.gcdd159b

