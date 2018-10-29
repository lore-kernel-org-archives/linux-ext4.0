Return-Path: <SRS0=ufRS=NJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46112 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbeJ3AhK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 Oct 2018 20:37:10 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 4/7] ext4 resize: brelse() cleanup in add_new_gdb_meta_bg()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org,
        Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Yongqiang Yang <yangyongqiang01@baidu.com>
Message-ID: <8807a471-2331-276d-1b72-dce55ea7a1cf@virtuozzo.com>
Date: Mon, 29 Oct 2018 18:25:22 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

gdb_bh must be released in case of errors before update of s_group_desc
but it must not be released after update of group descriptors
because in this case bh can be used later.

Fixes 01f795f9e0d6 ("ext4: add online resizing support for meta_bg ...")
#? cc: stable@vger.kernel.org # 3.7+

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 fs/ext4/resize.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ff17480e8613..ff8389ac4769 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -923,6 +923,7 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 				     sizeof(struct buffer_head *),
 				     GFP_NOFS);
 	if (!n_group_desc) {
+		brelse(gdb_bh);
 		err = -ENOMEM;
 		ext4_warning(sb, "not enough memory for %lu groups",
 			     gdb_num + 1);
@@ -938,8 +939,6 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 	kvfree(o_group_desc);
 	BUFFER_TRACE(gdb_bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, gdb_bh);
-	if (unlikely(err))
-		brelse(gdb_bh);
 	return err;
 }
 
-- 
2.17.1
