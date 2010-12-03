From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] ext3: Set barrier=0 when block device does not advertise
	flush support
Date: Thu, 2 Dec 2010 17:26:11 -0800
Message-ID: <20101203012611.GJ18195@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:49531 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255Ab0LCB0K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Dec 2010 20:26:10 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the user tries to enable write flushes with "barrier=1" and the underlying
block device does not support flushes, print a message and set barrier=0.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext3/super.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index d15209e..75ca265 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1691,6 +1691,13 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 			    NULL, 0))
 		goto failed_mount;
 
+	/* Catch barrier=1 and no flush support */
+	if (test_opt(sb, BARRIER) &&
+		     !(sb->s_bdev->bd_disk->queue->flush_flags & REQ_FLUSH)) {
+		ext3_msg(sb, KERN_WARNING, "flush not supported; disabling.");
+		clear_opt(sbi->s_mount_opt, BARRIER);
+	}
+
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
@@ -2574,6 +2581,13 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 		goto restore_opts;
 	}
 
+	/* Catch barrier=1 and no flush support */
+	if (test_opt(sb, BARRIER) &&
+		     !(sb->s_bdev->bd_disk->queue->flush_flags & REQ_FLUSH)) {
+		ext3_msg(sb, KERN_WARNING, "flush not supported; disabling.");
+		clear_opt(sbi->s_mount_opt, BARRIER);
+	}
+
 	if (test_opt(sb, ABORT))
 		ext3_abort(sb, __func__, "Abort forced by user");
 
