From: joe@perches.com
Subject: [PATCH] [272/2many] MAINTAINERS - JOURNALLING LAYER FOR BLOCK
 DEVICES (JBD)
Date: Sun, 12 Aug 2007 23:30:31 -0700
Message-ID: <46bffa87.q9xwD9sRCNFqd2m6%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: torvalds@linux-foundation.org, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4843 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966891AbXHMGap (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ad68cfe..f0d1bce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2599,10 +2599,15 @@ F:	Documentation/filesystems/jfs.txt
 F:	fs/jfs/
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org
+P:	Stephen Tweedie
+M:	sct@redhat.com
+P:	Andrew Morton
+M:	akpm@linux-foundation.org
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/jbd*/
+F:	include/linux/ext*jbd*.h
+F:	include/linux/jbd*.h
 
 K8TEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
