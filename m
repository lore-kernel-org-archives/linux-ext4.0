From: Valerie Aurora <val@vaaconsulting.com>
Subject: [PATCH] ext4: fix configuration dependencies for ext4 ACLs and security labels
Date: Sat,  5 Jan 2013 19:53:09 -0800
Message-ID: <1357444389-4895-1-git-send-email-val@vaaconsulting.com>
Cc: Valerie Aurora <val@vaaconsulting.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	David Brown <davidb@codeaurora.org>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Tao Ma <boyu.mt@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36393 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab3AFEJ3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2013 23:09:29 -0500
Received: by mail-pa0-f42.google.com with SMTP id rl6so10049190pac.15
        for <linux-ext4@vger.kernel.org>; Sat, 05 Jan 2013 20:09:27 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit "ext4: Remove CONFIG_EXT4_FS_XATTR" removed the configuration
dependencies for ext4 xattrs from the ext4 ACLs and security labels
configuration options, but did not replace them with a dependency on
ext4 itself.  Add back the dependency on ext4 so the options only show
up if ext4 is enabled.

Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
---
 fs/ext4/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 0a475c8..9873587 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -41,6 +41,7 @@ config EXT4_USE_FOR_EXT23
 
 config EXT4_FS_POSIX_ACL
 	bool "Ext4 POSIX Access Control Lists"
+	depends on EXT4_FS
 	select FS_POSIX_ACL
 	help
 	  POSIX Access Control Lists (ACLs) support permissions for users and
@@ -53,6 +54,7 @@ config EXT4_FS_POSIX_ACL
 
 config EXT4_FS_SECURITY
 	bool "Ext4 Security Labels"
+	depends on EXT4_FS
 	help
 	  Security labels support alternative access control models
 	  implemented by security modules like SELinux.  This option
-- 
1.7.10.4

