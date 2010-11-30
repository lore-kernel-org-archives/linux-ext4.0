From: "Alexander V. Lukyanov" <lav@netis.ru>
Subject: [PATCH] allow inode_readahead_blks=0
Date: Tue, 30 Nov 2010 16:52:20 +0300
Message-ID: <20101130135219.GA22357@proxy>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fire-ce0.netis.ru ([193.233.48.99]:42212 "EHLO fire.netis.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab0K3Nxt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 08:53:49 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello!

Currently the value 0 is disallowed, as it is not a power of 2.

This obvious patch fixes the problem.

Signed-off-by: Alexander V. Lukyanov <lav@netis.ru>

-- 
   Alexander.

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diff

--- fs/ext4/super.c.0	2010-11-16 10:48:33.418629215 +0300
+++ fs/ext4/super.c	2010-11-16 10:46:07.739753246 +0300
@@ -1657,7 +1657,7 @@ set_qf_format:
 				return 0;
 			if (option < 0 || option > (1 << 30))
 				return 0;
-			if (!is_power_of_2(option)) {
+			if (option && !is_power_of_2(option)) {
 				ext4_msg(sb, KERN_ERR,
 					 "EXT4-fs: inode_readahead_blks"
 					 " must be a power of 2");
@@ -2274,7 +2274,7 @@ static ssize_t inode_readahead_blks_stor
 	if (parse_strtoul(buf, 0x40000000, &t))
 		return -EINVAL;
 
-	if (!is_power_of_2(t))
+	if (t && !is_power_of_2(t))
 		return -EINVAL;
 
 	sbi->s_inode_readahead_blks = t;

--LQksG6bCIzRHxTLp--
