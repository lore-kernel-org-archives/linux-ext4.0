From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] enable extents mount option by default in ext4
Date: Tue, 15 May 2007 13:43:33 -0700
Message-ID: <1179261813.4819.12.camel@dyn9047017103.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35644 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbXEOUnf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 May 2007 16:43:35 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4FKhZG3031746
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 16:43:35 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4FKhZ3F191600
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 14:43:35 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4FKhYlR030807
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2007 14:43:35 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Turn on extents feature by default in ext4 filesystem. User could use
-o noextents to turn it off.

Signed-Off-By: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.21.1/fs/ext4/super.c
===================================================================
--- linux-2.6.21.1.orig/fs/ext4/super.c	2007-05-11 16:33:10.000000000 -0700
+++ linux-2.6.21.1/fs/ext4/super.c	2007-05-11 16:34:50.000000000 -0700
@@ -1549,6 +1549,12 @@
 
 	set_opt(sbi->s_mount_opt, RESERVATION);
 
+	/*
+	 * turn on extents feature by default in ext4 filesystem
+	 * User -o noextents to turn it off
+	 */
+	set_opt (sbi->s_mount_opt, EXTENTS);
+
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
 			    NULL, 0))
 		goto failed_mount;
