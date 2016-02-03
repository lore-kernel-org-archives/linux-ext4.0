From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 06/10] fs: ext4: Replace CURRENT_TIME_SEC with current_fs_time_sec()
Date: Tue,  2 Feb 2016 22:07:46 -0800
Message-ID: <1454479670-8204-7-git-send-email-deepa.kernel@gmail.com>
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

The macro CURRENT_TIME_SEC does not represent filesystem times
correctly as it cannot perform range checks.
current_fs_time_sec() will be extended to include this.

CURRENT_TIME_SEC is also not y2038 safe. current_fs_time_sec()
will be transitioned to use 64 bit time along with vfs in a
separate series.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0662b28..8dd04f8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1489,7 +1489,7 @@ static inline struct ext4_inode_info *EXT4_I(struct inode *inode)
 static inline struct timespec ext4_current_time(struct inode *inode)
 {
 	return (inode->i_sb->s_time_gran < NSEC_PER_SEC) ?
-		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
+		current_fs_time(inode->i_sb) : current_fs_time_sec(inode->i_sb);
 }
 
 static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
-- 
1.9.1
