From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] mke2fs: Enable lazy_itable_init on newer kernel by default
Date: Mon, 24 Feb 2014 18:41:06 +0100
Message-ID: <1393263666-21246-2-git-send-email-lczerner@redhat.com>
References: <1393263666-21246-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbaBXRlb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Feb 2014 12:41:31 -0500
In-Reply-To: <1393263666-21246-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently is used did not specified lazy_itable_init option we rely on
information from ext4 module exported via sysfs interface. However if
the ext4 module is not loaded it will not be enabled even though kernel
might support it.

With this commit we set the default according to the kernel version,
however we still allow it to be set manually via extended option or be
enabled in case that ext4 module advertise that it supports this
feature.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 957b4b6..e1c6d09 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2146,7 +2146,15 @@ profile_error:
 			blocksize, sys_page_size);
 	}
 
-	lazy_itable_init = 0;
+	/*
+	 * On newer kernels we do have lazy_itable_init support. So pick the
+	 * right default in case ext4 module is not loaded.
+	 */
+	if (is_before_linux_ver(2, 6, 37))
+		lazy_itable_init = 0;
+	else
+		lazy_itable_init = 1;
+
 	if (access("/sys/fs/ext4/features/lazy_itable_init", R_OK) == 0)
 		lazy_itable_init = 1;
 
-- 
1.8.3.1

