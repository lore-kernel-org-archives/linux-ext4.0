From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 10/15] mke2fs.8.in: add missing "big" and "huge" usage-type description
Date: Mon, 29 Nov 2010 17:55:12 +0900
Message-ID: <1291020917-8671-11-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51817 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0K2Izq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:46 -0500
Received: by mail-gw0-f46.google.com with SMTP id 20so1866691gwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:46 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The commit 493024ea1d74e4cb48aac3a24111f5c8da343e9f ("mke2fs: Fix up the
fs type and feature selection for 64-bit blocks") added 'big' and 'huge'
usage-type but was missing description in man page. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 misc/mke2fs.8.in |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index b46e7e2..548ef66 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -616,8 +616,17 @@ will use the filesystem type
 If the filesystem size is greater than 3 but less than or equal to
 512 megabytes,
 .BR mke2fs (8)
-will use the filesystem
+will use the filesystem type
 .IR small .
+If the filesystem size is greater than or equal to 4 terabytes but less than
+16 terabytes,
+.BR mke2fs (8)
+will use the filesystem type
+.IR big .
+If the filesystem size is greater than or equal to 16 terabytes,
+.BR mke2fs (8)
+will use the filesystem type
+.IR huge .
 Otherwise,
 .BR mke2fs (8)
 will use the default filesystem type
-- 
1.7.0.4

