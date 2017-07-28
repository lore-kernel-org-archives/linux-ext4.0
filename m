From: Jerry Lee <jerrylee@qnap.com>
Subject: [PATCH] ext4: fix incorrect n_blocks_count result when resizing file
 system to size larger than 2^32 blocks
Date: Fri, 28 Jul 2017 14:23:55 +0800
Message-ID: <CAA1ppbjN3LdNdixNWb_OdA36UtZy1VDZHKySLpyt_O2rj-a35w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34632 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdG1GX5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jul 2017 02:23:57 -0400
Received: by mail-oi0-f45.google.com with SMTP id x3so121402758oia.1
        for <linux-ext4@vger.kernel.org>; Thu, 27 Jul 2017 23:23:56 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 32-bit platform, the value of n_blcoks_count may be wrong during the
file system is resized to size larger than 2^32 blocks.  This may caused
the superblock being corrupted with zero blocks count.

Signed-off-by: Jerry Lee <jerrylee@qnap.com>
---
 fs/ext4/resize.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c3ed902..035cd3f 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1927,7 +1927,8 @@ int ext4_resize_fs(struct super_block *sb,
ext4_fsblk_t n_blocks_count)
                        n_desc_blocks = o_desc_blocks +
                                le16_to_cpu(es->s_reserved_gdt_blocks);
                        n_group = n_desc_blocks * EXT4_DESC_PER_BLOCK(sb);
-                       n_blocks_count = n_group * EXT4_BLOCKS_PER_GROUP(sb);
+                       n_blocks_count = (ext4_fsblk_t)n_group *
+                               EXT4_BLOCKS_PER_GROUP(sb);
                        n_group--; /* set to last group number */
                }
