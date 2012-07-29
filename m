From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Revert "e2fsck: Skip journal checks if the fs is mounted and doesn't need recovery"
Date: Sun, 29 Jul 2012 00:13:29 -0400
Message-ID: <1343535209-18588-1-git-send-email-tytso@mit.edu>
References: <20120729035118.GA17210@thunk.org>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41887 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab2G2ENg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Jul 2012 00:13:36 -0400
In-Reply-To: <20120729035118.GA17210@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This reverts commit 47c1b8e16668daa6e74cee3c7b8bdf237ffefe70.

The original reason for this commit was to speed up boots for hard
drives.  However, I've measured the time difference on a 1TB laptop
drive, and it's not significant: 70ms vs 10ms when running e2fsck on a
clean file system.

The problem with this optimization is that we don't notice if the
journal superblock has a non-zero s_errno field.  If we don't transfer
the error indicator from the journal superblock to the file system
superblock, then the kernel will transfer it when the file system is
remounted read-write, causing scary messages to appear in the syslog.
(And since there was a bug in the kernel code which didn't clear the
error indicator in the journal superblock, it would never get
cleared.)

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/unix.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 94260bd..f71a125 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1424,10 +1424,6 @@ failure:
 		fprintf(ctx->logf, "Filesystem UUID: %s\n",
 			e2p_uuid2str(sb->s_uuid));
 
-	if ((ctx->mount_flags & EXT2_MF_MOUNTED) &&
-	    !(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER))
-		goto skip_journal;
