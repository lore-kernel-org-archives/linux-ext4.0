From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 05/51] debugfs: Dump inode checksum when appropriate
Date: Tue, 13 Dec 2011 17:13:50 -0800
Message-ID: <20111214011350.20947.50839.stgit@elm3c44.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51128 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab1LNBOM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 20:14:12 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 20:14:11 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1DrOU286378
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:13:53 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1Dpes012600
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:13:53 -0500
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dump inode checksum when displaying inode info

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/debugfs.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 419c76c..1d2b2f3 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -803,6 +803,19 @@ void internal_dump_inode(FILE *out, const char *prefix,
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

