From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ext4: skip orphan cleanup on rocompat fs
Date: Sat, 26 Feb 2011 22:35:18 +0200
Message-ID: <AANLkTim6518pCpdndhkEmKuH09Q4K6qX4kF=MEMNCR4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59612 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab1BZUfT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Feb 2011 15:35:19 -0500
Received: by qwd7 with SMTP id 7so2005576qwd.19
        for <linux-ext4@vger.kernel.org>; Sat, 26 Feb 2011 12:35:18 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Orphan cleanup is currently executed even on readonly mount.
It deletes inodes and frees blocks, which could be very bad for some
RO_COMPAT features, SNAPSHOT and BIGALLOC to name two.

Now the damage is done, because current stock kernels may
corrupt future fs with readonly compatible features,
when doing orphan cleanup.

This patch skips the orphan cleanup if readonly compatible features
would prevent the fs from being mounted (or remounted) readwrite.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/super.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f6a318f..02e3b02 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -75,6 +75,7 @@ static void ext4_write_super(struct super_block *sb);
 static int ext4_freeze(struct super_block *sb);
 static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
                       const char *dev_name, void *data);
+static int ext4_feature_set_ok(struct super_block *sb, int readonly);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
@@ -2120,6 +2121,13 @@ static void ext4_orphan_cleanup(struct super_block *sb,
                return;
        }

+       /* Check if feature set allows readwrite operations */
+       if (!ext4_feature_set_ok(sb, 0)) {
+               ext4_msg(sb, KERN_INFO, "Skipping orphan cleanup on readonly-"
+                              "compatible fs");
+               return;
+       }
+
        if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
                if (es->s_last_orphan)
                        jbd_debug(1, "Errors on filesystem, "
--
1.7.0.4
