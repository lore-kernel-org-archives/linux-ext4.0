Return-Path: <SRS0=VEyz=NL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:47186 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeKAELw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Nov 2018 00:11:52 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 2/7] ext4: possible sbi->s_group_desc leak in ext4_fill_super
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1541011937.git.vvs@virtuozzo.com>
Message-ID: <4b554ca1-f46e-742e-4aaa-04b379baf5f9@virtuozzo.com>
Date: Wed, 31 Oct 2018 22:12:27 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1541011937.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes bfe0a5f47ada ("ext4: add more mount time checks of the superblock") # 4.18

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a221f1cdf704..ed4d36506ec2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4100,7 +4100,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			 le32_to_cpu(es->s_inodes_count),
 			 ((u64)sbi->s_groups_count * sbi->s_inodes_per_group));
 		ret = -EINVAL;
-		goto failed_mount;
+		db_count = 0;
+		goto failed_mount2;
 	}
 
 	bgl_lock_init(sbi->s_blockgroup_lock);
-- 
2.17.1
