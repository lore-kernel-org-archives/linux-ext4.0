From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 41/47] tune2fs: Force MMP update when changing metadata_csum
	flag
Date: Sat, 08 Oct 2011 00:37:38 -0700
Message-ID: <20111008073738.17888.8507.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34511 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab1JHHk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:40:29 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:40:28 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987bfjQ228994
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:37:41 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987besC020512
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:37:41 -0400
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When changing the metadata_csum flag, always force out a new MMP block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 4f02905..ad7ed95 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -705,6 +705,7 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	ext2fs_read_bitmaps(fs);
 	ext2fs_mark_ib_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
+	ext2fs_mmp_update2(fs, 1);
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,

