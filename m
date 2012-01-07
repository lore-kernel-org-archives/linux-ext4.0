From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 41/51] tune2fs: Force MMP update when changing metadata_csum
	flag
Date: Sat, 07 Jan 2012 00:37:18 -0800
Message-ID: <20120107083718.25788.37628.stgit@elm3c44.beaverton.ibm.com>
References: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59872 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab2AGIhZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:37:25 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:37:24 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078bLkB3408126
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:37:21 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078bKBA014052
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:37:21 -0500
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When changing the metadata_csum flag, always force out a new MMP block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 2d0ea50..cba4d4c 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -706,6 +706,7 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	ext2fs_read_bitmaps(fs);
 	ext2fs_mark_ib_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
+	ext2fs_mmp_update2(fs, 1);
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,

