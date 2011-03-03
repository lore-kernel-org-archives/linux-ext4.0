From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: add FITRIM to compat_ioctl.
Date: Thu,  3 Mar 2011 15:58:37 +0800
Message-ID: <1299139117-4336-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40131 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754793Ab1CCH6y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Mar 2011 02:58:54 -0500
Received: from [114.251.86.0] (helo=taoma-linux.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1Pv3Qy-000762-2M
	for linux-ext4@vger.kernel.org; Thu, 03 Mar 2011 00:58:52 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

FITRIM isn't added in compat_ioctl. So a 32 bit program can't be executed
in a 64 bit platform. Add it in the compat_ioctl.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index eb3bc2f..b741809 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -421,6 +421,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return err;
 	}
 	case EXT4_IOC_MOVE_EXT:
+	case FITRIM:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
1.6.3.GIT

