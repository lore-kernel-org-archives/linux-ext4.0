From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/6] mke2fs: Deprecate -K option, introduce discard/nodiscard
Date: Thu, 18 Nov 2010 14:38:39 +0100
Message-ID: <1290087521-9123-5-git-send-email-lczerner@redhat.com>
References: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, adilger@dilger.ca, lczerner@redhat.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab0KRNi4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 08:38:56 -0500
In-Reply-To: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It would be nice to have consistent "discard" options in every system
tool (mount, fsck, mkfs) taking advantage of discards. Also "discard"
and "nodiscard" is more descriptive instead of just "-K" and can be
easily defaulted and it is something we can not do with "-K".

With this commit you need to specify extended option like this:

./mke2fs -T <fstype> -E nodiscard <device>

in order make a filesystem without discarding the device first. And

./mke2fs -T <fstype> -E discard <device>

respectively.

-K option is with this commit deprecated and should not be used anymore.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.8.in |   18 +++++++++++-------
 misc/mke2fs.c    |   12 +++++++++++-
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index b46e7e2..c587d81 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -45,9 +45,6 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 .I journal-options
 ]
 [
-.B \-K
-]
-[
 .B \-N
 .I number-of-inodes
 ]
@@ -240,6 +237,17 @@ enable lazy inode table initialization.
 .B test_fs
 Set a flag in the filesystem superblock indicating that it may be
 mounted using experimental kernel code, such as the ext4dev filesystem.
+.TP
+.BI discard
+Attempt to discard blocks at mkfs time (discarding blocks initially is useful
+on solid state devices and sparse / thin-provisioned storage). When the device
+advertises that discard also zeroes data (any subsequent read after the discard
+and before write returns zero), then mark all not-yet-zeroed inode tables as
+zeroed. This significantly speeds up filesystem initialization. This is set
+as default.
+.TP
+.BI nodiscard
+Do not attempt to discard blocks at mkfs time. This is the default.
 .RE
 .TP
 .BI \-f " fragment-size"
@@ -369,10 +377,6 @@ and may be no more than 102,400 filesystem blocks.
 @JDEV@.BR size " or " device
 @JDEV@options can be given for a filesystem.
 .TP
-.BI \-K
-Keep, do not attempt to discard blocks at mkfs time (discarding blocks initially
-is useful on solid state devices and sparse / thin-provisioned storage).
-.TP
 .BI \-l " filename"
 Read the bad blocks list from
 .IR filename .
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 3c5d8b7..d63c27f 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -753,6 +753,10 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				lazy_itable_init = strtoul(arg, &p, 0);
 			else
 				lazy_itable_init = 1;
+		} else if (!strcmp(token, "discard")) {
+			discard = 1;
+		} else if (!strcmp(token, "nodiscard")) {
+			discard = 0;
 		} else {
 			r_usage++;
 			badopt = token;
@@ -768,7 +772,9 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\tstripe-width=<RAID stride * data disks in blocks>\n"
 			"\tresize=<resize maximum size in blocks>\n"
 			"\tlazy_itable_init=<0 to disable, 1 to enable>\n"
-			"\ttest_fs\n\n"),
+			"\ttest_fs\n"
+			"\tdiscard\n"
+			"\tnodiscard\n\n"),
 			badopt ? badopt : "");
 		free(buf);
 		exit(1);
@@ -1248,6 +1254,10 @@ static void PRS(int argc, char *argv[])
 			parse_journal_opts(optarg);
 			break;
 		case 'K':
+			fprintf(stderr, _("Warning: -K option is deprecated and "
+					  "should not be used anymore. Use "
+					  "\'-E nodiscard\' extended option "
+					  "instead!\n"));
 			discard = 0;
 			break;
 		case 'j':
-- 
1.7.2.3

