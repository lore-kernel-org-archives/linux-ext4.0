From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] ext4: remove unnecessary operation in ext4_mb_normalize_group_request()
Date: Thu, 25 Mar 2010 22:54:21 +0800
Message-ID: <ac8f92701003250754o682aa32dw9bb51f36f0fa433b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:56177 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab0CYPAj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Mar 2010 11:00:39 -0400
Received: by pxi32 with SMTP id 32so3210176pxi.1
        for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 08:00:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Wed Mar 25  22:55:04   2010

Checking bug seems not at right place, and the function itself should
be inlined.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc-10.c	2010-03-25 22:44:00.000000000 +0800
@@ -2786,9 +2786,7 @@ out_err:
 static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
 {
 	struct super_block *sb = ac->ac_sb;
-	struct ext4_locality_group *lg = ac->ac_lg;

-	BUG_ON(lg == NULL);
 	if (EXT4_SB(sb)->s_stripe)
 		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_stripe;
 	else
