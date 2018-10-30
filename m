Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:45988 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725743AbeJaGxi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 Oct 2018 02:53:38 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 07/11] ext4: lost put_bh in ext4_mark_iloc_dirty()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1540935522.git.vvs@virtuozzo.com>
Message-ID: <61d28461-8fdd-d614-8bde-844703936ac1@virtuozzo.com>
Date: Wed, 31 Oct 2018 00:58:24 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1540935522.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_mark_iloc_dirty() callers expect that it releases iloc->bh
even if it returns an error.

Fixes 0db1ff222d40 ("ext4: add shutdown bit and check for it") # 4.11

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c3d9a42c561e..55c8fca76daf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5835,9 +5835,10 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 {
 	int err = 0;
 
-	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb)))) {
+		put_bh(iloc->bh);
 		return -EIO;
-
+	}
 	if (IS_I_VERSION(inode))
 		inode_inc_iversion(inode);
 
-- 
2.17.1
