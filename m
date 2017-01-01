From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/2 linux-next] ext4: check inode permissions in ext4_ioctl()
Date: Sun,  1 Jan 2017 11:16:26 +0100
Message-ID: <1483265786-21195-1-git-send-email-fabf@skynet.be>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

According to other FS like UDF, ioctl has to check if inode
is readable before proceeding otherwise permissions updated between
file opening and ioctl are ignored.

Set operations were already protected but nothing around
get like EXT4_IOC_GETVERSION

This patch applies the same test than udf_ioctl() but returns
-EACCES "permission denied" like the rest of ext4_ioctl()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 49fd137..4f113e6 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -449,6 +449,9 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int flags;
 
+	if (inode_permission(inode, MAY_READ) != 0)
+		return -EACCES;
+
 	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
 
 	switch (cmd) {
-- 
2.7.4
