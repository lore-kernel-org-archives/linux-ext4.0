From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: init pagevec in ext4_da_block_invalidatepages
Date: Sun, 11 Nov 2012 15:33:34 -0600
Message-ID: <50A019AE.7090907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2KKVdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Nov 2012 16:33:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_da_block_invalidatepages is missing a pagevec_init(),
which means that pvec->cold contains random garbage.

This affects whether the page goes to the front or
back of the LRU when ->cold makes it to
free_hot_cold_page()

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b3c243b..f89c0e5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1503,6 +1503,8 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd)
 
 	index = mpd->first_page;
 	end   = mpd->next_page - 1;
+
+	pagevec_init(&pvec, 0);
 	while (index <= end) {
 		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
 		if (nr_pages == 0)

