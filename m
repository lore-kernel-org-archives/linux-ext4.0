From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] JBD2: Change debug file path
Date: Thu, 7 Jun 2007 23:45:37 -0500
Message-ID: <20070607234537.56537f85@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55269 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbXFHEp5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2007 00:45:57 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l583hIgP018777
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jun 2007 23:43:18 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l584jtOI497684
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 00:45:55 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l584jtgO003909
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 00:45:55 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l584jtY9003900
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 00:45:55 -0400
Received: from gara (sig-9-65-25-65.mts.ibm.com [9.65.25.65])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l584jsI2046800
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jun 2007 23:45:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The jbd2-debug file used to be located in /proc/sys/fs/jbd2-debug, but
create_proc_entry() does not do lookups on file names with more that one
directory deep.  This causes the entry creation to fail and hence, no proc
file is created.  This patch moves the file to /proc/jbd2-degug.

The file could be move to /proc/fs/jbd2/jbd2-debug, but it would require
some minor alterations to the jbd-stats patch.

This is also broken on the original jbd code.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
---
Index: linux-2.6.22-rc3/fs/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/fs/Kconfig	2007-05-25 21:55:14.000000000 -0500
+++ linux-2.6.22-rc3/fs/Kconfig	2007-06-07 23:17:54.110109520 -0500
@@ -260,10 +260,10 @@ config JBD2_DEBUG
 	  By default, the debugging output will be turned off.
 
 	  If you select Y here, then you will be able to turn on debugging
-	  with "echo N > /proc/sys/fs/jbd2-debug", where N is a number between
+	  with "echo N > /proc/jbd2-debug", where N is a number between
 	  1 and 5. The higher the number, the more debugging output is
 	  generated.  To turn debugging off again, do
-	  "echo 0 > /proc/sys/fs/jbd2-debug".
+	  "echo 0 > /proc/jbd2-debug".
 
 config FS_MBCACHE
 # Meta block cache for Extended Attributes (ext2/ext3/ext4)
Index: linux-2.6.22-rc3/fs/jbd2/journal.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/jbd2/journal.c	2007-06-07 23:10:58.838650182 -0500
+++ linux-2.6.22-rc3/fs/jbd2/journal.c	2007-06-07 23:17:54.113442624 -0500
@@ -2288,7 +2288,7 @@ static int write_jbd_debug(struct file *
 	return count;
 }
 
-#define JBD_PROC_NAME "sys/fs/jbd2-debug"
+#define JBD_PROC_NAME "jbd2-debug"
 
 static void __init create_jbd_proc_entry(void)
 {



-JRS
