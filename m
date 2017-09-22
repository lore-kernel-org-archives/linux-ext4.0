From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] mm: have filemap_check_and_advance_wb_err clear AS_EIO/AS_ENOSPC
Date: Fri, 22 Sep 2017 09:33:31 -0400
Message-ID: <20170922133331.28812-1-jlayton@kernel.org>
References: <20170918112312.GN8034@eguan.usersys.redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751877AbdIVNde (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 22 Sep 2017 09:33:34 -0400
In-Reply-To: <20170918112312.GN8034@eguan.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jeff Layton <jlayton@redhat.com>

Eryu noticed that he could sometimes get a leftover error reported when
it shouldn't be on fsync with ext2 and non-journalled ext4. The problem
is that writeback_single_inode still uses filemap_fdatawait. That picks
up a previously set AS_EIO flag, which would ordinarily have been
cleared before.

Since we're mostly using this function as a replacement for
filemap_check_errors, have filemap_check_and_advance_wb_err clear AS_EIO
and AS_ENOSPC when reporting an error. That should allow the new
function to better emulate the behavior of the old with respect to these
flags.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 mm/filemap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 870971e20967..404722ea0fdd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -620,6 +620,14 @@ int file_check_and_advance_wb_err(struct file *file)
 		trace_file_check_and_advance_wb_err(file, old);
 		spin_unlock(&file->f_lock);
 	}
+
+	/*
+	 * We're mostly using this function as a drop in replacement for
+	 * filemap_check_errors. Clear AS_EIO/AS_ENOSPC to emulate the effect
+	 * that the legacy code would have had on these flags.
+	 */
+	clear_bit(AS_EIO, &mapping->flags);
+	clear_bit(AS_ENOSPC, &mapping->flags);
 	return err;
 }
 EXPORT_SYMBOL(file_check_and_advance_wb_err);
-- 
2.13.5
