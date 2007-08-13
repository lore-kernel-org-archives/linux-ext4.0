From: joe@perches.com
Subject: [PATCH] [186/2many] MAINTAINERS - EXT2 FILE SYSTEM
Date: Sun, 12 Aug 2007 23:27:20 -0700
Message-ID: <46bff9c8.BPUr8K35iRx1Z8l9%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4364 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966366AbXHMG1d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 85ab9fe..653b9a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1792,6 +1792,8 @@ F:	drivers/net/eth16i.c
 EXT2 FILE SYSTEM
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/ext2/
+F:	include/linux/ext2*
 
 EXT3 FILE SYSTEM
 P:	Stephen Tweedie, Andrew Morton
