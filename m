From: Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] namei.h: include errno.h
Date: Mon, 24 Dec 2012 11:14:58 -0700
Message-ID: <1356372898-21272-1-git-send-email-swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:49826 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXSPK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2012 13:15:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This solves:

In file included from fs/ext3/symlink.c:20:0:
include/linux/namei.h: In function 'retry_estale':
include/linux/namei.h:114:19: error: 'ESTALE' undeclared (first use in this function)

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 include/linux/namei.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/namei.h b/include/linux/namei.h
index e998c03..5a5ff57 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -2,6 +2,7 @@
 #define _LINUX_NAMEI_H
 
 #include <linux/dcache.h>
+#include <linux/errno.h>
 #include <linux/linkage.h>
 #include <linux/path.h>
 
-- 
1.7.10.4

