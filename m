From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 07/10] fs: ext4: Replace CURRENT_TIME with ext4_current_time()
Date: Tue,  2 Feb 2016 22:07:47 -0800
Message-ID: <1454479670-8204-8-git-send-email-deepa.kernel@gmail.com>
References: <1454479670-8204-1-git-send-email-deepa.kernel@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454479670-8204-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

CURRENT_TIME macro is not appropriate for filesystems as it
doesn't use the right granularity for filesystem timestamps.
Use ext4_current_time() instead which is appropriate for ext4
timestamps.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ed01ec..5e6c866 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5139,7 +5139,7 @@ static int ext4_quota_off(struct super_block *sb, int type)
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA, 1);
 	if (IS_ERR(handle))
 		goto out;
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
 
-- 
1.9.1
