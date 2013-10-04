From: jon ernst <jonernst07@gmail.com>
Subject: ext4_wait_block_bitmap() and ext4_read_block_bitmap_nowait() handle
 bitmap verification differently
Date: Thu, 3 Oct 2013 22:45:06 -0400
Message-ID: <CAGW2f1HsP1s+Avuiietg1BqqNeEJJ8g1MOgxHnx-8hqK57QG7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:40456 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3JDCpH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Oct 2013 22:45:07 -0400
Received: by mail-oa0-f50.google.com with SMTP id j1so3320155oag.9
        for <linux-ext4@vger.kernel.org>; Thu, 03 Oct 2013 19:45:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I found that ext4_wait_block_bitmap() and
ext4_read_block_bitmap_nowait() handle bitmap verification
differently.
wait_block_bitmap() calls ext4_validate_block_bitmap() all the time.
But  read_block_bitmap_nowait() checks EXT4_BG_BLOCK_UNINIT, if it
meets, it will skip ext4_validate_block_bitmap()

In my opinion, they'd better do same thing.
In that way, we can also return "fail" in ext4_valid_block_bitmap()
method when we meet FLEX_BG.



diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index dc5d572..366807a 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -319,7 +319,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap(struct
super_block *sb,
                 * or it has to also read the block group where the bitmaps
                 * are located to verify they are set.
                 */
-               return 0;
+               return 1;
        }
        group_first_block = ext4_group_first_block_no(sb, block_group);

@@ -472,8 +472,12 @@ int ext4_wait_block_bitmap(struct super_block
*sb, ext4_group_t block_group,
                return 1;
        }
        clear_buffer_new(bh);
-       /* Panic or remount fs read-only if block bitmap is invalid */
-       ext4_validate_block_bitmap(sb, desc, block_group, bh);
+
+       if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+        return 0;
+        }
+       /* Panic or remount fs read-only if block bitmap is invalid */
+       ext4_validate_block_bitmap(sb, desc, block_group, bh);
        /* ...but check for error just in case errors=continue. */
        return !buffer_verified(bh);
 }
