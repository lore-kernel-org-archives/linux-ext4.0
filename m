From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4.5: remove duplicate .TP in man page
Date: Sat, 11 Jan 2014 22:24:59 -0500
Message-ID: <1389497099-10546-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47641 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaALDZD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 22:25:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/ext4.5.in | 1 -
 1 file changed, 1 deletion(-)

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 98494ec..fab1139 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -109,7 +109,6 @@ supported by ext2, ext3, and ext4.
 This feature enables the storage file type information in directory
 entries.  This feature is supported by ext2, ext3, and ext4.
 .TP
-.TP
 .B flex_bg
 .br
 This ext4 feature allows the per-block group metadata (allocation
-- 
1.8.5.rc3.362.gdf10213

