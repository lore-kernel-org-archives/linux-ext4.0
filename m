From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 06/52] ext4: Fix ext4_mb_init_cache return error
Date: Sat,  5 Jul 2008 13:35:32 -0400
Message-ID: <1215279378-30504-7-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
Cc: Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33029 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754316AbYGERg2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:28 -0400
In-Reply-To: <1215279378-30504-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mingming Cao <cmm@us.ibm.com>

ext4_mb_init_cache() incorrectly always return EIO on success. This
causes the caller of ext4_mb_init_cache() fail when it checks the return
value.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7897193..27498bf 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -803,6 +803,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		if (!buffer_uptodate(bh[i]))
 			goto out;
 
+	err = 0;
 	first_block = page->index * blocks_per_page;
 	for (i = 0; i < blocks_per_page; i++) {
 		int group;
-- 
1.5.6.rc3.1.g36b7.dirty

