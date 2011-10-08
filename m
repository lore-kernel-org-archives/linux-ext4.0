From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/47] mke2fs: Allow metadata checksums to be turned on at
	mkfs time
Date: Sat, 08 Oct 2011 00:34:06 -0700
Message-ID: <20111008073406.17888.55144.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48780 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1JHHg2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:36:28 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p986F541013123
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 02:15:05 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987Y9XQ477102
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:34:09 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987Y7iK005825
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:34:09 -0400
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Write out checksummed inodes even when writing out a zeroed table.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 244e0c8..6e9f399 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -304,6 +304,27 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
 	ext2fs_badblocks_list_iterate_end(bb_iter);
 }
 
+static void write_reserved_inodes(ext2_filsys fs)
+{
+	errcode_t	retval;
+	ext2_ino_t	ino;
+	struct ext2_inode *inode;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval) {
+		com_err("inode_init", retval,
+			"while allocating memory");
+		exit(1);
+	}
+	bzero(inode, EXT2_INODE_SIZE(fs->super));
+
+	for (ino = 1; ino < EXT2_FIRST_INO(fs->super); ino++)
+		ext2fs_write_inode_full(fs, ino, inode,
+					EXT2_INODE_SIZE(fs->super));
+
+	ext2fs_free_mem(&inode);
+}
+
 static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 {
 	errcode_t	retval;
@@ -349,6 +370,12 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
 	ext2fs_numeric_progress_close(fs, &progress,
 				      _("done                            \n"));
+
+	/* Reserved inodes must always have correct checksums */
+	if (fs->super->s_creator_os == EXT2_OS_LINUX &&
+	    fs->super->s_feature_ro_compat &
+	    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+		write_reserved_inodes(fs);
 }
 
 static void create_root_dir(ext2_filsys fs)
@@ -847,7 +874,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
 		EXT4_FEATURE_RO_COMPAT_BIGALLOC|
-		EXT4_FEATURE_RO_COMPAT_QUOTA
+		EXT4_FEATURE_RO_COMPAT_QUOTA|
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 
 

