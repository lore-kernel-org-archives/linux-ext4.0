From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 32/60] ext2: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:53 +0800
Message-ID: <1328852421-19678-33-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <amwang@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab2BJFpu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 00:45:50 -0500
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/ext2/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index d37df35..0f4f5c9 100644
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
1.7.7.6

