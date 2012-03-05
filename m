From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/4] e2fsck: Do not discard itable if discard doen't zero data
Date: Mon,  5 Mar 2012 08:49:36 +0100
Message-ID: <1330933776-2696-4-git-send-email-lczerner@redhat.com>
References: <1330933776-2696-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab2CEHtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 02:49:46 -0500
In-Reply-To: <1330933776-2696-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We do not want to discard inode table if the underlying device does not
return zeros when reading non-provisioned blocks. The reason is that if
the inode table is not zeroed yet, then discard would not help us since
we would have to zero it anyway. In the case that inode table was
already zeroed, then the discard would cause subsequent reads to contain
non-deterministic data so we would not be able to assume that the inode
table was zeroed and we would need to zero it again, which does not
really make sense.

This commit adds check to prevent inode table from being discarded if
the discard does not zero data.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/pass5.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 741e6dd..9e63037 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -116,7 +116,18 @@ static void e2fsck_discard_inodes(e2fsck_t ctx, int group,
 		ctx->options &= ~E2F_OPT_DISCARD;
 	}
 
-	if (!(ctx->options & E2F_OPT_DISCARD))
+	/*
+	 * Do not attempt to discard if E2F_OPT_DISCARD is not set. And also
+	 * skip the discard on this group if discard does not zero data.
+	 * The reason is that if the inode table is not zeroed discard would
+	 * no help us since we need to zero it anyway, or if the inode table
+	 * is zeroed then the read after discard would not be deterministic
+	 * anyway and we would not be able to assume that this inode table
+	 * was zeroed anymore so we would have to zero it again, which does
+	 * not really make sense.
+	 */
+	if (!(ctx->options & E2F_OPT_DISCARD) ||
+	    !io_channel_discard_zeroes_data(fs->io))
 		return;
 
 	/*
-- 
1.7.4.4

