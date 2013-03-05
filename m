From: Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Tue,  5 Mar 2013 13:25:18 -0700
Message-ID: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org>
Cc: Chris Ball <cjb@laptop.org>, linux-ext4@vger.kernel.org,
	Stephen Warren <swarren@nvidia.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:51551 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3CEUZ2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Mar 2013 15:25:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Stephen Warren <swarren@nvidia.com>

mke2fs on a large slow eMMC device may appear to hang while executing
ioctl(BLKDISCARD). CTRL-C and CTRL-\ don't appear to respond, or respond
extremely slowly. -v doesn't give any hints what's happening. Only strace
is a clue. Make -v print some clues to make it easier to track down the
apparent hang.

This change re-uses the original messages that were implemented as part
of 5827d24 "mke2fs support for BLKDISCARD" in order to easily re-use the
translations of that message. Note that this patch prints the first
message before executing the IOCTL, so the user is told what's going on
before the long wait.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Note: I've left mke2fs running for a while now (tens of minutes on a 16GiB
eMMC), and this IOCTL still hasn't completed. I'm not sure how long it's
meant to take. Perhaps the long execution time is actually a kernel bug in
the MMC core or our SDHCI driver.
---
 misc/mke2fs.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index bbf477a..defb932 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2272,7 +2272,20 @@ static int mke2fs_discard_device(ext2_filsys fs)
 	 * we do not print numeric progress resulting in failure
 	 * afterwards.
 	 */
+	if (verbose) {
+		printf(_("Calling BLKDISCARD from %llu to %llu "),
+			(unsigned long long)0,
+			(unsigned long long)fs->blocksize);
+		fflush(stdout);
+	}
 	retval = io_channel_discard(fs->io, 0, fs->blocksize);
+	if (verbose) {
+		if (retval)
+			printf(_("failed.\n"));
+		else
+			printf(_("succeeded.\n"));
+	}
+
 	if (retval)
 		return retval;
 	cur = fs->blocksize;
-- 
1.7.10.4

