From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 32/51] e2fsck: Handle superblock checksum errors gracefully
Date: Sat, 07 Jan 2012 00:36:21 -0800
Message-ID: <20120107083621.25788.65784.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58818 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab2AGIgq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:36:46 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:36:45 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078aN1g281560
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:36:23 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078aMnP012356
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 06:36:23 -0200
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e2fsck finds a superblock with an invalid checksum, try the backups.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/unix.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index d2a8c80..0881002 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1186,6 +1186,7 @@ restart:
 	if (!ctx->superblock && !(ctx->options & E2F_OPT_PREEN) &&
 	    !(ctx->flags & E2F_FLAG_SB_SPECIFIED) &&
 	    ((retval == EXT2_ET_BAD_MAGIC) ||
+	     (retval == EXT2_ET_SB_CSUM_INVALID) ||
 	     (retval == EXT2_ET_CORRUPT_SUPERBLOCK) ||
 	     ((retval == 0) && (retval2 = ext2fs_check_desc(fs))))) {
 		if (retval2 == ENOMEM) {

