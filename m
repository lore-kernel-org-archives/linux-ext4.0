From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 8/8] e2fsck/jfs_user.h: Fix b_data alignment in struct
 buffer_head
Date: Fri, 14 Dec 2012 00:04:34 +0200
Message-ID: <20121213220433.GP9713@sli.dy.fi>
References: <cover.1355435985.git.sami.liedes@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:57564 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab2LMWiu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 17:38:50 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4fQG019961
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:41 +0200
Received: from smtp-3.hut.fi ([130.233.228.93])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 13476-1558 for <linux-ext4@vger.kernel.org>;
 Fri, 14 Dec 2012 00:04:41 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4Yn8019949
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:34 +0200
Content-Disposition: inline
In-Reply-To: <cover.1355435985.git.sami.liedes@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

buffer_head.b_data needs to be 8-byte aligned to prevent an unaligned
access via a 64-bit pointer in e.g. scan_revoke_records().

Caught using clang -fsanitize=undefined.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 e2fsck/jfs_user.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index 3cccd3f..fdaf1b2 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -22,7 +22,7 @@ struct buffer_head {
 	int	 	b_dirty;
 	int	 	b_uptodate;
 	int	 	b_err;
-	char		b_data[1024];
+	char		b_data[1024]  __attribute__ ((aligned (8)));
 };
 
 struct inode {
-- 
1.7.10.4
