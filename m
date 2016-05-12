From: Marcus Huewe <suse-tux@gmx.de>
Subject: [PATCH 2/2] mke2fs: fix filesystem size calculation, if an offset is
 specified
Date: Thu, 12 May 2016 18:22:50 +0200
Message-ID: <20160512162250.GA4662@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57545 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752405AbcELQWz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 May 2016 12:22:55 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a filesystem size is explicitly specified, it should be used without
subtracting the offset.

Signed-off-by: Marcus Huewe <suse-tux@gmx.de>
---
 misc/mke2fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index dd5bb35..e0a98e7 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1874,6 +1874,8 @@ profile_error:
 		flags |= VERBOSE_CREATE;
 	if (fs_blocks_count == 0)
 		flags |= NO_SIZE;
+	else
+		explicit_fssize = 1;
 	if (!check_plausibility(device_name, flags, &is_device) && !force)
 		proceed_question(proceed_delay);
 
@@ -1881,7 +1883,6 @@ profile_error:
 
 	/* Determine the size of the device (if possible) */
 	if (noaction && fs_blocks_count) {
-		explicit_fssize = 1;
 		dev_size = fs_blocks_count;
 		retval = 0;
 	} else
-- 
2.6.3

