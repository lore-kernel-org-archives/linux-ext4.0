From: Changlong Xie <xiecl.fnst@cn.fujitsu.com>
Subject: [PATCH] ext4: remove MAX_32_NUM
Date: Tue, 8 Dec 2015 11:34:33 +0800
Message-ID: <1449545673-18182-1-git-send-email-xiecl.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

No one use this marco now, just remove it.

Signed-off-by: Changlong Xie <xiecl.fnst@cn.fujitsu.com>
---
 fs/ext4/ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 5e872fd..ea34f70 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -18,8 +18,6 @@
 #include "ext4_jbd2.h"
 #include "ext4.h"
 
-#define MAX_32_NUM ((((unsigned long long) 1) << 32) - 1)
-
 /**
  * Swap memory between @a and @b for @len bytes.
  *
-- 
1.9.3
