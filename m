From: Harald Arnesen <skogtun.harald@gmail.com>
Subject: [ext4] Documentation patch
Date: Mon, 01 Dec 2008 17:46:56 +0100
Message-ID: <8763m3u9kv.fsf@basilikum.skogtun.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:40495 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYLAQrB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 11:47:01 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2724227ugf.37
        for <linux-ext4@vger.kernel.org>; Mon, 01 Dec 2008 08:47:00 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My first patch, hope it goes through ok! 
Applies to 2.6.28-rc6-00184-gd9d060a.

Compare ext4's journalling with anything but ext3's. These use the same
journalling modes, most other Linux filesystems do only metadata
journalling.

Signed-off-by: Harald Arnesen <harald@skogtun.org>

========================================================================
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 174eaff..5bbe79e 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -61,7 +61,7 @@ Note: More extensive information for getting started with ext4 can be
   - When comparing performance with other filesystems, remember that
     ext3/4 by default offers higher data integrity guarantees than most.
     So when comparing with a metadata-only journalling filesystem, such
-    as ext3, use `mount -o data=writeback'.  And you might as well use
+    as jfs or xfs, use `mount -o data=writeback'.  And you might as well use
     `mount -o nobh' too along with it.  Making the journal larger than
     the mke2fs default often helps performance with metadata-intensive
     workloads.
-- 
Hilsen Harald.
