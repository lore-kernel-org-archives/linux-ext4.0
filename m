From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 17/50] tune2fs: Rewrite block bitmap checksums
Date: Mon, 28 Nov 2011 16:29:46 -0800
Message-ID: <20111129002946.17953.49441.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50216 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1K2Abs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:31:48 -0500
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:31:46 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0TnNe292842
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:29:49 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0Tlbe010789
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 22:29:49 -0200
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When toggling metadata_csum, mark the block bitmap dirty so that it gets
written with new checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index b53e5da..12a22ed 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -428,6 +428,7 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	rewrite_inodes(fs);
 	ext2fs_read_bitmaps(fs);
 	ext2fs_mark_ib_dirty(fs);
+	ext2fs_mark_bb_dirty(fs);
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 }

