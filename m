From: Jan Kara <jack@suse.cz>
Subject: Re: mmotm 2009-07-16-14-32 - lockdep whinge in ext3/quota code
Date: Wed, 22 Jul 2009 18:19:23 +0200
Message-ID: <20090722161923.GD19072@duck.suse.cz>
References: <200907162134.n6GLY2kt019816@imap1.linux-foundation.org> <15072.1248268669@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="l76fUT7nc3MelDdI"
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Stephen Tweedie <sct@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51699 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbZGVQT1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2009 12:19:27 -0400
Content-Disposition: inline
In-Reply-To: <15072.1248268669@turing-police.cc.vt.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 22-07-09 09:17:49, Valdis.Kletnieks@vt.edu wrote:
> Saw this while bisecting to find another issue.
> 
> quilt top:
> memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
> 
> Some checking doesn't look like any of the 58 patches after that are
> relevant (only the reiser4 patch references quotas, no grep hits for lockdep
> or ext3).
> 
> About 30 seconds after boot:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.31-rc3 #2
> -------------------------------------------------------
> rm/1562 is trying to acquire lock:
>  (&sb->s_type->i_mutex_key#11/4){+.+...}, at: [<ffffffff81139fd9>] ext3_quota_write+0xb5/0x274
> 
> but task is already holding lock:
>  (&s->s_dquot.dqio_mutex){+.+...}, at: [<ffffffff811153d5>] dquot_commit+0x26/0xee
> 
> which lock already depends on the new lock.
> 
  Grumble... Commit d01730d74d2b0155da50d44555001706294014f7 didn't quite
fix the problem. At least lockdep now warns about it ;). Attached patch
should fix it (compile tested only so far).

> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&s->s_dquot.dqio_mutex){+.+...}:
>        [<ffffffff81067010>] __lock_acquire+0xa1b/0xb97
>        [<ffffffff81067278>] lock_acquire+0xec/0x110
>        [<ffffffff814a04af>] __mutex_lock_common+0x5a/0x54e
>        [<ffffffff814a0a43>] mutex_lock_nested+0x32/0x37
>        [<ffffffff81115b54>] vfs_load_quota_inode+0x264/0x496
>        [<ffffffff81116094>] vfs_quota_on_path+0x4c/0x55
>        [<ffffffff81138e9d>] ext3_quota_on+0x14c/0x167
>        [<ffffffff81119e4f>] do_quotactl+0xf4/0x44c
>        [<ffffffff8111a491>] sys_quotactl+0x2ea/0x30e
>        [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #0 (&sb->s_type->i_mutex_key#11/4){+.+...}:
>        [<ffffffff81066eed>] __lock_acquire+0x8f8/0xb97
>        [<ffffffff81067278>] lock_acquire+0xec/0x110
>        [<ffffffff814a04af>] __mutex_lock_common+0x5a/0x54e
>        [<ffffffff814a0a43>] mutex_lock_nested+0x32/0x37
>        [<ffffffff81139fd9>] ext3_quota_write+0xb5/0x274
>        [<ffffffff81119bd3>] qtree_write_dquot+0xce/0x127
>        [<ffffffff81118924>] v2_write_dquot+0x27/0x29
>        [<ffffffff8111544c>] dquot_commit+0x9d/0xee
>        [<ffffffff8113a8ae>] ext3_write_dquot+0x69/0x8a
>        [<ffffffff8111713f>] dqput+0x138/0x25c
>        [<ffffffff81117993>] dquot_drop+0x6a/0x74
>        [<ffffffff8111509f>] vfs_dq_drop+0x41/0x43
>        [<ffffffff81130cba>] ext3_free_inode+0x96/0x28c
>        [<ffffffff81134cce>] ext3_delete_inode+0xbf/0xdd
>        [<ffffffff810e357d>] generic_delete_inode+0x135/0x1db
>        [<ffffffff810e363a>] generic_drop_inode+0x17/0x56
>        [<ffffffff810e252d>] iput+0x7a/0x7f
>        [<ffffffff810db906>] do_unlinkat+0x123/0x176
>        [<ffffffff810dbab8>] sys_unlinkat+0x24/0x26
>        [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> other info that might help us debug this:
> 
> 2 locks held by rm/1562:
>  #0:  (jbd_handle){+.+...}, at: [<ffffffff811433c9>] journal_start+0x10a/0x137
>  #1:  (&s->s_dquot.dqio_mutex){+.+...}, at: [<ffffffff811153d5>] dquot_commit+0x26/0xee
> 
> stack backtrace:
> Pid: 1562, comm: rm Not tainted 2.6.31-rc3 #2
> Call Trace:
>  [<ffffffff81066290>] print_circular_bug_tail+0x71/0x7c
>  [<ffffffff81066eed>] __lock_acquire+0x8f8/0xb97
>  [<ffffffff81139fd9>] ? ext3_quota_write+0xb5/0x274
>  [<ffffffff81067278>] lock_acquire+0xec/0x110
>  [<ffffffff81139fd9>] ? ext3_quota_write+0xb5/0x274
>  [<ffffffff814a04af>] __mutex_lock_common+0x5a/0x54e
>  [<ffffffff81139fd9>] ? ext3_quota_write+0xb5/0x274
>  [<ffffffff810665e4>] ? check_irq_usage+0xad/0xbe
>  [<ffffffff81139fd9>] ? ext3_quota_write+0xb5/0x274
>  [<ffffffff810670e2>] ? __lock_acquire+0xaed/0xb97
>  [<ffffffff814a0a43>] mutex_lock_nested+0x32/0x37
>  [<ffffffff81139fd9>] ext3_quota_write+0xb5/0x274
>  [<ffffffff81119bd3>] qtree_write_dquot+0xce/0x127
>  [<ffffffff81034c90>] ? get_parent_ip+0x11/0x42
>  [<ffffffff81118924>] v2_write_dquot+0x27/0x29
>  [<ffffffff8111544c>] dquot_commit+0x9d/0xee
>  [<ffffffff8113a8ae>] ext3_write_dquot+0x69/0x8a
>  [<ffffffff8111713f>] dqput+0x138/0x25c
>  [<ffffffff81117993>] dquot_drop+0x6a/0x74
>  [<ffffffff8111509f>] vfs_dq_drop+0x41/0x43
>  [<ffffffff81130cba>] ext3_free_inode+0x96/0x28c
>  [<ffffffff81131d63>] ? ext3_mark_inode_dirty+0x48/0x53
>  [<ffffffff81134cce>] ext3_delete_inode+0xbf/0xdd
>  [<ffffffff81134c0f>] ? ext3_delete_inode+0x0/0xdd
>  [<ffffffff810e357d>] generic_delete_inode+0x135/0x1db
>  [<ffffffff810e363a>] generic_drop_inode+0x17/0x56
>  [<ffffffff810e252d>] iput+0x7a/0x7f
>  [<ffffffff810db906>] do_unlinkat+0x123/0x176
>  [<ffffffff8107d440>] ? audit_syscall_entry+0x170/0x19c
>  [<ffffffff810dbab8>] sys_unlinkat+0x24/0x26
>  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--l76fUT7nc3MelDdI
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-quota-Silence-lockdep-on-quota_on.patch"

>From df60fe9a9d554070e6135087e154bd5aad2cc1b5 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Jul 2009 18:12:17 +0200
Subject: [PATCH] quota: Silence lockdep on quota_on

Commit d01730d74d2b0155da50d44555001706294014f7 didn't completely fix
the problem since we still take dqio_mutex and i_mutex in the wrong
order. Move taking of i_mutex further down (luckily it's needed only
for updating inode flags) below where dqio_mutex is taken.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 70f36c0..38f7bd5 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2043,7 +2043,6 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		invalidate_bdev(sb->s_bdev);
 	}
 	mutex_lock(&dqopt->dqonoff_mutex);
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	if (sb_has_quota_loaded(sb, type)) {
 		error = -EBUSY;
 		goto out_lock;
@@ -2054,9 +2053,11 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		 * possible) Also nobody should write to the file - we use
 		 * special IO operations which ignore the immutable bit. */
 		down_write(&dqopt->dqptr_sem);
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 		oldflags = inode->i_flags & (S_NOATIME | S_IMMUTABLE |
 					     S_NOQUOTA);
 		inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
+		mutex_unlock(&inode->i_mutex);
 		up_write(&dqopt->dqptr_sem);
 		sb->dq_op->drop(inode);
 	}
@@ -2080,7 +2081,6 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		goto out_file_init;
 	}
 	mutex_unlock(&dqopt->dqio_mutex);
-	mutex_unlock(&inode->i_mutex);
 	spin_lock(&dq_state_lock);
 	dqopt->flags |= dquot_state_flag(flags, type);
 	spin_unlock(&dq_state_lock);
@@ -2096,13 +2096,14 @@ out_file_init:
 out_lock:
 	if (oldflags != -1) {
 		down_write(&dqopt->dqptr_sem);
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 		/* Set the flags back (in the case of accidental quotaon()
 		 * on a wrong file we don't want to mess up the flags) */
 		inode->i_flags &= ~(S_NOATIME | S_NOQUOTA | S_IMMUTABLE);
 		inode->i_flags |= oldflags;
+		mutex_unlock(&inode->i_mutex);
 		up_write(&dqopt->dqptr_sem);
 	}
-	mutex_unlock(&inode->i_mutex);
 	mutex_unlock(&dqopt->dqonoff_mutex);
 out_fmt:
 	put_quota_format(fmt);
-- 
1.6.0.2


--l76fUT7nc3MelDdI--
