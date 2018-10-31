Return-Path: <SRS0=VEyz=NL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:47220 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeKAEM1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Nov 2018 00:12:27 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 6/7] ext4: lost brelse in ext4_xattr_move_to_block()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Kalpak Shah <kalpak@clusterfs.com>
References: <cover.1541011937.git.vvs@virtuozzo.com>
Message-ID: <76da5ae3-274d-efa4-58bb-6cd280763a37@virtuozzo.com>
Date: Wed, 31 Oct 2018 22:13:00 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1541011937.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes 3f2571c1f91f ("ext4: factor out xattr moving")
cc: Jan Kara <jack@suse.cz>
however issue was present in original ext4_expand_extra_isize_ea()
Fixes 6dd4ee7cab7e ("ext4: Expand extra_inodes space per ...") # 2.6.23
cc: Kalpak Shah <kalpak@clusterfs.com>

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 07b9a335c8eb..5c9bc0d85cc0 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2617,6 +2617,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 	kfree(buffer);
 	if (is)
 		brelse(is->iloc.bh);
+	if (bs)
+		brelse(bs->bh);
 	kfree(is);
 	kfree(bs);
 
-- 
2.17.1
