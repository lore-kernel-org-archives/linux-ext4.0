From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 31/47] e2fsck: Handle superblock checksum errors gracefully
Date: Sat, 08 Oct 2011 00:36:32 -0700
Message-ID: <20111008073632.17888.82871.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56312 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1JHHi4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:38:56 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987LLvC004047
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:21:21 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987aaO4227570
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:36:36 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987aZ2s025113
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 04:36:36 -0300
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e2fsck finds a superblock with an invalid checksum, try the backups.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/unix.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 2f4c232..1d81762 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1184,6 +1184,7 @@ restart:
 	if (!ctx->superblock && !(ctx->options & E2F_OPT_PREEN) &&
 	    !(ctx->flags & E2F_FLAG_SB_SPECIFIED) &&
 	    ((retval == EXT2_ET_BAD_MAGIC) ||
+	     (retval == EXT2_ET_SB_CSUM_INVALID) ||
 	     (retval == EXT2_ET_CORRUPT_SUPERBLOCK) ||
 	     ((retval == 0) && (retval2 = ext2fs_check_desc(fs))))) {
 		if (retval2 == ENOMEM) {

