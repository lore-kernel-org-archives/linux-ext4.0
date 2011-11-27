From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 34/62] ext2: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:14 +0800
Message-ID: <1322371662-26166-35-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab1K0FfR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Nov 2011 00:35:17 -0500
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/ext2/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 47cda41..378bf28 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -645,7 +645,7 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
 		unlock_page(page);
 		goto fail;
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	memset(kaddr, 0, chunk_size);
 	de = (struct ext2_dir_entry_2 *)kaddr;
 	de->name_len = 1;
@@ -660,7 +660,7 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
 	de->inode = cpu_to_le32(parent->i_ino);
 	memcpy (de->name, "..\0", 4);
 	ext2_set_de_type (de, inode);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	err = ext2_commit_chunk(page, 0, chunk_size);
 fail:
 	page_cache_release(page);
-- 
1.7.4.4

