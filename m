From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] Remove unnecessery exported ext4 symbols
Date: Tue, 15 May 2007 13:43:31 -0700
Message-ID: <1179261811.4819.11.camel@dyn9047017103.beaverton.ibm.com>
References: <20070515171527.GA20407@deprecation.cyrius.com>
	 <1179252599.2836.127.camel@dyn9047017100.beaverton.ibm.com>
	 <1179255549.4819.7.camel@dyn9047017103.beaverton.ibm.com>
	 <464A0517.9080302@clusterfs.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@gmail.com>,
	Martin Michlmayr <tbm@cyrius.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:59729 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXEOUng (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2007 16:43:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4FKhY9O024970
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 16:43:34 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4FKhXIh208044
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 14:43:33 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4FKhXN5030721
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 14:43:33 -0600
In-Reply-To: <464A0517.9080302@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

These symbols are used in ext4 only.

Acked-By: Ales Tomas <alex@clusterfs.com>
Signed-Off-By: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.21.1/fs/ext4/extents.c
===================================================================
--- linux-2.6.21.1.orig/fs/ext4/extents.c	2007-05-15 11:52:45.000000000 -0700
+++ linux-2.6.21.1/fs/ext4/extents.c	2007-05-15 11:59:13.000000000 -0700
@@ -2550,12 +2550,3 @@
 
 	return num;
 }
-
-EXPORT_SYMBOL(ext4_mark_inode_dirty);
-EXPORT_SYMBOL(ext4_ext_invalidate_cache);
-EXPORT_SYMBOL(ext4_ext_insert_extent);
-EXPORT_SYMBOL(ext4_ext_walk_space);
-EXPORT_SYMBOL(ext4_ext_find_goal);
-EXPORT_SYMBOL(ext4_ext_calc_credits_for_insert);
-EXPORT_SYMBOL(ext4_fallocate);
-
