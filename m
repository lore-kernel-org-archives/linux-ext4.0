From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/3] vfs: Add BUG_ON for delayed and unwritten extents in submit_bh
Date: Thu,  7 May 2009 16:09:30 +0530
Message-ID: <1241692770-22547-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37354 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbZEGKjn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 May 2009 06:39:43 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n47AdatP009458
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:39:36 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n47Adh2b1392860
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:39:43 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n47Adgk3008749
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:39:43 +1000
In-Reply-To: <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should not do submit_bh for delayed and unwritten extents. So
add a BUG_ON on them.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/buffer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b3e5be7..ec480c8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2931,6 +2931,8 @@ int submit_bh(int rw, struct buffer_head * bh)
 	BUG_ON(!buffer_locked(bh));
 	BUG_ON(!buffer_mapped(bh));
 	BUG_ON(!bh->b_end_io);
+	BUG_ON(buffer_delay(bh));
+	BUG_ON(buffer_unwritten(bh));
 
 	/*
 	 * Mask in barrier bit for a write (could be either a WRITE or a
-- 
1.6.3.rc4

