From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: skip orphan cleanup on rocompat fs
Date: Mon, 28 Feb 2011 00:54:07 -0500
Message-ID: <20110228055407.GS2924@thunk.org>
References: <AANLkTim6518pCpdndhkEmKuH09Q4K6qX4kF=MEMNCR4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49772 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab1B1QF2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 11:05:28 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTim6518pCpdndhkEmKuH09Q4K6qX4kF=MEMNCR4Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've applied the patch, with a few cosmetic changes and clarifications
in the commit description to make things easier to understand.

       	      		     	  	 - Ted

>From d39195c33bb1b5fdcb0f416e8a0b34bfdb07a027 Mon Sep 17 00:00:00 2001
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 28 Feb 2011 00:53:45 -0500
Subject: [PATCH] ext4: skip orphan cleanup if fs has unknown ROCOMPAT features

Orphan cleanup is currently executed even if the file system has some
number of unknown ROCOMPAT features, which deletes inodes and frees
blocks, which could be very bad for some RO_COMPAT features,
especially the SNAPSHOT feature.

This patch skips the orphan cleanup if it contains readonly compatible
features not known by this ext4 implementation, which would prevent
the fs from being mounted (or remounted) readwrite.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bd6e86a..9eaec22 100644
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
@@ -2117,6 +2118,13 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		return;
 	}
 
+	/* Check if feature set would not allow a r/w mount */
+	if (!ext4_feature_set_ok(sb, 0)) {
+		ext4_msg(sb, KERN_INFO, "Skipping orphan cleanup due to "
+			 "unknown ROCOMPAT features");
+		return;
+	}
+
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "
-- 
1.7.3.1

