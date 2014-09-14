From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 35/34] e2fsck: free bh when descriptor block checksum fails
Date: Sun, 14 Sep 2014 10:19:35 -0700
Message-ID: <20140914171935.GE10150@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38771 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaINRTn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Sep 2014 13:19:43 -0400
Content-Disposition: inline
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Free the buffer head if the journal descriptor block fails checksum
verification.  This has been patched before (see "e2fsck: free bh on
csum verify error in do_one_pass") but apparently the patch was never
committed to jbd2 in the kernel, so when we resync'd the recovery code
with 3.16, the bug came back.  Sigh.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/recovery.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 3dc7c06..b5ce3b3 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -525,6 +525,7 @@ static int do_one_pass(journal_t *journal,
 			    !jbd2_descr_block_csum_verify(journal,
 							  bh->b_data)) {
 				err = -EIO;
+				brelse(bh);
 				goto failed;
 			}
 
