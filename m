From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Fwd: [PATCH] mkfs: default ipg exceeds blocksize * 8 in 64K bigalloc
Date: Mon, 30 Dec 2013 16:02:01 +0800
Message-ID: <CAGBYx2aKccYzUov41aHuPXF3p_wKvRSOb=wHpDdH=sZd+MuQHw@mail.gmail.com>
References: <1388390067-1276-1-git-send-email-yangyongqiang01@baidu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34127 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3L3ICW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Dec 2013 03:02:22 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so4973824eei.0
        for <linux-ext4@vger.kernel.org>; Mon, 30 Dec 2013 00:02:21 -0800 (PST)
In-Reply-To: <1388390067-1276-1-git-send-email-yangyongqiang01@baidu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If bigalloc is used and the cluster size is set to 64KB, then
default inodes per group exceeds blocksize * 8, this patch simply
fixes it. I am not sure if the fix is reasonable.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 lib/ext2fs/initialize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 62a19b3..916c12c 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -308,6 +308,8 @@ retry:
                                                ext2fs_blocks_count(param));
                        super->s_clusters_per_group = super->s_blocks_per_group;
                        goto retry;
+               } else if (bigalloc_flag) {
+                       ipg = fs->blocksize * 8;
                } else {
                        retval = EXT2_ET_TOO_MANY_INODES;
                        goto cleanup;
--
1.8.5.2
