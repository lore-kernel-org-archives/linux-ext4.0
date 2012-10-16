From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 08/10] ext4: ioctl: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:43:03 +0530
Message-ID: <1350414785-7848-8-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed checkpatch.pl reported issue

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/ioctl.c b/linux-3.7-rc1/fs/ext4/ioctl.c
index 5747f52..a534615 100644
--- a/linux-3.7-rc1/fs/ext4/ioctl.c
+++ b/linux-3.7-rc1/fs/ext4/ioctl.c
@@ -194,7 +194,7 @@ setversion_out:
 	}
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		err = ext4_resize_begin(sb);
 		if (err)
@@ -280,7 +280,7 @@ mext_out:
 
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		err = ext4_resize_begin(sb);
 		if (err)
-- 
1.7.7.3
