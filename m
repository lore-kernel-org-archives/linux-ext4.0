From: "gnehzuil.liu@gmail.com" <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: remove duplicated declarations in inode.c
Date: Wed,  6 Jun 2012 21:03:22 +0800
Message-ID: <1338987802-10186-1-git-send-email-gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57372 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2FFMz4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jun 2012 08:55:56 -0400
Received: by pbbrp8 with SMTP id rp8so8909105pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 06 Jun 2012 05:55:56 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

in patch cb20d5188366f04d96d2e07b1240cc92170ade40, ext4_set_bh_endio and
ext4_end_io_buffer_write are declared at the beginning of inode.c file.  So we
can remove duplicated declarations in this file.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 02bc8cb..dd0fa3c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1925,9 +1925,6 @@ out:
 	return ret;
 }
 
-static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode);
-static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
