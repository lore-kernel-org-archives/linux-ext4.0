From: yangsheng <sickamd@gmail.com>
Subject: [PATCH] Update atime from future.
Date: Tue,  4 Jan 2011 17:08:12 +0800
Message-ID: <1294132092-4423-1-git-send-email-sickamd@gmail.com>
Cc: adilger@dilger.ca, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, swhiteho@redhat.com,
	yangsheng <sickamd@gmail.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If atime has been wrong set to future, then it cannot
be updated back to current time.

Signed-off-by: sickamd@gmail.com
Reviewed-by: adilger@dilger.ca
---
 fs/inode.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index da85e56..d92779f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1446,6 +1446,8 @@ sector_t bmap(struct inode *inode, sector_t block)
 }
 EXPORT_SYMBOL(bmap);
 
+#define RELATIME_MARGIN (24 * 60 * 60)
+
 /*
  * With relative atime, only update atime if the previous atime is
  * earlier than either the ctime or mtime or if at least a day has
@@ -1469,10 +1471,16 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 		return 1;
 
 	/*
+	 * Is the previous atime value in future? If yes,
+	 * update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) < -RELATIME_MARGIN)
+		return 1;
+	/*
 	 * Is the previous atime value older than a day? If yes,
 	 * update atime:
 	 */
-	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= RELATIME_MARGIN)
 		return 1;
 	/*
 	 * Good, we can skip the atime update:
-- 
1.7.2.3

