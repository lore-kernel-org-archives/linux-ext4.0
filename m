From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Date: Wed, 2 Jan 2008 03:32:18 +0200
Message-ID: <20080102013218.GO27566@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758796AbYABBco@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It might make sense to offer ext4 in -mm and even in early -rc kernels, 
but I've already seen people using ext4 simply because a stable kernel 
offered it - and that's definitely not intended.

Anyone who _really_ wants to test ext4 should anyway be able to do the 
trivial change of removing the "depends on BROKEN" line.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f778e1d046a3554ca15b8637afd0ffbf4790801c 
diff --git a/fs/Kconfig b/fs/Kconfig
index 487236c..d850725 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -138,7 +138,7 @@ config EXT3_FS_SECURITY
 
 config EXT4DEV_FS
 	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on BROKEN
 	select JBD2
 	select CRC16
 	help

