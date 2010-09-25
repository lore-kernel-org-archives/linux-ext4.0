From: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 08/10] Fs: ext4: ioctl: fixed spacing issue
Date: Sat, 25 Sep 2010 14:31:59 -0400
Message-ID: <1285439521-2557-8-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
	Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tracey Dent <Tdent48227@gmail.com>

Fixed spaceing issues using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bf5ae88..4e3ed22 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -200,7 +200,7 @@ setversion_out:
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -269,7 +269,7 @@ mext_out:
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
-- 
1.7.3
