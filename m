From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Sat, 26 Feb 2011 22:40:19 +0200
Message-ID: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40728 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1BZUkU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Feb 2011 15:40:20 -0500
Received: by qwd7 with SMTP id 7so2007203qwd.19
        for <linux-ext4@vger.kernel.org>; Sat, 26 Feb 2011 12:40:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Orphan cleanup is currently executed even on readonly mount.
It deletes inodes and frees blocks, which could be very bad for some
RO_COMPAT features, HAS_SNAPSHOT to name one.

Now the damage is done, because current stock kernels may
corrupt future fs with readonly compatible features,
when doing orphan cleanup.

This patch skips the orphan cleanup if readonly compatible features
would prevent the fs from being mounted (or remounted) readwrite.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext3/super.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 85c8cc8..6cdd575 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1464,6 +1464,13 @@ static void ext3_orphan_cleanup (struct super_block * sb,
                return;
        }

+       /* Check if feature set allows readwrite operations */
+       if (EXT3_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP)) {
+               ext3_msg(sb, KERN_INFO, "Skipping orphan cleanup on readonly-"
+                              "compatible fs");
+               return;
+       }
+
        if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
                if (es->s_last_orphan)
                        jbd_debug(1, "Errors on filesystem, "
--
1.7.0.4
