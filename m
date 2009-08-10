From: Mingming <cmm@us.ibm.com>
Subject: [PATCH] compile fix for debuging delalloc patch
Date: Mon, 10 Aug 2009 09:51:30 -0700
Message-ID: <1249923090.27687.4.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:36749 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZHJQvh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 12:51:37 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7AGlCgK015344
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 10:47:12 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7AGpYeN231274
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 10:51:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7AGpXNL020744
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 10:51:33 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix compile errors when compiling ext4 patch queue unstable series..
Need to include smp_lock.h to able to add lock_kernel() call in ioctl.c


Signed-Off-By: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.31-rc4/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/ioctl.c	2009-08-09 14:31:55.000000000 -0700
+++ linux-2.6.31-rc4/fs/ext4/ioctl.c	2009-08-09 14:32:08.000000000 -0700
@@ -15,6 +15,7 @@
 #include <linux/mount.h>
 #include <linux/file.h>
 #include <asm/uaccess.h>
+#include <linux/smp_lock.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
 


