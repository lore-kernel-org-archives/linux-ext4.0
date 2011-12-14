From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 14/51] dumpe2fs: Display block bitmap checksum
Date: Tue, 13 Dec 2011 17:14:50 -0800
Message-ID: <20111214011450.20947.33903.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44492 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab1LNBO5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 20:14:57 -0500
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 20:14:56 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1Ergm310030
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:14:53 -0500
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1EpcD016798
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:14:53 -0700
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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

