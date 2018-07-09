From: Junil Lee <junil0814.lee@lge.com>
Subject: [PATCH] ext4: remove abnormal set for I_DATA_SEM subclass
Date: Mon,  9 Jul 2018 16:58:28 +0900
Message-ID: <1531123108-45918-1-git-send-email-junil0814.lee@lge.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        junil0814.lee@vger.kernel.org, Junil Lee <junil0814.lee@lge.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The -EBUSY return value of dquot_enable() function means that just
want to update flags. If some users make a duplicate request to update
flags, lockdep could catch the false positive casued by needing to
allocate a quota block from inside ext4_map_blocks(), while holding
i_data_sem for a data inode. This results in this complaint:

       CPU0                    CPU1
       ----                    ----
  lock(&s->s_dquot.dqio_mutex);
                               lock(&ei->i_data_sem);
                               lock(&s->s_dquot.dqio_mutex);
  lock(&ei->i_data_sem);

Signed-off-by: Junil Lee <junil0814.lee@lge.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 13d2706..0757c9a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5637,7 +5637,7 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 	lockdep_set_quota_inode(qf_inode, I_DATA_SEM_QUOTA);
 	err = dquot_enable(qf_inode, type, format_id, flags);
 	iput(qf_inode);
-	if (err)
+	if (err && err != -EBUSY)
 		lockdep_set_quota_inode(qf_inode, I_DATA_SEM_NORMAL);
 
 	return err;
-- 
2.6.2
