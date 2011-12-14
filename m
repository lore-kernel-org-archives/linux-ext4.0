From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 34/51] tune2fs: Store checksum algorithm type in superblock
Date: Tue, 13 Dec 2011 17:17:04 -0800
Message-ID: <20111214011704.20947.39579.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50550 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab1LNBRK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Dec 2011 20:17:10 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 20:17:10 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1H7MR300114
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 20:17:07 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1H5fB017195
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 23:17:07 -0200
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Actually records the checksum algorithm type in the superblock when enabling
checksumming.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 4b91192..7299ad6 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -699,6 +699,12 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
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

