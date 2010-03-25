From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH 1/2] ext4: try to relieve ext4_mb_discard_group_preallocations()
	from hard work in simple way
Date: Thu, 25 Mar 2010 23:24:13 +0800
Message-ID: <ac8f92701003250824q6aeeac4cw55cb0d913e5a3bd3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:34269 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0CYPYO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Mar 2010 11:24:14 -0400
Received: by iwn12 with SMTP id 12so7421689iwn.21
        for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 08:24:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Wed Mar 25  23:15:06     2010

The function, ext4_mb_discard_group_preallocations(), works alone as
hard as possible without correct understanding its caller's good
thinking.

And now try to relieve it in simple way.

But the variable, free, may be replaced with freed.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc-11-1.c	2010-03-25 23:06:00.000000000 +0800
@@ -3633,7 +3633,7 @@ repeat:
 		spin_lock(&pa->pa_lock);
 		if (atomic_read(&pa->pa_count)) {
 			spin_unlock(&pa->pa_lock);
-			busy = 1;
+			busy += 1;
 			continue;
 		}
 		if (pa->pa_deleted) {
@@ -3654,7 +3654,7 @@ repeat:
 	}

 	/* if we still need more blocks and some PAs were used, try again */
-	if (free < needed && busy) {
+	if (free < needed && needed <= free + busy) {
 		busy = 0;
 		ext4_unlock_group(sb, group);
 		/*
