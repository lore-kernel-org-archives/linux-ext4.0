From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 32/54] e2fsck: Handle superblock checksum errors gracefully
Date: Tue, 06 Mar 2012 16:00:57 -0800
Message-ID: <20120307000057.11945.48853.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e34.co.us.ibm.com ([32.97.110.152]:57524 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031282Ab2CGABe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:01:34 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 17:01:32 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id E4C40C90050
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 19:01:04 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q27015Q2327770
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:01:05 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q27011Tq024369
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 21:01:04 -0300
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e2fsck finds a superblock with an invalid checksum, try the backups.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/unix.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 6f97b0f..a8e3775 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1198,6 +1198,7 @@ restart:
 	if (!ctx->superblock && !(ctx->options & E2F_OPT_PREEN) &&
 	    !(ctx->flags & E2F_FLAG_SB_SPECIFIED) &&
 	    ((retval == EXT2_ET_BAD_MAGIC) ||
+	     (retval == EXT2_ET_SB_CSUM_INVALID) ||
 	     (retval == EXT2_ET_CORRUPT_SUPERBLOCK) ||
 	     ((retval == 0) && (retval2 = ext2fs_check_desc(fs))))) {
 		if (retval2 == ENOMEM) {

