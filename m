From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: drop ext4dev compat
Date: Sun, 20 Sep 2009 21:44:53 -0500
Message-ID: <4AB6E8A5.8090008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720AbZIUCpc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Sep 2009 22:45:32 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8L2jZEc002706
	for <linux-ext4@vger.kernel.org>; Sun, 20 Sep 2009 22:45:36 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8L2irg2018903
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 20 Sep 2009 22:45:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kconfig & super.c promised it'd be gone by 2.6.31, so it's
about time to drop it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index d5c0ea2..9f2d45d 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -26,20 +26,6 @@ config EXT4_FS
 
 	  If unsure, say N.
 
-config EXT4DEV_COMPAT
-	bool "Enable ext4dev compatibility"
-	depends on EXT4_FS
-	help
-	  Starting with 2.6.28, the name of the ext4 filesystem was
-	  renamed from ext4dev to ext4.  Unfortunately there are some
-	  legacy userspace programs (such as klibc's fstype) have
-	  "ext4dev" hardcoded.
-
-	  To enable backwards compatibility so that systems that are
-	  still expecting to mount ext4 filesystems using ext4dev,
-	  choose Y here.   This feature will go away by 2.6.31, so
-	  please arrange to get your userspace programs fixed!
-
 config EXT4_FS_XATTR
 	bool "Ext4 extended attributes"
 	depends on EXT4_FS
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a6b1ab7..f20c2d1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3951,27 +3951,6 @@ static struct file_system_type ext4_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-#ifdef CONFIG_EXT4DEV_COMPAT
-static int ext4dev_get_sb(struct file_system_type *fs_type, int flags,
-			  const char *dev_name, void *data,struct vfsmount *mnt)
-{
-	printk(KERN_WARNING "EXT4-fs (%s): Update your userspace programs "
-	       "to mount using ext4\n", dev_name);
-	printk(KERN_WARNING "EXT4-fs (%s): ext4dev backwards compatibility "
-	       "will go away by 2.6.31\n", dev_name);
-	return get_sb_bdev(fs_type, flags, dev_name, data, ext4_fill_super,mnt);
-}
-
-static struct file_system_type ext4dev_fs_type = {
-	.owner		= THIS_MODULE,
-	.name		= "ext4dev",
-	.get_sb		= ext4dev_get_sb,
-	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
-};
-MODULE_ALIAS("ext4dev");
-#endif
-
 static int __init init_ext4_fs(void)
 {
 	int err;
@@ -3996,13 +3975,6 @@ static int __init init_ext4_fs(void)
 	err = register_filesystem(&ext4_fs_type);
 	if (err)
 		goto out;
-#ifdef CONFIG_EXT4DEV_COMPAT
-	err = register_filesystem(&ext4dev_fs_type);
-	if (err) {
-		unregister_filesystem(&ext4_fs_type);
-		goto out;
-	}
-#endif
 	return 0;
 out:
 	destroy_inodecache();
@@ -4021,9 +3993,6 @@ out4:
 static void __exit exit_ext4_fs(void)
 {
 	unregister_filesystem(&ext4_fs_type);
-#ifdef CONFIG_EXT4DEV_COMPAT
-	unregister_filesystem(&ext4dev_fs_type);
-#endif
 	destroy_inodecache();
 	exit_ext4_xattr();
 	exit_ext4_mballoc();

