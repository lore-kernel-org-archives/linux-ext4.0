From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix WARN_ON from ext4_releasepage()
Date: Thu,  7 Mar 2013 15:52:49 +0100
Message-ID: <1362667969-19818-1-git-send-email-jack@suse.cz>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab3CGOxH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 09:53:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_releasepage() warns when it is passed a page with PageChecked set.
However this can correctly happen when invalidate_inode_pages2_range()
invalidates pages - and we should fail the release in that case. Since
the page was dirty anyway, it won't be discarded and no harm has
happened but it's good to be safe. Also remove bogus page_has_buffers()
check - we are guaranteed page has buffers in this function.

Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9c4f4b1..34cc72d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2912,8 +2912,8 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
 
 	trace_ext4_releasepage(page);
 
-	WARN_ON(PageChecked(page));
-	if (!page_has_buffers(page))
+	/* Page has dirty journalled data -> cannot release */
+	if (PageChecked(page))
 		return 0;
 	if (journal)
 		return jbd2_journal_try_to_free_buffers(journal, page, wait);
-- 
1.7.1

