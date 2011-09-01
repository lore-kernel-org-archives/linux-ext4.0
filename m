From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 13/37] dumpe2fs: Display inode bitmap checksum
Date: Wed, 31 Aug 2011 17:36:34 -0700
Message-ID: <20110901003634.1176.10897.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e34.co.us.ibm.com ([32.97.110.152]:48675 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab1IAAgm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:36:42 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810abon021096
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:36:37 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810ac0e097250
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:36:38 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VIa8iT005820
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:36:10 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Display the inode bitmap checksum for each block group.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/dumpe2fs.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 7d74e84..ed207cb 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -220,6 +220,11 @@ static void list_desc (ext2_filsys fs)
 		print_number(ext2fs_inode_bitmap_loc(fs, i));
 		print_bg_rel_offset(fs, ext2fs_inode_bitmap_loc(fs, i), 0,
 				    first_block, last_block);
+		if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT &&
+		    fs->super->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+			printf(_(", checksum 0x%08x"),
+			       ext2fs_inode_bitmap_checksum(fs, i));
 		fputs(_("\n  Inode table at "), stdout);
 		print_range(ext2fs_inode_table_loc(fs, i),
 			    ext2fs_inode_table_loc(fs, i) +

