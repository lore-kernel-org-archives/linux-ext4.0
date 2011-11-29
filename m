From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 30/50] tune2fs: Rewrite extended attribute block checksums
Date: Mon, 28 Nov 2011 16:31:21 -0800
Message-ID: <20111129003121.17953.21055.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:42408 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab1K2AcU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 19:32:20 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 17:32:19 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0Veb6113198
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:31:40 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0VV4M013019
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:31:40 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When enabling metadata checksums, rewrite separate extended attribute blocks.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 236a324..4b91192 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -609,9 +609,11 @@ static void rewrite_inodes(ext2_filsys fs)
 {
 	int length = EXT2_INODE_SIZE(fs->super);
 	struct ext2_inode *inode;
+	char		*ea_buf;
 	ext2_inode_scan	scan;
 	errcode_t	retval;
 	ext2_ino_t	ino;
+	blk64_t		file_acl_block;
 
 	if (fs->super->s_creator_os != EXT2_OS_LINUX)
 		return;
@@ -628,6 +630,12 @@ static void rewrite_inodes(ext2_filsys fs)
 		exit(1);
 	}
 
+	retval = ext2fs_get_mem(fs->blocksize, &ea_buf);
+	if (retval) {
+		com_err("set_csum", retval, "while allocating memory");
+		exit(1);
+	}
+
 	do {
 		retval = ext2fs_get_next_inode_full(scan, &ino, inode, length);
 		if (retval) {
@@ -658,9 +666,27 @@ static void rewrite_inodes(ext2_filsys fs)
 				exit(1);
 			}
 		}
+
+		file_acl_block = ext2fs_file_acl_block(fs, inode);
+		if (!file_acl_block)
+			continue;
+		retval = ext2fs_read_ext_attr3(fs, file_acl_block, ea_buf, ino);
+		if (retval) {
+			com_err("rewrite_eablock", retval,
+				"while rewriting extended attribute");
+			exit(1);
+		}
+		retval = ext2fs_write_ext_attr3(fs, file_acl_block, ea_buf,
+						ino);
+		if (retval) {
+			com_err("rewrite_eablock", retval,
+				"while rewriting extended attribute");
+			exit(1);
+		}
 	} while (ino);
 
 	ext2fs_free_mem(&inode);
+	ext2fs_free_mem(&ea_buf);
 	ext2fs_close_inode_scan(scan);
 }
 

