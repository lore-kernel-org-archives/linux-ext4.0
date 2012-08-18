From: Bryce Harrington <bryce@canonical.com>
Subject: [PATCH] e2fsprogs: Fix spelling of 'filesystme' in debugfs help
Date: Fri, 17 Aug 2012 17:10:46 -0700
Message-ID: <20120818001046.GA22945@bryceharrington.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.outflux.net ([198.145.64.163]:58239 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819Ab2HRAKy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 20:10:54 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Bryce Harrington <bryce@canonical.com>
---
 debugfs/debug_cmds.ct |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index af969b1..a799dd7 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -166,7 +166,7 @@ request do_imap, "Calculate the location of an inode",
 request	do_dump_unused, "Dump unused blocks",
 	dump_unused;
 
-request do_set_current_time, "Set current time to use when setting filesystme fields",
+request do_set_current_time, "Set current time to use when setting filesystem fields",
 	set_current_time;
 
 request do_supported_features, "Print features supported by this version of e2fsprogs",
-- 
1.7.9.5

