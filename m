From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 05/47] debugfs: Dump inode checksum when appropriate
Date: Sat, 08 Oct 2011 00:33:47 -0700
Message-ID: <20111008073347.17888.6150.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:39660 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1JHHgk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:36:40 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987KgVV005506
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:20:42 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987Xo8v171712
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:33:50 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987Xmhp004128
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:33:50 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dump inode checksum when displaying inode info

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/debugfs.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 32a5864..d71de7d 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -792,6 +792,19 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
 		internal_dump_inode_extra(out, prefix, inode_num,
 					  (struct ext2_inode_large *) inode);
+	if (current_fs->super->s_creator_os == EXT2_OS_LINUX &&
+	    current_fs->super->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
+		__u32 crc = inode->i_checksum_lo;
+		if (is_large_inode &&
+		    large_inode->i_extra_isize >=
+				(offsetof(struct ext2_inode_large,
+					  i_checksum_hi) -
+				 EXT2_GOOD_OLD_INODE_SIZE))
+			crc |= ((__u32)large_inode->i_checksum_hi) << 16;
+		fprintf(out, "Inode checksum: 0x%08x\n", crc);
+	}
+
 	if (LINUX_S_ISLNK(inode->i_mode) && ext2fs_inode_data_blocks(current_fs,inode) == 0)
 		fprintf(out, "%sFast_link_dest: %.*s\n", prefix,
 			(int) inode->i_size, (char *)inode->i_block);

