From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/6 v2] ext2: fix up error handling for insert_inode_locked
Date: Tue, 06 Dec 2011 17:18:27 -0600
Message-ID: <4EDEA2C3.60200@redhat.com>
References: <4EDE9D54.1030506@redhat.com> <4EDE9DDF.2040906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1LFXS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Dec 2011 18:18:28 -0500
In-Reply-To: <4EDE9DDF.2040906@redhat.com>
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

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index c4e81df..06cbc22 100644
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
@@ -603,6 +603,7 @@ fail_drop:
 	inode->i_flags |= S_NOQUOTA;
 	clear_nlink(inode);
 	unlock_new_inode(inode);
+fail_put:
 	iput(inode);
 	return ERR_PTR(err);
 
