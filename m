From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ext4: fix ext4_ioctl_setproject return code
Date: Fri, 08 Jan 2016 22:52:44 +0100
Message-ID: <4720038.3sLXXjk50c@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Li Xi <lixi@ddn.com>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The newly introduced ext4_ioctl_setproject() functions comes in two
versions, one is fine and the other has an undefined return value,
as indicated by a compiler warning:

fs/ext4/ioctl.c:426:1: warning: control reaches end of non-void function [-Wreturn-type]
fs/ext4/ioctl.c: In function 'ext4_ioctl_setproject':

This changes the function to return zero on success, as the other
version does.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: e14c6dbc6429 ("ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support")
---
Found on ARM randconfig testing on the last two linux-next releases.

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c1d45aaa7d55..946560cb3fe6 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -423,6 +423,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 {
 	if (projid != EXT4_DEF_PROJID)
 		return -EOPNOTSUPP;
+	return 0;
 }
 #endif
 
