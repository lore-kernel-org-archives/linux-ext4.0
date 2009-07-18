From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] ext4: Fix typo in ext4/Kconfig
Date: Sat, 18 Jul 2009 17:26:39 +0530
Message-ID: <ea11fea30907180456g35b378bdt4bfe6862d29d5b30@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:61132 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZGRL47 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jul 2009 07:56:59 -0400
Received: by gxk9 with SMTP id 9so2498506gxk.13
        for <linux-ext4@vger.kernel.org>; Sat, 18 Jul 2009 04:56:59 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix typo in ext4/Kconfig

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 418b6f3..1523046 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -37,7 +37,7 @@ config EXT4DEV_COMPAT

 	  To enable backwards compatibility so that systems that are
 	  still expecting to mount ext4 filesystems using ext4dev,
-	  chose Y here.   This feature will go away by 2.6.31, so
+	  choose Y here.   This feature will go away by 2.6.31, so
 	  please arrange to get your userspace programs fixed!

 config EXT4_FS_XATTR
-- 
1.6.0.4


-- 
Thanks -
Manish
