From: Steven Liu <lingjiujianke@gmail.com>
Subject: [PATCH] ext4: fix the code style from printk to ext_debug in extents.c
Date: Sat, 12 May 2012 23:57:13 +0800
Message-ID: <CADxeRwnv7quZbWn9xZ=KnEg_KyT65DApEt57zDdgeYsRgQKYQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62477 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2ELP5O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 May 2012 11:57:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

just fix the printk debug to ext_debug, if undefined the EXT_DEBUG
it will not output the debug message

Signed-off-by: LiuQi <liuqi@zecloud.cn>
---
 fs/ext4/extents.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index abcdeab..211e230 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -548,10 +548,10 @@ ext4_ext_binsearch_idx(struct inode *inode,
        for (k = 0; k < le16_to_cpu(eh->eh_entries); k++, ix++) {
          if (k != 0 &&
              le32_to_cpu(ix->ei_block) <= le32_to_cpu(ix[-1].ei_block)) {
-               printk(KERN_DEBUG "k=%d, ix=0x%p, "
+               ext_debug("k=%d, ix=0x%p, "
                       "first=0x%p\n", k,
                       ix, EXT_FIRST_INDEX(eh));
-               printk(KERN_DEBUG "%u <= %u\n",
+               ext_debug("%u <= %u\n",
                       le32_to_cpu(ix->ei_block),
                       le32_to_cpu(ix[-1].ei_block));
            }
--
1.7.1



Best Regards
