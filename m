From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: Notify when discard is not supported
Date: Fri, 19 Oct 2012 14:12:37 +0200
Message-ID: <1350648758-3318-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab2JSMMo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Oct 2012 08:12:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Notify user when mounting the file system with -o discard option, but
the device does not support discard. Obviously we do not want to fail
the mount or disable the options, because the underlying device might
change in future even without file system remount.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7265a03..fd3ff41 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4017,6 +4017,14 @@ no_journal:
 	}
 #endif  /* CONFIG_QUOTA */
 
+	if (test_opt(sb, DISCARD)) {
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+		if (!blk_queue_discard(q))
+			ext4_msg(sb, KERN_WARNING,
+				 "mounting with \"discard\" option, but "
+				 "the device does not support discard");
+	}
+
 	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
 		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
 		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
-- 
1.7.7.6

