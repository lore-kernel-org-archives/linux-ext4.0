From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsprogs: Fix how we treat user-spcified filesystem size
Date: Tue,  1 Feb 2011 20:18:32 +0100
Message-ID: <1296587912-16756-1-git-send-email-lczerner@redhat.com>
Cc: tytso@MIT.EDU, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab1BATSh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Feb 2011 14:18:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mke2fs and resize2fs allows specifying filesystem size as a parameter,
former called as blocks-count. However it has been a little bit messy so
this commit fixes it mainly by updating man pages.

We can not specify filesystem size in blocks count withou specifying
blocksize as well. It is because we need blocks count to determine
filesystem type, and we need filesystem type to determine blocksize. So
it should not be allowed, however due to compatibility reason it should
be still possible, so at least print warning message for now, so we can
easily restrict that later.

Filesystem size can be specified using units as suffixes. This was not
documented for mke2fs, so this commits adds proper documentation into
mke2fs man page.

For the sake of completeness add 'b' (blocks count) unit.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/e2p/parse_num.c   |    9 +++++++++
 misc/mke2fs.8.in      |   40 ++++++++++++++++++++++++++++++++++------
 resize/resize2fs.8.in |    8 ++++----
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/lib/e2p/parse_num.c b/lib/e2p/parse_num.c
index 83a329a..5e7924b 100644
--- a/lib/e2p/parse_num.c
+++ b/lib/e2p/parse_num.c
@@ -10,6 +10,7 @@
  */
 
 #include "e2p.h"
+#include "../misc/nls-enable.h"
 
 #include <stdlib.h>
 
@@ -37,6 +38,14 @@ unsigned long long parse_num_blocks2(const char *arg, int log_block_size)
 		num >>= (1+log_block_size);
 		break;
 	case '\0':
+	case 'b':
+		if (!log_block_size) {
+			fprintf(stderr,
+				_("Warning: You can not specify blocks count "
+				"without specifying block size '-b'. Will "
+				"assume kilobytes instead of blocks count!.\n"
+				));
+		}
 		break;
 	default:
 		return 0;
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 2eead17..67a69b8 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -108,7 +108,7 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 ]
 .I device
 [
-.I blocks-count
+.I filesystem-size
 ]
 @JDEV@.sp
 @JDEV@.B "mke2fs \-O journal_dev"
@@ -136,7 +136,7 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 @JDEV@]
 @JDEV@.I external-journal
 @JDEV@[
-@JDEV@.I blocks-count
+@JDEV@.I filesystem-size
 @JDEV@]
 .SH DESCRIPTION
 .B mke2fs
@@ -145,15 +145,43 @@ partition.
 .I device
 is the special file corresponding to the device (e.g
 .IR /dev/hdXX ).
-.I blocks-count
-is the number of blocks on the device.  If omitted,
-.B mke2fs
-automagically figures the file system size.  If called as
+.I filesystem-size
+is the size of the filesystem you want to create.
+If no units are specified, the units of the
+.I filesystem-size
+parameter shall be the blocks count of the filesystem. Keep in mind that
+you can not specify
+.I filesystem-size
+in blocks count without specifying the blocksize as well. This will be
+allowed for now (kilobytes will be assumed)
+due to compatibility reasons, however it may be restricted
+in the future.
+Optionally, the
+.I filesystem-size
+parameter may be suffixed by one of the following the units
+designators: 'b', 's', 'K', 'M', or 'G',
+for blocks count, 512 byte sectors, kilobytes, megabytes, or gigabytes,
+respectively.
+The
+.I filesystem-size
+may never be larger than the size of the partition.
+If
+.I filesystem-size
+parameter is not specified, it will default to the size of the partition.
+If called as
 .B mkfs.ext3
 a journal is created as if the
 .B \-j
 option was specified.
 .PP
+Note: when kilobytes is used above, I mean
+.IR real ,
+power-of-2 kilobytes, (i.e., 1024 bytes), which some politically correct
+folks insist should be the stupid-sounding ``kibibytes''.  The same
+holds true for megabytes, also sometimes known as ``mebibytes'', or
+gigabytes, as the amazingly silly ``gibibytes''.  Makes you want to
+gibber, doesn't it?
+.PP
 The defaults of the parameters for the newly created filesystem, if not
 overridden by the options listed below, are controlled by the
 .B /etc/mke2fs.conf
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index e02345d..52aaef8 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -38,13 +38,13 @@ The
 parameter specifies the requested new size of the filesystem.
 If no units are specified, the units of the
 .I size
-parameter shall be the filesystem blocksize of the filesystem.
+parameter shall be the blocks count of the filesystem.
 Optionally, the 
 .I size
 parameter may be suffixed by one of the following the units 
-designators: 's', 'K', 'M', or 'G',
-for 512 byte sectors, kilobytes, megabytes, or gigabytes, respectively.
-The 
+designators: 'b', 's', 'K', 'M', or 'G',
+for blocks count, 512 byte sectors, kilobytes, megabytes, or gigabytes,
+respectively. The
 .I size
 of the filesystem may never be larger than the size of the partition.
 If 
-- 
1.7.2.3

