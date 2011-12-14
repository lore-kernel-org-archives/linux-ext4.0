From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/51] mke2fs: Allow metadata checksums to be turned on at
	mkfs time
Date: Tue, 13 Dec 2011 17:14:10 -0800
Message-ID: <20111214011410.20947.96920.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e34.co.us.ibm.com ([32.97.110.152]:33025 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab1LNBOQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2011 20:14:16 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 18:14:15 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1EDGC114298
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:14:13 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1EAPX004933
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:14:12 -0700
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Write out checksummed inodes even when writing out a zeroed table.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0ef2531..98af8b0 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -305,6 +305,27 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
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
@@ -350,6 +371,12 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
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
@@ -869,7 +896,7 @@ static __u32 ok_features[3] = {
 #ifdef CONFIG_QUOTA
 		EXT4_FEATURE_RO_COMPAT_QUOTA|
 #endif
-		0
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 
 

