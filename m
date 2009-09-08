From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] Skip "rootfs" entry when checking for ext4 filesystem.
Date: Tue, 08 Sep 2009 11:13:50 -0500
Message-ID: <4AA682BE.2030200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ravi@p-static.net
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZIHQNv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 12:13:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Skip "rootfs" entry when checking for ext4 filesystem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 82e3868..0d04df9 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -430,6 +430,8 @@ static int is_ext4(const char *file)
 	}
 
 	while ((mnt = getmntent(fp)) != NULL) {
+		if (mnt->mnt_fsname[0] != '/')
+			continue;
 		len = strlen(mnt->mnt_dir);
 		ret = memcmp(file_path, mnt->mnt_dir, len);
 		if (ret != 0)

