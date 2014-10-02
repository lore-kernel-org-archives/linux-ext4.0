From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] mke2fs: fix man page discussion of usage type defaults
Date: Thu, 2 Oct 2014 15:24:52 -0400
Message-ID: <20141002192451.GA2364@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53055 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaJBTY6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2014 15:24:58 -0400
Received: by mail-qa0-f41.google.com with SMTP id n8so2235747qaq.14
        for <linux-ext4@vger.kernel.org>; Thu, 02 Oct 2014 12:24:55 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The man page description of the file system size thresholds used by
mke2fs to select a usage type when not otherwise specified by the -T
switch does not match the code.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 misc/mke2fs.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 88a8b86..aeb5caf 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -705,11 +705,11 @@ using a comma separated list.
 If this option is is not specified,
 .B mke2fs
 will pick a single default usage type based on the size of the filesystem to
-be created.  If the filesystem size is less than or equal to 3 megabytes,
+be created.  If the filesystem size is less than 3 megabytes,
 .B mke2fs
 will use the filesystem type
 .IR floppy .
-If the filesystem size is greater than 3 but less than or equal to
+If the filesystem size is greater than or equal to 3 but less than
 512 megabytes,
 .BR mke2fs (8)
 will use the filesystem type
-- 
1.9.1

