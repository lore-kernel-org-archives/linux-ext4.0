From: joe@perches.com
Subject: [PATCH] [187/2many] MAINTAINERS - EXT3 FILE SYSTEM
Date: Sun, 12 Aug 2007 23:27:22 -0700
Message-ID: <46bff9ca.G6SlSSqj37lZdpz+%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: torvalds@linux-foundation.org, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4374 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966531AbXHMG1j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 653b9a0..814168d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1796,10 +1796,16 @@ F:	fs/ext2/
 F:	include/linux/ext2*
 
 EXT3 FILE SYSTEM
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
+P:	Stephen Tweedie
+M:	sct@redhat.com
+P:	Andrew Morton
+M:	akpm@linux-foundation.org
+P:	Andreas Dilger
+M:	adilger@clusterfs.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/ext3/
+F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
 P:	Stephen Tweedie, Andrew Morton
