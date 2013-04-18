From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH] tune2fs: Disallow tune2fs to set inode size larger than block
 size
Date: Thu, 18 Apr 2013 17:10:38 +0900
Message-ID: <516FAA7E.3040604@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:65103 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3DRIRX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2013 04:17:23 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r3I8HKlb012188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 18 Apr 2013 17:17:20 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Disallow tune2fs command to set inode size larger than
block size to ext3 and ext4 (^flex_bg).
Without this patch, tune2fs makes FS unmountable.

Steps to reproduce:

1.Create ext4 without flex_bg (or just create ext3)
  # mke2fs -t ext4 -O ^flex_bg DEV

2.Set inode size larger than block size
  # tune2fs -I 8192 DEV
  
3. We failed to mount FS
  # mount DEV MP
    mount: wrong fs type, bad option, bad superblock on /dev/sda7,
           missing codepage or helper program, or other error
           In some cases useful info is found in syslog - try
           dmesg | tail  or so

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 misc/tune2fs.c | 8 ++++++++
 1 file changed, 8 insertions(+)
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index c1ecae8..17e5335 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2370,6 +2370,14 @@ retry_open:
 			rc = 1;
 			goto closefs;
 		}
+		if ((new_inode_size > fs->blocksize) &&
+       			!(fs->super->s_feature_incompat &
+				EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+			fprintf(stderr, _("Invalid inode size %lu (max %d)\n"),
+				new_inode_size, fs->blocksize);
+			rc = 1;
+			goto closefs;
+		}
 
 		/*
 		 * If inode resize is requested use the
