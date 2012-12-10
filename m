From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 62/63] ERROR: "mb_cache_entry_find_next"
 [fs/ext4/ext4.ko] undefined!
Date: Mon, 10 Dec 2012 16:27:50 -0500
Message-ID: <20121210212750.GA12851@thunk.org>
References: <50c64786.6SgYYMd9siG5ynlG%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <boyu.mt@taobao.com>, linux-ext4@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37873 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab2LJV15 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Dec 2012 16:27:57 -0500
Content-Disposition: inline
In-Reply-To: <50c64786.6SgYYMd9siG5ynlG%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We forgot to audit remote dependencies outside of the fs/ext4 tree on
CONFIG_EXT4_FS_XATTR.  The following patch should fix things up.  (I
won't bother editing all of the defconfig files, since the extra
CONFIG option doesn't do any harm, and modifying those files increases
the chances of merge conflicts.)

Thanks, kbuild test robot!  :-)

					- Ted

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 104322b..34ea4f1 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -200,12 +200,9 @@ inode_readahead_blks=n	This tuning parameter controls the maximum
 			table readahead algorithm will pre-read into
 			the buffer cache.  The default value is 32 blocks.
 
-nouser_xattr		Disables Extended User Attributes. If you have extended
-			attribute support enabled in the kernel configuration
-			(CONFIG_EXT4_FS_XATTR), extended attribute support
-			is enabled by default on mount. See the attr(5) manual
-			page and http://acl.bestbits.at/ for more information
-			about extended attributes.
+nouser_xattr		Disables Extended User Attributes.  See the
+			attr(5) manual page and http://acl.bestbits.at/
+			for more information about extended attributes.
 
 noacl			This option disables POSIX Access Control List
 			support. If ACL support is enabled in the kernel
diff --git a/fs/Kconfig b/fs/Kconfig
index f95ae3a..eaff24a 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -28,8 +28,8 @@ config FS_MBCACHE
 	tristate
 	default y if EXT2_FS=y && EXT2_FS_XATTR
 	default y if EXT3_FS=y && EXT3_FS_XATTR
-	default y if EXT4_FS=y && EXT4_FS_XATTR
-	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS_XATTR
+	default y if EXT4_FS=y
+	default m if EXT2_FS_XATTR || EXT3_FS_XATTR || EXT4_FS
 
 source "fs/reiserfs/Kconfig"
 source "fs/jfs/Kconfig"
