From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] ext4: group cache is added in ext4_mb_discard_preallocations()
Date: Tue, 30 Mar 2010 20:36:17 +0800
Message-ID: <p2yac8f92701003300536kd52f7ad0p43755fcc2382423b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	"zj.barak" <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:48477 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab0C3MgU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2010 08:36:20 -0400
Received: by yxe37 with SMTP id 37so5537124yxe.21
        for <linux-ext4@vger.kernel.org>; Tue, 30 Mar 2010 05:36:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Tue Mar 30 20:35:22     2010

With the added cache, better group locality may be earned when
allocating blocks.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc-13.c	2010-03-30 20:28:08.000000000 +0800
@@ -4183,12 +4183,20 @@ static int ext4_mb_discard_preallocation
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
 	int ret;
 	int freed = 0;
+	static ext4_group_t grp_cache = 0;

 	trace_ext4_mb_discard_preallocations(sb, needed);
-	for (i = 0; i < ngroups && needed > 0; i++) {
-		ret = ext4_mb_discard_group_preallocations(sb, i, needed);
+	if (needed <= 0)
+		return freed;
+	for (i = 0; i < ngroups; i++) {
+		if (grp_cache >= ngroups)
+			grp_cache -= ngroups;
+		ret = ext4_mb_discard_group_preallocations(sb, grp_cache, needed);
 		freed += ret;
 		needed -= ret;
+		if (needed <= 0)
+			break;
+		grp_cache++;
 	}

 	return freed;
