From: Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] ext4: fix redirty_page_for_writepage() typo in comment
Date: Thu, 11 Nov 2010 19:23:29 +0800
Message-ID: <20101111112329.GA6923@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Trivial Patch Monkey <trivial@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65200 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab0KKLXb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Nov 2010 06:23:31 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1916164..b82fbd9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3357,7 +3357,7 @@ int ext4_alloc_da_blocks(struct inode *inode)
 	 * doing I/O at all.
 	 *
 	 * We could call write_cache_pages(), and then redirty all of
-	 * the pages by calling redirty_page_for_writeback() but that
+	 * the pages by calling redirty_page_for_writepage() but that
 	 * would be ugly in the extreme.  So instead we would need to
 	 * replicate parts of the code in the above functions,
 	 * simplifying them becuase we wouldn't actually intend to
