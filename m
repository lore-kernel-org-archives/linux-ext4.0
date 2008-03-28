From: Pietro Gagliardi <pietro10@mac.com>
Subject: [RESEND] Kernel patch: ext2 creators list update
Date: Fri, 28 Mar 2008 18:02:26 -0400
Message-ID: <A5A271B0-FE4F-49E1-90E2-521E9F05F81D@mac.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtpoutm.mac.com ([17.148.16.77]:55283 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559AbYC1WCh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Mar 2008 18:02:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello. Sorry for resending this; I didn't follow all the rules :-)

I'm working on a new OS that will have ext2 as the primary  
filesystem. I'm adding my OS to the list of creators, for the  
superblock item s_creator_os. I know the kernel doesn't use these  
values; I don't know if any user programs do, though. The patch is to  
2.6.24.4.

== linux.patch ==
--- linux-2.6.24.4/include/linux/ext2_fs.h.orig	2008-03-24  
14:49:18.000000000 -0400
+++ linux-2.6.24.4/include/linux/ext2_fs.h	2008-03-28  
17:36:55.000000000 -0400
@@ -426,6 +426,7 @@ struct ext2_super_block {
  #define EXT2_OS_MASIX		2
  #define EXT2_OS_FREEBSD		3
  #define EXT2_OS_LITES		4
+#define EXT2_OS_PGOS        5

  /*
   * Revision levels
== end of linux.patch ==

If you'd like to see the source code for this driver, just send me  
back an email and I'll gladly put it up.

