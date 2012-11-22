From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] libext2fs: change mmp.c to LGPL to match other files
Date: Thu, 22 Nov 2012 15:29:15 -0700
Message-ID: <1353623355-23996-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32006 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2KVW3T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2012 17:29:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change the license of the mmp.c file to LGPL to match the license
of other files in the libext2fs library.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/ext2fs/mmp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index 10fb68a..d09178e 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -4,8 +4,8 @@
  * Copyright (C) 2011 Whamcloud, Inc.
  *
  * %Begin-Header%
- * This file may be redistributed under the terms of the GNU Public
- * License.
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
  * %End-Header%
  */
 
-- 
1.7.3.4

