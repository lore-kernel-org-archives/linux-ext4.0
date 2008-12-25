From: Nick Warne <nick@ukfsn.org>
Subject: [PATCH] EXT4: super.c
Date: Thu, 25 Dec 2008 01:51:25 +0000
Message-ID: <20081225015125.2f6a99ad@sauron.linicks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:47899 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbYLYBvl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Dec 2008 20:51:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applies to stable 2.6.28.

Remove extraneous newline that creates empty print line
in boot logs.

Signed-off-by: Nick Warne <nick@ukfsn.org>

--- linux-2.6.28/fs/ext4/super.cORIG	2008-12-25 01:35:49.156527726 +0000
+++ linux-2.6.28/fs/ext4/super.c	2008-12-25 01:36:50.914527855 +0000
@@ -1973,7 +1973,7 @@
 	else
 		ext4_warning(sb, __func__,
 			"extents feature not enabled on this filesystem, "
-			"use tune2fs.\n");
+			"use tune2fs.");
 
 	/*
 	 * enable delayed allocation by default


-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
