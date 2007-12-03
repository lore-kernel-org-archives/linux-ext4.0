From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: [patch] ext4 i_version: make the flag visible on /proc/mounts
Date: Mon, 03 Dec 2007 17:26:18 +0100
Message-ID: <1196699178.1302.15.camel@frecb002711.frec.bull.fr>
Reply-To: jean-noel.cordenner@bull.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58801 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbXLCQb7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2007 11:31:59 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 9526319D9D4
	for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2007 17:31:57 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22365-09 for <linux-ext4@vger.kernel.org>;
 Mon,  3 Dec 2007 17:31:54 +0100 (CET)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 1826C19D9CF
	for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2007 17:31:54 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch adds the i_version flag in ext4_show_options().



Index: linux-2.6.24-rc3-ext4-1/fs/ext4/super.c
===================================================================
--- linux-2.6.24-rc3-ext4-1.orig/fs/ext4/super.c	2007-12-03 16:14:55.000000000 +0100
+++ linux-2.6.24-rc3-ext4-1/fs/ext4/super.c	2007-12-03 16:16:36.000000000 +0100
@@ -732,6 +732,8 @@
 		seq_puts(seq, ",nobh");
 	if (!test_opt(sb, EXTENTS))
 		seq_puts(seq, ",noextents");
+	if (test_opt(sb, I_VERSION))
+		seq_puts(seq, ",i_version");
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 		seq_puts(seq, ",data=journal");
