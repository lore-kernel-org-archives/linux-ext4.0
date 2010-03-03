From: Jan Kara <jack@suse.cz>
Subject: [PATCH] [RESEND] ext4: Release page references acquired in ext4_da_block_invalidatepages
Date: Wed,  3 Mar 2010 14:54:07 +0100
Message-ID: <1267624447-19923-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab0CCNyA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Mar 2010 08:54:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We forget to release page references we acquire in
ext4_da_block_invalidatepages.  Luckily, this function gets called only if we
are not able to allocate blocks for delay-allocated data so that function
should better never be called.

Also cleanup handling of index variable.

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c818972..1680007 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2127,17 +2127,16 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
-			index = page->index;
-			if (index > end)
+			if (page->index > end)
 				break;
-			index++;
