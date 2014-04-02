From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] ext4: Ensure that inode is non-NULL before calling
 ext4_error_inode
Date: Wed, 2 Apr 2014 10:36:30 -0400
Message-ID: <20140402143630.GB27299@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41813 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbaDBOgr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2014 10:36:47 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


__ext4_handle_dirty_metadata can be called with a NULL inode, but
ext4_error_inode can't.  This is supposed to be a "can't happen" path,
so we need to find out whether it can legitimately happen or whether
there's some other bug that is causing this to happen.  This prevents
a NULL pointer reference, so it should be included regardless of what
the underlying error is.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext4/ext4_jbd2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 3fe29de..383d586 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -259,7 +259,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 		if (WARN_ON_ONCE(err)) {
 			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
-			ext4_error_inode(inode, where, line,
+			if (inode)
+				ext4_error_inode(inode, where, line,
 					 bh->b_blocknr,
 					 "journal_dirty_metadata failed: "
 					 "handle type %u started at line %u, "
-- 
1.9.0

