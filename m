Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46020 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725743AbeJaGyH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 Oct 2018 02:54:07 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 11/11] ext4: access to uninitialized bh fields in
 ext4_xattr_set_handle()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1540935522.git.vvs@virtuozzo.com>
Message-ID: <b8523c3a-0eb2-3aeb-fdf9-2e9d6d320d5c@virtuozzo.com>
Date: Wed, 31 Oct 2018 00:58:53 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1540935522.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On-stack initialization does not guarantee zeroying of unintialized
fields. So is.iloc.bh and bs.bh can be contain garbage of old stack
conent.

Errors in the beginning of ext4_xattr_set_handle() function
lead to jump to "cleanup:" label where brelse(is.iloc.bh)
and brelse(bs.bh) can access uninitialized bh fields of
on-stack located "is" and "bs" structures.

Issue was inherited from ext3 and was present in first ext4 commit.

Fixes ac27a0ec112a ("ext4: initial copy of files from ext3") # 2.6.19

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index dc1aeab06dba..aae12425597e 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2303,9 +2303,11 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	};
 	struct ext4_xattr_ibody_find is = {
 		.s = { .not_found = -ENODATA, },
+		.iloc = { .bh = NULL, },
 	};
 	struct ext4_xattr_block_find bs = {
 		.s = { .not_found = -ENODATA, },
+		.bh = NULL,
 	};
 	int no_expand;
 	int error;
-- 
2.17.1
