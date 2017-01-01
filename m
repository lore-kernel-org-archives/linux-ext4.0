From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 2/2 linux-next] ext4: return -EACCES on inode_owner_or_capable() error
Date: Sun,  1 Jan 2017 12:04:43 +0100
Message-ID: <1483268683-32295-1-git-send-email-fabf@skynet.be>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

like other cases in ext4_ioctl()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f665c02..3926657 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -504,7 +504,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		int err;
 
 		if (!inode_owner_or_capable(inode))
-			return -EPERM;
+			return -EACCES;
 
 		if (ext4_has_metadata_csum(inode->i_sb)) {
 			ext4_warning(sb, "Setting inode version is not "
-- 
2.7.4
