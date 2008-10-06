From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH][4/15] e2fsprogs-SLES10--m-support.patch
Date: Mon, 06 Oct 2008 16:01:05 +0530
Message-ID: <1223289065.4007.83.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_fRN9cgGa2cOkhtL4JNkqqA)"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:59567 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYJFKbS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 06:31:18 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m96AVGUO027201
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 10:31:16 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8B00501BQOJ300@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 06 Oct 2008 18:31:15 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_fRN9cgGa2cOkhtL4JNkqqA)
Content-type: text/plain
Content-transfer-encoding: 7BIT

SLES9 patch to add "fsck -m" option to skip checking mounted
filesystems.
This isn't in their upstream e2fsprogs, since SLES uses the fsck in
util-linux, but is needed for compatibility.


--Boundary_(ID_fRN9cgGa2cOkhtL4JNkqqA)
Content-type: text/x-patch; charset=UTF-8;
 name=e2fsprogs-SLES10--m-support.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-SLES10--m-support.patch

Index: e2fsprogs-1.40.7/misc/fsck.8.in
===================================================================
--- e2fsprogs-1.40.7.orig/misc/fsck.8.in
+++ e2fsprogs-1.40.7/misc/fsck.8.in
@@ -8,7 +8,7 @@ fsck \- check and repair a Linux file sy
 .SH SYNOPSIS
 .B fsck
 [
-.B \-sAVRTMNP
+.B \-sAVRTmMNP
 ]
 [
 .B \-C
@@ -233,7 +233,7 @@ a progress bar at a time.  GUI front-end
 .IR fd ,
 in which case the progress bar information will be sent to that file descriptor.
 .TP
-.B \-M
+.B \-m or \-M
 Do not check mounted filesystems and return an exit code of 0
 for mounted filesystems.
 .TP
Index: e2fsprogs-1.40.7/misc/fsck.c
===================================================================
--- e2fsprogs-1.40.7.orig/misc/fsck.c
+++ e2fsprogs-1.40.7/misc/fsck.c
@@ -1063,7 +1063,7 @@ static int check_all(NOARGS)
 
 static void usage(NOARGS)
 {
-	fputs(_("Usage: fsck [-AMNPRTV] [ -C [ fd ] ] [-t fstype] [fs-options] [filesys ...]\n"), stderr);
+	fputs(_("Usage: fsck [-AmMNPRTV] [ -C [ fd ] ] [-t fstype] [fs-options] [filesys ...]\n"), stderr);
 	exit(EXIT_USAGE);
 }
 
@@ -1185,6 +1185,7 @@ static void PRS(int argc, char *argv[])
 			case 'T':
 				notitle++;
 				break;
+			case 'm':
 			case 'M':
 				ignore_mounted++;
 				break;

--Boundary_(ID_fRN9cgGa2cOkhtL4JNkqqA)--
