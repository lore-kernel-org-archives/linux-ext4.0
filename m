From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] tune2fs: fix man page indentation
Date: Fri, 13 Apr 2012 13:12:07 -0700
Message-ID: <1334347927-12749-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48651 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab2DMUML (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 16:12:11 -0400
Received: by eekc41 with SMTP id c41so155782eek.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Apr 2012 13:12:10 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The indentation in tune2fs man page was wrong towards the
end. Also, there was extra '[' in the SYNOPSIS section.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 misc/tune2fs.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 32f73a9..e77dde7 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -81,7 +81,6 @@ tune2fs \- adjust tunable filesystem parameters on ext2/ext3/ext4 filesystems
 .I quota-options
 ]
 [
-[
 .B \-T
 .I time-last-checked
 ]
@@ -599,6 +598,7 @@ Sets/clears user quota inode in the superblock.
 .TP
 .BR [^]grpquota
 Sets/clears group quota inode in the superblock.
+.RE
 .TP
 .BI \-T " time-last-checked"
 Set the time the filesystem was last checked using
-- 
1.7.7.3

