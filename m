From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 10/10] mke2fs.8.in: update the manual for the -d option
Date: Mon, 23 Dec 2013 07:10:00 -0500
Message-ID: <1387800600-13718-11-git-send-email-liezhi.yang@windriver.com>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:54367 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab3LWMKW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Dec 2013 07:10:22 -0500
In-Reply-To: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update the manual for the -d option

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/mke2fs.8.in |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index df244de..6d7388a 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -52,6 +52,10 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 .I number-of-inodes
 ]
 [
+.B \-d
+.I root-directory
+]
+[
 .B \-n
 ]
 [
@@ -490,6 +494,9 @@ the
 ratio).  This allows the user to specify the number
 of desired inodes directly.
 .TP
+.BI \-d " root-directory"
+Add the files from the root-directory to the filesystem.
+.TP
 .BI \-o " creator-os"
 Overrides the default value of the "creator operating system" field of the
 filesystem.  The creator field is set by default to the name of the OS the
-- 
1.7.10.4

