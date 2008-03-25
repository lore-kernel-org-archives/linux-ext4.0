From: Jan Kara <jack@suse.cz>
Subject: Re: ext3 lockdep warning in 2.6.25-rc6
Date: Tue, 25 Mar 2008 19:29:09 +0100
Message-ID: <20080325182909.GD21732@atrey.karlin.mff.cuni.cz>
References: <200803221437.m2MEbO5H003869@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Erez Zadok <ezk@cs.sunysb.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43015 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYCYS3L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2008 14:29:11 -0400
Content-Disposition: inline
In-Reply-To: <200803221437.m2MEbO5H003869@agora.fsl.cs.sunysb.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> I was building a kernel using "make -j 4" inside a unionfs, mounted on top
> of ext3.  The kernel is vanilla 2.6.25-rc6 plus unionfs patches.  At some
> point I forced a cache flush using "echo 3 > /proc/sys/vm/drop_caches" and I
> got the lockdep warning below.  Note that unionfs doesn't appear to be
> involved in this lockdep warning at all, so I suspect this is probably an
> issue between jbd and ext3 directly.
> 
> Let me know if I can be of more help.
  Actually, I have a fix for that - attached. Can you try it? Thanks.
									Honza

> [31270.749254] =======================================================
> [31270.749473] [ INFO: possible circular locking dependency detected ]
> [31270.749720] 2.6.25-rc6-unionfs2 #69
> [31270.749831] -------------------------------------------------------
> [31270.749958] flush-caches.sh/9702 is trying to acquire lock:
> [31270.750171]  (&journal->j_list_lock){--..}, at: [<c029ef6a>] journal_try_to_free_buffers+0xa5/0x158
> [31270.751607] 
> [31270.751607] but task is already holding lock:
> [31270.751607]  (inode_lock){--..}, at: [<c02718bb>] drop_pagecache+0x45/0xd3
> [31270.751607] 
> [31270.751607] which lock already depends on the new lock.
> [31270.751607] 
> [31270.751607] 
> [31270.751607] the existing dependency chain (in reverse order) is:
> [31270.751607] 
> [31270.751607] -> #1 (inode_lock){--..}:
> [31270.751607]        [<c0231e01>] __lock_acquire+0x934/0xab8
> [31270.751607]        [<c0232307>] lock_acquire+0x4e/0x6a
> [31270.751607]        [<c0395e33>] _spin_lock+0x23/0x32
> [31270.751607]        [<c02713d2>] __mark_inode_dirty+0xbe/0x134
> [31270.751607]        [<c0274b3a>] __set_page_dirty+0xdd/0xec
> [31270.751607]        [<c0274ba9>] mark_buffer_dirty+0x60/0x63
> [31270.751607]        [<c029d2f6>] __journal_temp_unlink_buffer+0xc9/0xce
> [31270.751607]        [<c029d43b>] __journal_unfile_buffer+0xb/0x15
> [31270.751607]        [<c029d487>] __journal_refile_buffer+0x42/0x8c
> [31270.751607]        [<c029fdd1>] journal_commit_transaction+0xc59/0xe64
> [31270.751607]        [<c02a29f1>] kjournald+0xae/0x1b0
> [31270.751607]        [<c0228833>] kthread+0x3b/0x64
> [31270.751607]        [<c02039d3>] kernel_thread_helper+0x7/0x10
> [31270.751607]        [<ffffffff>] 0xffffffff
> [31270.751607] 
> [31270.751607] -> #0 (&journal->j_list_lock){--..}:
> [31270.751607]        [<c0231d28>] __lock_acquire+0x85b/0xab8
> [31270.751607]        [<c0232307>] lock_acquire+0x4e/0x6a
> [31270.751607]        [<c0395e33>] _spin_lock+0x23/0x32
> [31270.751607]        [<c029ef6a>] journal_try_to_free_buffers+0xa5/0x158
> [31270.751607]        [<c02925fe>] ext3_releasepage+0x53/0x5c
> [31270.751607]        [<c023e4bd>] try_to_release_page+0x32/0x3f
> [31270.751607]        [<c0243f59>] __invalidate_mapping_pages+0x69/0xc6
> [31270.751607]        [<c02718de>] drop_pagecache+0x68/0xd3
> [31270.751607]        [<c0271972>] drop_caches_sysctl_handler+0x29/0x3f
> [31270.751607]        [<c0289383>] proc_sys_write+0x61/0x7e
> [31270.751607]        [<c02594a1>] vfs_write+0x8c/0x108
> [31270.751607]        [<c0259a2b>] sys_write+0x3b/0x60
> [31270.751607]        [<c0202cee>] sysenter_past_esp+0x5f/0xa5
> [31270.751607]        [<ffffffff>] 0xffffffff
> [31270.751607] 
> [31270.751607] other info that might help us debug this:
> [31270.751607] 
> [31270.751607] 2 locks held by flush-caches.sh/9702:
> [31270.751607]  #0:  (&type->s_umount_key#12){----}, at: [<c02718ab>] drop_pagecache+0x35/0xd3
> [31270.751607]  #1:  (inode_lock){--..}, at: [<c02718bb>] drop_pagecache+0x45/0xd3
> [31270.751608] 
> [31270.751608] stack backtrace:
> [31270.751608] Pid: 9702, comm: flush-caches.sh Not tainted 2.6.25-rc6-unionfs2 #69
> [31270.751608]  [<c0230687>] print_circular_bug_tail+0x5b/0x66
> [31270.751608]  [<c0231d28>] __lock_acquire+0x85b/0xab8
> [31270.751608]  [<c0232307>] lock_acquire+0x4e/0x6a
> [31270.751608]  [<c029ef6a>] ? journal_try_to_free_buffers+0xa5/0x158
> [31270.751608]  [<c0395e33>] _spin_lock+0x23/0x32
> [31270.751608]  [<c029ef6a>] ? journal_try_to_free_buffers+0xa5/0x158
> [31270.751608]  [<c029ef6a>] journal_try_to_free_buffers+0xa5/0x158
> [31270.751608]  [<c02925fe>] ext3_releasepage+0x53/0x5c
> [31270.751608]  [<c023e4bd>] try_to_release_page+0x32/0x3f
> [31270.751608]  [<c0243f59>] __invalidate_mapping_pages+0x69/0xc6
> [31270.751608]  [<c02718de>] drop_pagecache+0x68/0xd3
> [31270.751608]  [<c0271972>] drop_caches_sysctl_handler+0x29/0x3f
> [31270.751608]  [<c0289383>] proc_sys_write+0x61/0x7e
> [31270.751608]  [<c0289322>] ? proc_sys_write+0x0/0x7e
> [31270.751608]  [<c02594a1>] vfs_write+0x8c/0x108
> [31270.751608]  [<c0259a2b>] sys_write+0x3b/0x60
> [31270.751608]  [<c0202cee>] sysenter_past_esp+0x5f/0xa5
> [31270.751608]  =======================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--sdtB3X0nJg68CQEu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="vfs-2.6.25-drop_pagecache_sb_fix.diff"

>From f5e41087e345fa5c3b46ac36e6e4a654d2f7f624 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 18 Mar 2008 14:38:06 +0100
Subject: [PATCH] Fix drop_pagecache_sb() to not call __invalidate_mapping_pages() under
inode_lock.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/drop_caches.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 59375ef..f5aae26 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -14,15 +14,21 @@ int sysctl_drop_caches;
 
 static void drop_pagecache_sb(struct super_block *sb)
 {
-	struct inode *inode;
+	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE))
 			continue;
+		__iget(inode);
+		spin_unlock(&inode_lock);
 		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
+		iput(toput_inode);
+		toput_inode = inode;
+		spin_lock(&inode_lock);
 	}
 	spin_unlock(&inode_lock);
+	iput(toput_inode);
 }
 
 void drop_pagecache(void)
-- 
1.5.2.4


--sdtB3X0nJg68CQEu--
