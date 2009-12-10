From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix sleep inside spinlock issue aka #14739 V2
Date: Thu, 10 Dec 2009 20:22:16 +0300
Message-ID: <87bpi6zquv.fsf_-_@openvz.org>
References: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
 <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:37000 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761018AbZLJRWo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2009 12:22:44 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KUG00AB45SUAS10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Thu, 10 Dec 2009 20:26:58 +0300 (MSK)
In-reply-to: <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


drop i_block_reservation_lock before vfs_dq_reserve_block().
this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=14739

changes from previous version:
 - simplify the patch according to Jan's comments

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 942e183..2327f7a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1851,6 +1851,7 @@ repeat:
 
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
 	 * Make quota reservation here to prevent quota overflow
@@ -1858,12 +1859,10 @@ repeat:
 	 * time.
 	 */
 	if (vfs_dq_reserve_block(inode, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		return -EDQUOT;
 	}
 
 	if (ext4_claim_free_blocks(sbi, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
@@ -1871,10 +1870,11 @@ repeat:
 		}
 		return -ENOSPC;
 	}
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
 	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
