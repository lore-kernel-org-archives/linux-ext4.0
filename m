From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] e2fsprogs: make the undo io manager an option
Date: Mon, 3 Dec 2007 14:37:34 -0500
Message-ID: <20071203193734.GB9974@dhcp243-37.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbXLCTmG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Dec 2007 14:42:06 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB3Jg5na009174
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 14:42:05 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB3Jg59t032066
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 14:42:05 -0500
Received: from dhcp243-37.rdu.redhat.com (dhcp243-37.rdu.redhat.com [10.11.243.37])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB3Jg5GY020067
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 14:42:05 -0500
Received: from dhcp243-37.rdu.redhat.com (localhost.localdomain [127.0.0.1])
	by dhcp243-37.rdu.redhat.com (8.14.1/8.14.1) with ESMTP id lB3JbYB0011665
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 14:37:34 -0500
Received: (from jwhiter@localhost)
	by dhcp243-37.rdu.redhat.com (8.14.1/8.14.1/Submit) id lB3JbYcg011664
	for linux-ext4@vger.kernel.org; Mon, 3 Dec 2007 14:37:34 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This applies to the -pu branch of the e2fsprogs git tree.  Went to reformat my
ext3 fs and found it was taking way too long, turns out its because the undo io
manager was doing its thing.  This patch makes this an option, and turns it off
by default.  I opted for off by default so users don't wonder why their mkfs's
are all of a sudden taking alot longer than they used to.  Thank you,

Josef

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 171df5b..613d752 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -74,6 +74,9 @@ mke2fs \- create an ext2/ext3 filesystem
 .B \-v
 ]
 [
+.B \-u
+]
+[
 .B \-F
 ]
 [
@@ -481,6 +484,11 @@ types: small, floppy, news, largefile, and largefile4.
 .B \-v
 Verbose execution.
 .TP
+.B \-u
+Turn on undo io manager.  This will check the volume you are formatting and if
+a existing filesystem is there, it will create an undo file that you can feed
+to undoe2fs to get your original filesystem back.
+.TP
 .B \-V
 Print the version number of 
 .B mke2fs
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index dbbedc0..303f6fc 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -78,6 +78,7 @@ int	force;
 int	noaction;
 int	journal_size;
 int	journal_flags;
+int	undofs;
 char	*bad_blocks_filename;
 __u32	fs_stride;
 
@@ -1001,6 +1002,8 @@ static void PRS(int argc, char *argv[])
 		fs_param.s_rev_level = 0;
 #endif
 
+	undofs = 0;
+
 	if (argc && *argv) {
 		program_name = get_progname(*argv);
 
@@ -1010,7 +1013,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:i:jl:m:no:qr:s:tuvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1127,6 +1130,9 @@ static void PRS(int argc, char *argv[])
 				exit(1);
 			}
 			break;
+		case 'u':
+			undofs = 1;
+			break;
 		case 'v':
 			verbose = 1;
 			break;
@@ -1656,7 +1662,7 @@ int main (int argc, char *argv[])
 	io_ptr = test_io_manager;
 	test_io_backing_manager = unix_io_manager;
 #else
-	if (filesystem_exist(device_name)) {
+	if (undofs && filesystem_exist(device_name)) {
 
 		io_ptr = undo_io_manager;
 		set_undo_io_backing_manager(unix_io_manager);
