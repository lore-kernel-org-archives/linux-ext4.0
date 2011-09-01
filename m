From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 33/37] tune2fs: Rewrite extended attribute block checksums
Date: Wed, 31 Aug 2011 17:38:43 -0700
Message-ID: <20110901003843.1176.69266.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48234 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071Ab1IAAiq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:38:46 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810EawB027420
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:14:36 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810cjrT236234
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:38:45 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810ciQ0018466
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:38:45 -0400
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When enabling metadata checksums, rewrite separate extended attribute blocks.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 5663e49..60c1a6a 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -589,11 +589,13 @@ errcode_t rewrite_directory(ext2_filsys fs, ext2_ino_t dir,
  */
 static void rewrite_inodes(ext2_filsys fs)
 {
+	char		*ea_buf;
 	char		buf[EXT2_INODE_CORE_SIZE(fs->super)];
 	struct ext2_inode_large *inode = (struct ext2_inode_large *)buf;
 	ext2_inode_scan	scan;
 	errcode_t	retval;
 	ext2_ino_t	ino;
+	blk64_t		file_acl_block;
 
 	if (fs->super->s_creator_os != EXT2_OS_LINUX)
 		return;
@@ -604,6 +606,12 @@ static void rewrite_inodes(ext2_filsys fs)
 		exit(1);
 	}
 
+	retval = ext2fs_get_mem(fs->blocksize, &ea_buf);
+	if (retval) {
+		com_err("set_csum", retval, "while allocating memory");
+		exit(1);
+	}
+
 	do {
 		retval = ext2fs_get_next_inode(scan, &ino, inode);
 		if (retval) {
@@ -633,7 +641,25 @@ static void rewrite_inodes(ext2_filsys fs)
 				exit(1);
 			}
 		}
+
+		file_acl_block = ext2fs_file_acl_block(inode);
+		if (!file_acl_block)
+			continue;
+		retval = ext2fs_read_ext_attr2(fs, file_acl_block, ea_buf);
+		if (retval) {
+			com_err("rewrite_eablock", retval,
+				"while rewriting extended attribute");
+			exit(1);
+		}
+		retval = ext2fs_write_ext_attr2(fs, file_acl_block, ea_buf);
+		if (retval) {
+			com_err("rewrite_eablock", retval,
+				"while rewriting extended attribute");
+			exit(1);
+		}
 	} while (ino);
+
+	ext2fs_free_mem(&ea_buf);
 	ext2fs_close_inode_scan(scan);
 }
 

