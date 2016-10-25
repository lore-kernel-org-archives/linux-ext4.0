From: Jan Kara <jack@suse.cz>
Subject: [PATCH] mke2fs: Avoid crashes / infinite loops for absurdly large devices
Date: Tue, 25 Oct 2016 14:11:44 +0200
Message-ID: <1477397504-5663-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758821AbcJYMLs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Oct 2016 08:11:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a device reports absurdly high size, some arithmetics in mke2fs can
overflow (e.g. number of block descriptors) and we end in an infinite
loop. Fix that by checking and refusing insanely large devices.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 misc/mke2fs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index d98e71e0d706..6a83bd9fe2af 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2089,6 +2089,18 @@ profile_error:
 			EXT2_BLOCK_SIZE(&fs_param));
 		exit(1);
 	}
+	/*
+	 * Guard against group descriptor count overflowing... Mostly to avoid
+	 * strange results for absurdly large devices.
+	 */
+	if (fs_blocks_count > ((1ULL << (fs_param.s_log_block_size + 3 + 32)) - 1)) {
+		fprintf(stderr, _("%s: Size of device (0x%llx blocks) %s "
+				  "too big to create\n\t"
+				  "a filesystem using a blocksize of %d.\n"),
+			program_name, fs_blocks_count, device_name,
+			EXT2_BLOCK_SIZE(&fs_param));
+		exit(1);
+	}
 
 	ext2fs_blocks_count_set(&fs_param, fs_blocks_count);
 
-- 
2.6.6

