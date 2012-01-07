From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 17/51] e2fsck: Don't verify bitmap checksums
Date: Sat, 07 Jan 2012 00:34:45 -0800
Message-ID: <20120107083445.25788.72636.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41399 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759499Ab2AGIeu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:34:50 -0500
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:34:49 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078YmIS215354
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:34:48 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078Yk3r007203
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:34:47 -0500
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
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
index f00734e..037f270 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -246,7 +246,9 @@ void e2fsck_read_bitmaps(e2fsck_t ctx)
 	}
 
 	old_op = ehandler_operation(_("reading inode and block bitmaps"));
+	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	retval = ext2fs_read_bitmaps(fs);
+	ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	ehandler_operation(old_op);
 	if (retval) {
 		com_err(ctx->program_name, retval,

