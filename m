From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 10/50] tune2fs: Rewrite inode bitmap checksums
Date: Mon, 28 Nov 2011 16:29:01 -0800
Message-ID: <20111129002901.17953.53766.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38864 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1K2A3T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:29:19 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:29:18 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0T4BQ312326
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:29:04 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0T37P019210
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:29:04 -0500
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When toggling metadata_csum, mark the inode bitmap dirty so that they are
written out with new checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 260b040..b53e5da 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -426,6 +426,9 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 {
 	fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	rewrite_inodes(fs);
+	ext2fs_read_bitmaps(fs);
+	ext2fs_mark_ib_dirty(fs);
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 }
 

