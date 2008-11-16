From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 19/20] ext4: Mark the buffer_heads as dirty and uptodate after prepare_write
Date: Sun, 16 Nov 2008 11:05:39 -0500
Message-ID: <1226851540-8032-20-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
 <1226851540-8032-8-git-send-email-tytso@mit.edu>
 <1226851540-8032-9-git-send-email-tytso@mit.edu>
 <1226851540-8032-10-git-send-email-tytso@mit.edu>
 <1226851540-8032-11-git-send-email-tytso@mit.edu>
 <1226851540-8032-12-git-send-email-tytso@mit.edu>
 <1226851540-8032-13-git-send-email-tytso@mit.edu>
 <1226851540-8032-14-git-send-email-tytso@mit.edu>
 <1226851540-8032-15-git-send-email-tytso@mit.edu>
 <1226851540-8032-16-git-send-email-tytso@mit.edu>
 <1226851540-8032-17-git-send-email-tytso@mit.edu>
 <1226851540-8032-18-git-send-email-tytso@mit.edu>
 <1226851540-8032-19-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59000 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753484AbYKPQXi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:23:38 -0500
In-Reply-To: <1226851540-8032-19-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We need to make sure we mark the buffer_heads as dirty and uptodate
so that block_write_full_page write them correctly.

This fixes mmap corruptions that can occur in low memory situations.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit ed9b3e3379731e9f9d2f73f3d7fd9e7d2ce3df4a)
---
 fs/ext4/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4ec89d3..846a790 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2242,6 +2242,8 @@ static int ext4_da_writepage(struct page *page,
 			unlock_page(page);
 			return 0;
 		}
+		/* now mark the buffer_heads as dirty and uptodate */
+		block_commit_write(page, 0, PAGE_CACHE_SIZE);
 	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-- 
1.6.0.4.8.g36f27.dirty

