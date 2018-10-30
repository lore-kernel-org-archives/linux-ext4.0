Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:46002 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725743AbeJaGxx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 Oct 2018 02:53:53 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v2 09/11] ext4: iloc.bh cleanup in add_new_gdb()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <cover.1540935522.git.vvs@virtuozzo.com>
Message-ID: <eb58c8ca-8456-7b5f-9c12-99f03e3057af@virtuozzo.com>
Date: Wed, 31 Oct 2018 00:58:38 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1540935522.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

iloc.bh was taken in ext4_reserve_inode_write() and released
in ext4_mark_iloc_dirty(). It should not be released 2nd time
in rollback after failed ext4_handle_dirty_metadata(gdb_bh)

Fixes b40971426a83 ("ext4: add error checking to calls to ...") # 2.6.38

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/resize.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 85158e9de7c2..aedfd6a6fcd1 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -871,7 +871,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
 	if (unlikely(err)) {
 		ext4_std_error(sb, err);
-		goto exit_inode;
+		goto exit_kfree;
 	}
 	brelse(dind);
 
@@ -891,8 +891,9 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	return err;
 
 exit_inode:
-	kvfree(n_group_desc);
 	brelse(iloc.bh);
+exit_kfree:
+	kvfree(n_group_desc);
 exit_dind:
 	brelse(dind);
 exit_bh:
-- 
2.17.1
