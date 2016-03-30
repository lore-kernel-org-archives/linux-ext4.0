From: "Navin P.S" <navinp1912@gmail.com>
Subject: [PATCH 1/1] Fix Ubsan error
Date: Wed, 30 Mar 2016 22:29:55 +0530
Message-ID: <CAA=40849KSFkpG3kkppAruwxfqtQwTw0KsV-LXR5wODdspxDWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33629 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbcC3RAf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Mar 2016 13:00:35 -0400
Received: by mail-vk0-f51.google.com with SMTP id k1so69378734vkb.0
        for <linux-ext4@vger.kernel.org>; Wed, 30 Mar 2016 10:00:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
  This fixes bugs 114701 and 112161 at bugzilla.kernel.org
  It is caused due to left shift by a negative value which is undefined.
  Since these values are not used after a negative shift the change
  introduces a break.

Signed-off-by: Navin P.S <navinp1912@gmail.com>
---
 fs/ext4/mballoc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 50e05df..8ccfcf7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1278,6 +1278,8 @@ static int mb_find_order_for_block(struct
ext4_buddy *e4b, int block)
  /* this block is part of buddy of order 'order' */
  return order;
  }
+ if (order > e4b->bd_blkbits)
+ break;
  bb += 1 << (e4b->bd_blkbits - order);
  order++;
  }
@@ -2616,6 +2618,8 @@ int ext4_mb_init(struct super_block *sb)
  do {
  sbi->s_mb_offsets[i] = offset;
  sbi->s_mb_maxs[i] = max;
+ if (i > sb->s_blocksize_bits)
+ break;
  offset += 1 << (sb->s_blocksize_bits - i);
  max = max >> 1;
  i++;
-- 
2.5.0
