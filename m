From: "Alexander V. Lukyanov" <lav@netis.ru>
Subject: PATCH: allow inode_readahead_blks=0
Date: Tue, 16 Nov 2010 11:05:47 +0300
Message-ID: <20101116080546.GA7949@proxy>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fire-ce0.netis.ru ([193.233.48.99]:46084 "EHLO fire.netis.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230Ab0KPITS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 03:19:18 -0500
Received: from proxy.yar.ru (proxy.yar.ru [193.233.48.78])
	by fire.netis.ru (8.14.3/8.14.2) with ESMTP id oAG85lt1001000
	for <linux-ext4@vger.kernel.org>; Tue, 16 Nov 2010 11:05:49 +0300 (MSK)
Received: (from root@localhost)
	by proxy.yar.ru (8.14.4/8.14.2/Submit) id oAG85l45017070
	for linux-ext4@vger.kernel.org; Tue, 16 Nov 2010 11:05:47 +0300
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

Currently the value 0 is disallowed, as it is not a power of 2.

This obvious patch fixes the problem.

-- 
   Alexander.

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diff

--- linux-2.6.35/fs/ext4/super.c.0	2010-11-16 10:48:33.418629215 +0300
+++ linux-2.6.35/fs/ext4/super.c	2010-11-16 10:46:07.739753246 +0300
@@ -1657,7 +1657,7 @@
 				return 0;
 			if (option < 0 || option > (1 << 30))
 				return 0;
-			if (!is_power_of_2(option)) {
+			if (option && !is_power_of_2(option)) {
 				ext4_msg(sb, KERN_ERR,
 					 "EXT4-fs: inode_readahead_blks"
 					 " must be a power of 2");
@@ -2274,7 +2274,7 @@
 	if (parse_strtoul(buf, 0x40000000, &t))
 		return -EINVAL;
 
-	if (!is_power_of_2(t))
+	if (t && !is_power_of_2(t))
 		return -EINVAL;
 
 	sbi->s_inode_readahead_blks = t;

--cWoXeonUoKmBZSoM--
