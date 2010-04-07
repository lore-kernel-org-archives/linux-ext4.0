From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] ext4: BUG_ON could be triggered in ext4_mb_normalize_request()
Date: Wed, 7 Apr 2010 21:51:46 +0800
Message-ID: <j2oac8f92701004070651xf35cfb9bsedcdd25169427515@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33406 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0DGNwF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 09:52:05 -0400
Received: by gyg13 with SMTP id 13so558184gyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 07 Apr 2010 06:52:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Wed Apr 7 21:34:48     2010

BUG_ON at [line: 2912] could be triggered,
     if (pa->pa_deleted == 0 && pa->pa_free == 0)
as checked at [line: 3111] and [line: 3122].

It is bypassed by adding check for pa_free.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Aneesh Kumar K. V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc-16.c	2010-04-07 20:20:26.000000000 +0800
@@ -2901,7 +2901,7 @@ ext4_mb_normalize_request(struct ext4_al
 		if (pa->pa_deleted)
 			continue;
 		spin_lock(&pa->pa_lock);
-		if (pa->pa_deleted) {
+		if (pa->pa_deleted || 0 == pa->pa_free) {
 			spin_unlock(&pa->pa_lock);
 			continue;
 		}
