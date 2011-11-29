From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 14/50] dumpe2fs: Display block bitmap checksum
Date: Mon, 28 Nov 2011 16:29:27 -0800
Message-ID: <20111129002927.17953.2256.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:53525 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1K2A3i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 19:29:38 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 17:29:37 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0TYS0114540
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:29:34 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0TSkN001180
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:29:33 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Display the block bitmap checksum when displaying block groups.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/dumpe2fs.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 98bee2b..33c0933 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -222,6 +222,11 @@ static void list_desc (ext2_filsys fs)
 		print_number(ext2fs_block_bitmap_loc(fs, i));
 		print_bg_rel_offset(fs, ext2fs_block_bitmap_loc(fs, i), 0,
 				    first_block, last_block);
+		if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT &&
+		    fs->super->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+			printf(_(", csum 0x%08x"),
+			       ext2fs_block_bitmap_checksum(fs, i));
 		fputs(_(", Inode bitmap at "), stdout);
 		print_number(ext2fs_inode_bitmap_loc(fs, i));
 		print_bg_rel_offset(fs, ext2fs_inode_bitmap_loc(fs, i), 0,

