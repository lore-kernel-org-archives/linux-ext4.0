Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46010 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725743AbeJaGyA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 Oct 2018 02:54:00 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 10/11] ext4: remove useless brelse call in
 ext4_xattr_inode_update_ref()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
References: <cover.1540935522.git.vvs@virtuozzo.com>
Message-ID: <fb87bcc2-5e4a-34ba-a063-3f43e9de976c@virtuozzo.com>
Date: Wed, 31 Oct 2018 00:58:46 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1540935522.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

brelse(iloc.bh) is useless here, it is always called with iloc.bh = NULL

Fixes dec214d00e0d ("ext4: xattr inode deduplication") # 4.13
cc: Tahsin Erdogan <tahsin@google.com>

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/xattr.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index f36fc5d5b257..dc1aeab06dba 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1031,10 +1031,8 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 	inode_lock(ea_inode);
 
 	ret = ext4_reserve_inode_write(handle, ea_inode, &iloc);
-	if (ret) {
-		iloc.bh = NULL;
+	if (ret)
 		goto out;
-	}
 
 	ref_count = ext4_xattr_inode_get_ref(ea_inode);
 	ref_count += ref_change;
@@ -1080,12 +1078,10 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 	}
 
 	ret = ext4_mark_iloc_dirty(handle, ea_inode, &iloc);
-	iloc.bh = NULL;
 	if (ret)
 		ext4_warning_inode(ea_inode,
 				   "ext4_mark_iloc_dirty() failed ret=%d", ret);
 out:
-	brelse(iloc.bh);
 	inode_unlock(ea_inode);
 	return ret;
 }
-- 
2.17.1
