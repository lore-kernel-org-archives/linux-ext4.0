Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:35171 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbeKZOOZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 09:14:25 -0500
From: Pan Bian <bianpan2016@163.com>
To: "Theodore Ts\'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] ext4: fix possible use after free in ext4_quota_enable
Date: Mon, 26 Nov 2018 11:21:06 +0800
Message-Id: <1543202466-68277-1-git-send-email-bianpan2016@163.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function frees qf_inode via iput but then pass qf_inode to
lockdep_set_quota_inode on the failure path. This may result in a
use-after-free bug. The patch frees df_inode only when it is never used.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Fixes: daf647d2dd5("ext4: add lockdep annotations for i_data_sem")
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 53ff6c2..35689eb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5690,9 +5690,9 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 	qf_inode->i_flags |= S_NOQUOTA;
 	lockdep_set_quota_inode(qf_inode, I_DATA_SEM_QUOTA);
 	err = dquot_enable(qf_inode, type, format_id, flags);
-	iput(qf_inode);
 	if (err)
 		lockdep_set_quota_inode(qf_inode, I_DATA_SEM_NORMAL);
+	iput(qf_inode);
 
 	return err;
 }
-- 
2.7.4
