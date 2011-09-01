From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 32/37] libext2fs: Extend inode checksum to cover the EA block
Date: Wed, 31 Aug 2011 17:38:36 -0700
Message-ID: <20110901003836.1176.13428.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34513 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab1IAAik (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:38:40 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810Of9i023000
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:24:41 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810ceDe2900074
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:38:40 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810cbvr012197
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 21:38:39 -0300
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that e2fsprogs knows to read the entire s_inode_size, change the inode
checksum code to checksum the entire block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/csum.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 4fe4b3d..dc87de3 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -478,14 +478,9 @@ __u32 ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
 {
 	struct ext2_inode_large *desc = inode;
 	int offset = offsetof(struct ext2_inode_large, i_checksum);
-	int extra_size = inode->i_extra_isize;
 	size_t size = fs->super->s_inode_size;
 	__u32 crc = 0;
 
-	if (size < EXT2_GOOD_OLD_INODE_SIZE + extra_size)
-		printf("ERROR: inode %d size %d != extra_size %d!\n", inum,
-		       size, extra_size + EXT2_GOOD_OLD_INODE_SIZE);
