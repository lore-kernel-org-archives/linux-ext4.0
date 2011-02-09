From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 2/2] mke2fs: use binary units in the man page
Date: Wed,  9 Feb 2011 14:03:27 +0100
Message-ID: <1297256607-4654-2-git-send-email-lczerner@redhat.com>
References: <1297256607-4654-1-git-send-email-lczerner@redhat.com>
Cc: tytso@MIT.EDU, lczerner@redhat.com, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab1BINDg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Feb 2011 08:03:36 -0500
In-Reply-To: <1297256607-4654-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(v2: do not spell units - mebibytes etc... - but rather use just abbrev.)

Decimal units (kilobyte 10^3, megabyte 10^6 etc...) were used in
mke2fs manual page, however they was really meant to be binary units
(kibibyte 2^10, mebibyte 2^20 etc...), so change the man pages to
reflect that fact, even if it sounds weird.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.8.in |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index e093be0..7933dca 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -354,9 +354,9 @@ The following journal options are supported:
 .BI size= journal-size
 Create an internal journal (i.e., stored inside the filesystem) of size
 .I journal-size
-megabytes.
+MiB.
 The size of the journal must be at least 1024 filesystem blocks
-(i.e., 1MB if using 1k blocks, 4MB if using 4k blocks, etc.)
+(i.e., 1MiB if using 1024 byte blocks, 4MiB if using 4096 byte blocks, etc.)
 and may be no more than 102,400 filesystem blocks.
 @JDEV@.TP
 @JDEV@.BI device= external-journal
@@ -633,21 +633,21 @@ using a comma separated list.
 If this option is is not specified,
 .B mke2fs
 will pick a single default usage type based on the size of the filesystem to
-be created.  If the filesystem size is less than or equal to 3 megabytes,
+be created.  If the filesystem size is less than or equal to 3 MiB,
 .B mke2fs
 will use the filesystem type
 .IR floppy .
 If the filesystem size is greater than 3 but less than or equal to
-512 megabytes,
+512 MiB,
 .BR mke2fs (8)
 will use the filesystem type
 .IR small .
-If the filesystem size is greater than or equal to 4 terabytes but less than
-16 terabytes,
+If the filesystem size is greater than or equal to 4 TiB but less than
+16 TiB,
 .BR mke2fs (8)
 will use the filesystem type
 .IR big .
-If the filesystem size is greater than or equal to 16 terabytes,
+If the filesystem size is greater than or equal to 16 TiB,
 .BR mke2fs (8)
 will use the filesystem type
 .IR huge .
-- 
1.7.4

