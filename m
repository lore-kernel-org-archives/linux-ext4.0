From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.27 19/24] ext4: Init the complete page while building buddy cache
Date: Tue, 17 Feb 2009 10:58:39 -0500
Message-ID: <1234886324-15105-20-git-send-email-tytso@mit.edu>
References: <1234886324-15105-1-git-send-email-tytso@mit.edu>
 <1234886324-15105-2-git-send-email-tytso@mit.edu>
 <1234886324-15105-3-git-send-email-tytso@mit.edu>
 <1234886324-15105-4-git-send-email-tytso@mit.edu>
 <1234886324-15105-5-git-send-email-tytso@mit.edu>
 <1234886324-15105-6-git-send-email-tytso@mit.edu>
 <1234886324-15105-7-git-send-email-tytso@mit.edu>
 <1234886324-15105-8-git-send-email-tytso@mit.edu>
 <1234886324-15105-9-git-send-email-tytso@mit.edu>
 <1234886324-15105-10-git-send-email-tytso@mit.edu>
 <1234886324-15105-11-git-send-email-tytso@mit.edu>
 <1234886324-15105-12-git-send-email-tytso@mit.edu>
 <1234886324-15105-13-git-send-email-tytso@mit.edu>
 <1234886324-15105-14-git-send-email-tytso@mit.edu>
 <1234886324-15105-15-git-send-email-tytso@mit.edu>
 <1234886324-15105-16-git-send-email-tytso@mit.edu>
 <1234886324-15105-17-git-send-email-tytso@mit.edu>
 <1234886324-15105-18-git-send-email-tytso@mit.edu>
 <1234886324-15105-19-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56245 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZBQQOx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:14:53 -0500
In-Reply-To: <1234886324-15105-19-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We need to init the complete page during buddy cache init
by setting the contents to '1'.  Otherwise we can see the
following errors after doing an online resize of the
filesystem:

EXT4-fs error (device sdb1): ext4_mb_mark_diskspace_used:
	Allocating block 1040385 in system zone of 127 group

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit 29eaf024980e07cc01f31ae4ea5d68c917f4b7da)
---
 fs/ext4/mballoc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cf47340..dbf6c0e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -848,6 +848,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 	err = 0;
 	first_block = page->index * blocks_per_page;
+	/* init the page  */
+	memset(page_address(page), 0xff, PAGE_CACHE_SIZE);
 	for (i = 0; i < blocks_per_page; i++) {
 		int group;
 		struct ext4_group_info *grinfo;
@@ -874,7 +876,6 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			BUG_ON(incore == NULL);
 			mb_debug("put buddy for group %u in page %lu/%x\n",
 				group, page->index, i * blocksize);
-			memset(data, 0xff, blocksize);
 			grinfo = ext4_get_group_info(sb, group);
 			grinfo->bb_fragments = 0;
 			memset(grinfo->bb_counters, 0,
-- 
1.5.6.3

