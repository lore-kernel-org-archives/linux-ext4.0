From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] ext3: destroy sbi mutexes in put_super
Date: Sat, 27 Dec 2014 16:01:22 +0100
Message-ID: <1419692482-17658-1-git-send-email-fabf@skynet.be>
Cc: Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

 fs/ext3/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 9b4e7d7..d4dbf3c 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -466,6 +466,8 @@ static void ext3_put_super (struct super_block * sb)
 	}
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
+	mutex_destroy(&sbi->s_orphan_lock);
+	mutex_destroy(&sbi->s_resize_lock);
 	kfree(sbi);
 }
 
-- 
2.1.0
