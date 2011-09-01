From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 18/37] e2fsck: Don't verify bitmap checksums
Date: Wed, 31 Aug 2011 17:37:06 -0700
Message-ID: <20110901003706.1176.64563.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59148 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab1IAAhQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:37:16 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810737P000623
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:07:03 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810b9nh111038
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:37:13 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810b8cJ026540
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:37:09 -0400
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since the correct inode and block bitmaps are calculated in pass 5, don't fail
the bitmap read operation in prior passes since (a) incorrect results won't
kill us and (b) if we fail early, we'll never _get_ to pass 5.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/util.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/e2fsck/util.c b/e2fsck/util.c
index 22e06c2..61fa3db 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -224,7 +224,9 @@ void e2fsck_read_bitmaps(e2fsck_t ctx)
 	}
 
 	old_op = ehandler_operation(_("reading inode and block bitmaps"));
+	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	retval = ext2fs_read_bitmaps(fs);
+	ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	ehandler_operation(old_op);
 	if (retval) {
 		com_err(ctx->program_name, retval,

