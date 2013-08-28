From: Robert Yang <liezhi.yang@windriver.com>
Subject: [RFC 09/10] mke2fs.8.in: update the manual for the -d option
Date: Wed, 28 Aug 2013 13:25:59 +0800
Message-ID: <1377667560-20089-10-git-send-email-liezhi.yang@windriver.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:63341 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab3H1Fat (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 01:30:49 -0400
In-Reply-To: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

update the manual for the -d option

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/mke2fs.8.in | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index fe2dcdb..b268154 100644
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
1.8.1.2

