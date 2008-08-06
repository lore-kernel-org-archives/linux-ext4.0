From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/3] ext4: add EXT4_IOC_GETCRTIME ioctl
Date: Wed, 06 Aug 2008 17:09:07 +0800
Message-ID: <48996A33.3010507@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54614 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759708AbYHFJKl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Aug 2008 05:10:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add EXT4_IOC_GETCRTIME ioctl, and then we can use it in
e2fsprogs.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/ioctl.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 303e41c..a487f2f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -295,6 +295,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
 #define	EXT4_IOC_GETVERSION_OLD		FS_IOC_GETVERSION
 #define	EXT4_IOC_SETVERSION_OLD		FS_IOC_SETVERSION
+#define	EXT4_IOC_GETCRTIME		_IOR('f', 9, struct timespec)
 #ifdef CONFIG_JBD2_DEBUG
 #define EXT4_IOC_WAIT_FOR_READONLY	_IOR('f', 99, long)
 #endif
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 7a6c2f1..6204b5d 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -269,6 +269,9 @@ setversion_out:
 	case EXT4_IOC_MIGRATE:
 		return ext4_ext_migrate(inode, filp, cmd, arg);
 
+	case EXT4_IOC_GETCRTIME:
+		return put_user(ei->i_crtime, (struct timespec __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
1.5.4.rc3
