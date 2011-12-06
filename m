From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/6] ext2: fix up error handling for insert_inode_locked
Date: Tue, 06 Dec 2011 16:57:35 -0600
Message-ID: <4EDE9DDF.2040906@redhat.com>
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
the inode, that gets skipped as well)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index c4e81df..769351a 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -574,7 +574,7 @@ got:
 	spin_unlock(&sbi->s_next_gen_lock);
 	if (insert_inode_locked(inode) < 0) {
 		err = -EINVAL;
-		goto fail_drop;
+		goto fail_put;
 	}
 
 	dquot_initialize(inode);
@@ -601,8 +601,9 @@ fail_free_drop:
 fail_drop:
 	dquot_drop(inode);
 	inode->i_flags |= S_NOQUOTA;
-	clear_nlink(inode);
 	unlock_new_inode(inode);
+fail_put:
+	clear_nlink(inode);
 	iput(inode);
 	return ERR_PTR(err);
 
