From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 34/47] tune2fs: Store checksum algorithm type in superblock
Date: Sat, 08 Oct 2011 00:36:53 -0700
Message-ID: <20111008073653.17888.13156.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e39.co.us.ibm.com ([32.97.110.160]:40040 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1JHHjm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:39:42 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987Nise006840
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:23:44 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987au3P170862
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:36:56 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987asFh031585
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:36:56 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Actually records the checksum algorithm type in the superblock when enabling
checksumming.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index b2c9e32..708bc20 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -700,6 +700,12 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	ext2fs_mark_bb_dirty(fs);
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		fs->super->s_checksum_type = EXT2_CRC32C_CHKSUM;
+	else
+		fs->super->s_checksum_type = 0;
+	ext2fs_mark_super_dirty(fs);
 }
 
 /*

