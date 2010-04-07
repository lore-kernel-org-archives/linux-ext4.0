From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] ext4: check for EXT4_MB_HINT_NOPREALLOC is added in
	ext4_mb_use_preallocated()
Date: Wed, 7 Apr 2010 21:25:53 +0800
Message-ID: <w2mac8f92701004070625r59b28db9o843ef4dbd95c3428@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:35068 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab0DGNZz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 09:25:55 -0400
Received: by ywh2 with SMTP id 2so565236ywh.33
        for <linux-ext4@vger.kernel.org>; Wed, 07 Apr 2010 06:25:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Wed Apr 7 21:23:48     2010

Since preallocation may not be require by allocation request, check
for it in ext4_mb_use_preallocated() seems necessary.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Aneesh Kumar K. V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc-15.c	2010-04-07 20:16:22.000000000 +0800
@@ -3101,6 +3101,8 @@ ext4_mb_use_preallocated(struct ext4_all
 	/* only data can be preallocated */
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return 0;
+	if (ac->ac_flags & EXT4_MB_HINT_NOPREALLOC)
+		return 0;

 	/* first, try per-file preallocation */
 	rcu_read_lock();
