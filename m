From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] e2fsck: When restarting fsck on account of MMP, zero
	ctx->fs after fs is freed
Date: Fri, 30 Sep 2011 12:40:05 -0700
Message-ID: <20110930194005.GT12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:44795 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1I3Tj6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Sep 2011 15:39:58 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8UJdwCO006766
	for <linux-ext4@vger.kernel.org>; Fri, 30 Sep 2011 13:39:58 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8UJdu7b197664
	for <linux-ext4@vger.kernel.org>; Fri, 30 Sep 2011 13:39:56 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8UJdued018160
	for <linux-ext4@vger.kernel.org>; Fri, 30 Sep 2011 13:39:56 -0600
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If MMP is enabled and e2fsck determines that it needs to restart itself on
account of various MMP conditions, it will close the current fs and jump back
to the start of fs checking.  However, closing fs also frees it, which means
that we need to set ctx->fs to NULL to prevent subsequent open code from
accessing the old deleted pointer.

(This fix came up while testing the metadata checksumming patchset)

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 e2fsck/unix.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index f980962..37cfb00 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1351,6 +1351,7 @@ failure:
 	  * Restart in order to reopen fs but this time start mmp.
 	  */
 	if (flags & EXT2_FLAG_SKIP_MMP) {
+		ctx->fs = NULL;
 		ext2fs_close(fs);
 		flags &= ~EXT2_FLAG_SKIP_MMP;
 		goto restart;
