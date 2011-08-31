From: Surbhi Palande <csurbhi@gmail.com>
Subject: [PATCH] mke2fs.8: Fix the documentation of maximum journal size
Date: Wed, 31 Aug 2011 16:35:57 +0300
Message-ID: <1314797757-12604-1-git-send-email-csurbhi@gmail.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57605 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab1HaNgD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 09:36:03 -0400
Received: by bke11 with SMTP id 11so830715bke.19
        for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 06:36:01 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix the max journal size in mke2fs man page.

Signed-off-by: Surbhi Palande <csurbhi@gmail.com>
---
 misc/mke2fs.8.in |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 6901497..4cd40e4 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -345,7 +345,8 @@ Create an internal journal (i.e., stored inside the filesystem) of size
 megabytes.
 The size of the journal must be at least 1024 filesystem blocks
 (i.e., 1MB if using 1k blocks, 4MB if using 4k blocks, etc.)
-and may be no more than 102,400 filesystem blocks.
+and may be no more than 10240000 filesystem blocks or half the total
+file system size (which ever is smaller)
 @JDEV@.TP
 @JDEV@.BI device= external-journal
 @JDEV@Attach the filesystem to the journal block device located on
-- 
1.7.1

