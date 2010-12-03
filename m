From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] ext4: Set barrier=0 when block device does not advertise
	flush support
Date: Thu, 2 Dec 2010 16:16:59 -0800
Message-ID: <20101203001659.GI18195@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:42418 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab0LCAQ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Dec 2010 19:16:58 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the user tries to enable write flushes with "barrier=1" and the underlying
block device does not support flushes, print a message and set barrier=0.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/super.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e32195d..098dcf0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3124,6 +3124,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			   &journal_ioprio, NULL, 0))
 		goto failed_mount;
 
+	/* Catch barrier=1 and no flush support */
+	if (test_opt(sb, BARRIER) &&
+		     !(sb->s_bdev->bd_disk->queue->flush_flags & REQ_FLUSH)) {
+		ext4_msg(sb, KERN_WARNING, "flush not supported; disabling.");
+		clear_opt(sbi->s_mount_opt, BARRIER);
+	}
+
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
@@ -4198,6 +4205,13 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	/* Catch barrier=1 and no flush support */
+	if (test_opt(sb, BARRIER) &&
+		     !(sb->s_bdev->bd_disk->queue->flush_flags & REQ_FLUSH)) {
+		ext4_msg(sb, KERN_WARNING, "flush not supported; disabling.");
+		clear_opt(sbi->s_mount_opt, BARRIER);
+	}
+
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
 		ext4_abort(sb, "Abort forced by user");
 
