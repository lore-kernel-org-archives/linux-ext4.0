From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -v3] ext4: Take page lock before looking at attached buffer_heads flags
Date: Mon,  7 Sep 2009 15:14:44 +0530
Message-ID: <1252316684-10646-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <20090831063006.GA7711@skywalker.linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37958 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZIGJot (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2009 05:44:49 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id n879f5IN007201
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:41:05 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n879ipCe479436
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:44:51 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n879io4q005249
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:44:51 +1000
In-Reply-To: <20090831063006.GA7711@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inorder to check whether the buffer_heads are mapped we need
to hold page lock. Otherwise a reclaim can cleanup the attached
buffer_heads.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f9c642b..2feb2d5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5281,12 +5281,21 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	else
 		len = PAGE_CACHE_SIZE;
 
+	lock_page(page);
+	/*
+	 * return if we have all the buffers mapped. This avoid
+	 * the need to call write_begin/write_end which does a
+	 * journal_start/journal_stop which can block and take
+	 * long time
+	 */
 	if (page_has_buffers(page)) {
-		/* return if we have all the buffers mapped */
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-				       ext4_bh_unmapped))
+					ext4_bh_unmapped)) {
+			unlock_page(page);
 			goto out_unlock;
+		}
 	}
+	unlock_page(page);
 	/*
 	 * OK, we need to fill the hole... Do write_begin write_end
 	 * to do block allocation/reservation.We are not holding
-- 
1.6.4.2.253.g0b1fac

