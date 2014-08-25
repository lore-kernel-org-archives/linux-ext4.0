From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] mke2fs.8.in: explain how the fs-size parameter is interpreted
Date: Sun, 24 Aug 2014 23:59:51 -0400
Message-ID: <1408939192-22656-4-git-send-email-tytso@mit.edu>
References: <1408939192-22656-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47274 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbaHYD76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 23:59:58 -0400
In-Reply-To: <1408939192-22656-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/mke2fs.8.in | 53 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 9c38e20..50d10ec 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -111,7 +111,7 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 ]
 .I device
 [
-.I blocks-count
+.I fs-size
 ]
 @JDEV@.sp
 @JDEV@.B "mke2fs \-O journal_dev"
@@ -139,23 +139,52 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 @JDEV@]
 @JDEV@.I external-journal
 @JDEV@[
-@JDEV@.I blocks-count
+@JDEV@.I fs-size
 @JDEV@]
 .SH DESCRIPTION
 .B mke2fs
 is used to create an ext2, ext3, or ext4 filesystem, usually in a disk
-partition.
-.I device
-is the special file corresponding to the device (e.g
-.IR /dev/hdXX ).
-.I blocks-count
-is the number of blocks on the device.  If omitted,
+partition (or file) named by
+.IR device .
+.PP
+The file system size is specified by
+.IR fs-size .
+If
+.I fs-size
+does not have a suffix, it is interpreted as power-of-two kilobytes,
+unless the
+.B \-b
+.I blocksize
+option is specified, in which case
+.I fs-size
+is interpreted as the number of
+.I blocksize
+blocks.   If the fs-size is suffixed by 'k', 'm', 'g', 't'
+(either upper-case or lower-case), then it is interpreted in
+power-of-two kilobytes, megabytes, gigabytes, terabytes, etc.
+If
+.I fs-size
+is omitted,
 .B mke2fs
-automagically figures the file system size.  If called as
+will create the file system based on the device size.
+.PP
+If
+.B mke2fs
+is run as
+.B mkfs.XXX
+(i.e.,
+.BR mkfs.ext2 ,
+.BR mkfs.ext3 ,
+or
+.BR mkfs.ext4 )
+the option
+.B \-t
+.I XXX
+is implied; so
 .B mkfs.ext3
-a journal is created as if the
-.B \-j
-option was specified.
+will create a file system for use with ext3,
+.B mkfs.ext4
+will create a file system for use with ext4, and so on.
 .PP
 The defaults of the parameters for the newly created filesystem, if not
 overridden by the options listed below, are controlled by the
-- 
2.1.0

