From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2 v3] mke2fs: use binary units in the man page
Date: Fri, 20 May 2011 17:36:48 +0200
Message-ID: <1305905808-31093-2-git-send-email-lczerner@redhat.com>
References: <1305905808-31093-1-git-send-email-lczerner@redhat.com>
Cc: tytso@MIT.EDU, sandeen@redhat.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752Ab1ETPg5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 11:36:57 -0400
In-Reply-To: <1305905808-31093-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Decimal units (kilobyte 10^3, megabyte 10^6 etc...) were used in
mke2fs manual page, however they was really meant to be binary units
(kibibyte 2^10, mebibyte 2^20 etc...), so change the man pages to
reflect that fact, even if it sounds weird.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
[v2]: do not spell units - mebibytes etc... - but rather use just abbrev
[v3]: add Reviewed-by: Eric Sandeen <sandeen@redhat.com>
 misc/mke2fs.8.in |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index e685dfb..53b7a5c 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -359,9 +359,9 @@ The following journal options are supported:
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
@@ -638,21 +638,21 @@ using a comma separated list.
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
1.7.4.4

