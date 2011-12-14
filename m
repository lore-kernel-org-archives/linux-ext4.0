From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 11/51] dumpe2fs: Display inode bitmap checksum
Date: Tue, 13 Dec 2011 17:14:29 -0800
Message-ID: <20111214011429.20947.35132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37288 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279Ab1LNBOn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 20:14:43 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 20:14:42 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1EWJu356086
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:14:37 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1EViD003638
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 23:14:32 -0200
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Display the inode bitmap checksum for each block group.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/dumpe2fs.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 5b114e9..98bee2b 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -226,6 +226,11 @@ static void list_desc (ext2_filsys fs)
 		print_number(ext2fs_inode_bitmap_loc(fs, i));
 		print_bg_rel_offset(fs, ext2fs_inode_bitmap_loc(fs, i), 0,
 				    first_block, last_block);
+		if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT &&
+		    fs->super->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+			printf(_(", csum 0x%08x"),
+			       ext2fs_inode_bitmap_checksum(fs, i));
 		fputs(_("\n  Inode table at "), stdout);
 		print_range(ext2fs_inode_table_loc(fs, i),
 			    ext2fs_inode_table_loc(fs, i) +

