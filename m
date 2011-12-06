From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/6 V2] ext4: fix up error handling for insert_inode_locked
Date: Tue, 06 Dec 2011 17:19:39 -0600
Message-ID: <4EDEA30B.8000300@redhat.com>
References: <4EDE9D54.1030506@redhat.com> <4EDE9F21.30405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab1LFXTl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Dec 2011 18:19:41 -0500
In-Reply-To: <4EDE9F21.30405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

after 250df6ed274d767da844a5d9f05720b804240197
(fs: protect inode->i_state with inode->i_lock), insert_inode_locked()
no longer returns the inode with I_NEW set on failure.  However,
the error handler still calls unlock_new_inode() on failure,
which does a WARN_ON if I_NEW is not set, so any failure spews
a lot of warnings.

(We also were doing dquot_drop, etc before we had initialized
the quota, that gets skipped as well)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: don't rearrange clear_nlink, and edit commit message.

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 00beb4f..1e0c3bf 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -886,7 +886,7 @@ got:
 		ext4_handle_sync(handle);
 	if (insert_inode_locked(inode) < 0) {
 		err = -EINVAL;
-		goto fail_drop;
+		goto fail_put;
 	}
 	spin_lock(&sbi->s_next_gen_lock);
 	inode->i_generation = sbi->s_next_generation++;
@@ -950,6 +950,7 @@ fail_drop:
 	inode->i_flags |= S_NOQUOTA;
 	clear_nlink(inode);
 	unlock_new_inode(inode);
+fail_put:
 	iput(inode);
 	brelse(inode_bitmap_bh);
 	return ERR_PTR(err);
