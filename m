From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/37] debugfs: Dump inode checksum when appropriate
Date: Wed, 31 Aug 2011 17:35:56 -0700
Message-ID: <20110901003556.1176.61093.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49526 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab1IAAgB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:36:01 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 31 Aug 2011 20:36:01 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810ZwbG241046
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:35:58 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VKZi4O006054
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 17:35:45 -0300
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dump inode checksum when displaying inode info

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/debugfs.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index ad0789f..e1bbc6c 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -784,6 +784,11 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
 		internal_dump_inode_extra(out, prefix, inode_num,
 					  (struct ext2_inode_large *) inode);
+	if (current_fs->super->s_creator_os == EXT2_OS_LINUX &&
+	    current_fs->super->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+		fprintf(out, "Inode checksum: 0x%08x\n", inode->i_checksum);
+
 	if (LINUX_S_ISLNK(inode->i_mode) && ext2fs_inode_data_blocks(current_fs,inode) == 0)
 		fprintf(out, "%sFast_link_dest: %.*s\n", prefix,
 			(int) inode->i_size, (char *)inode->i_block);

