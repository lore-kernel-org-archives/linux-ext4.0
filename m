From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/6] ext3: fix up error handling for insert_inode_locked
Date: Tue, 06 Dec 2011 16:59:08 -0600
Message-ID: <4EDE9E3C.5040406@redhat.com>
References: <4EDE9D54.1030506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EDE9D54.1030506@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

after 250df6ed274d767da844a5d9f05720b804240197
(fs: protect inode->i_state with inode->i_lock), insert_inode_locked()
no longer returns the inode with I_NEW set.  However, the error
handler still calls unlock_new_inode() on failure, which does a
WARN_ON if I_NEW is not set, so any failure spews a lot of
warnings.

(We also were doing dquot_drop, etc before we had initialized
the quota, that gets skipped as well)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 5c866e0..7d0493b 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -526,7 +526,7 @@ got:
 		handle->h_sync = 1;
 	if (insert_inode_locked(inode) < 0) {
 		err = -EINVAL;
-		goto fail_drop;
+		goto fail_put;
 	}
 	spin_lock(&sbi->s_next_gen_lock);
 	inode->i_generation = sbi->s_next_generation++;
@@ -582,8 +582,9 @@ fail_free_drop:
 fail_drop:
 	dquot_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
-	clear_nlink(inode);
 	unlock_new_inode(inode);
+fail_put:
+	clear_nlink(inode);
 	iput(inode);
 	brelse(bitmap_bh);
 	return ERR_PTR(err);
