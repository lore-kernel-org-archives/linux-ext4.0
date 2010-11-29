From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 15/15] mke2fs.8.in: add ENVIRONMENT section
Date: Mon, 29 Nov 2010 17:55:17 +0900
Message-ID: <1291020917-8671-16-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43225 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0K2Iz6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:58 -0500
Received: by mail-gx0-f174.google.com with SMTP id 22so1868483gxk.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:58 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add ENVIRONMENT section and describe behavior of MKE2FS_SYNC,
MKE2FS_CONFIG, MKE2FS_FIRST_META_BG, MKE2FS_DEVICE_SECTSIZE
and MKE2FS_SKIP_CHECK_MSG.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 misc/mke2fs.8.in |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 548ef66..e776dcf 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -642,6 +642,29 @@ Verbose execution.
 Print the version number of
 .B mke2fs
 and exit.
+.SH ENVIRONMENT
+.TP
+.BI MKE2FS_SYNC
+If set to non-zero integer value, its value is used to determine how often
+.BR sync (2)
+is called during inode table initialization.
+.TP
+.BI MKE2FS_CONFIG
+Determines the location of the configuration file (see
+.BR mke2fs.conf (5)).
+.TP
+.BI MKE2FS_FIRST_META_BG
+If set to non-zero integer value, its value is used to determine first meta
+block group. This is mostly for debugging purposes.
+.TP
+.BI MKE2FS_DEVICE_SECTSIZE
+If set to non-zero integer value, its value is used to determine physical
+sector size of the
+.IR device .
+.TP
+.BI MKE2FS_SKIP_CHECK_MSG
+If set, do not show the message of filesystem automatic check caused by
+mount count or check interval.
 .SH AUTHOR
 This version of
 .B mke2fs
-- 
1.7.0.4

