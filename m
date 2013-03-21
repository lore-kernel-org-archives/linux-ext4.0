From: Sander <sander@humilis.net>
Subject: [PATCH][TRIVIAL] Documentation/filesystems/ext4.txt  barriers ->
 barrier
Date: Thu, 21 Mar 2013 16:31:21 +0100
Message-ID: <20130321153121.GA17388@panda>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:58531 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab3CUPbX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Mar 2013 11:31:23 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello list,

I've found a small typo in Documentation/filesystems/ext4.txt

	Sander

--ZPt4rx8FFjLCG7dd
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ext4-doc.patch"

diff -ruN linux-3.9-rc3-orig/Documentation/filesystems/ext4.txt linux-3.9-rc3/Documentation/filesystems/ext4.txt
--- linux-3.9-rc3-orig/Documentation/filesystems/ext4.txt	2013-03-17 23:59:32.000000000 +0100
+++ linux-3.9-rc3/Documentation/filesystems/ext4.txt	2013-03-21 18:27:19.246017488 +0100
@@ -65,7 +65,7 @@
     note that ext4 enables write barriers by default, while ext3 does
     not enable write barriers by default.  So it is useful to use
     explicitly specify whether barriers are enabled or not when via the
-    '-o barriers=[0|1]' mount option for both ext3 and ext4 filesystems
+    '-o barrier=[0|1]' mount option for both ext3 and ext4 filesystems
     for a fair comparison.  When tuning ext3 for best benchmark numbers,
     it is often worthwhile to try changing the data journaling mode; '-o
     data=writeback' can be faster for some workloads.  (Note however that

--ZPt4rx8FFjLCG7dd--
