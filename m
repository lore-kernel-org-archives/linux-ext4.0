From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: 3.8.0-rc1: WARNING: at fs/ext4/page-io.c:232
Date: Thu, 27 Dec 2012 12:04:36 +0400
Message-ID: <87mwwzq5t7.fsf@openvz.org>
References: <CAA1sL1QgkEWciR2qBbKWr+_2tRdhxpE1Jh3P0waSeYR8LR8R5w@mail.gmail.com> <20121227062907.GA5001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o\"" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>,
	Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:57937 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2L0IEo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Dec 2012 03:04:44 -0500
Received: by mail-la0-f48.google.com with SMTP id m13so11654172lah.21
        for <linux-ext4@vger.kernel.org>; Thu, 27 Dec 2012 00:04:42 -0800 (PST)
In-Reply-To: <20121227062907.GA5001@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 27 Dec 2012 14:29:07 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Thu, Dec 27, 2012 at 03:27:04AM +0300, Alexander Beregalov wrote:
> > Hello
> > 
> > Let me know if you need more info
> > 
> > EXT4-fs (sda2): INFO: recovery required on readonly filesystem
> > EXT4-fs (sda2): write access will be enabled during recovery
> > EXT4-fs (sda2): orphan cleanup on readonly fs
> > EXT4-fs (sda2): ext4_orphan_cleanup: truncating inode 841849 to 0 bytes
> > ------------[ cut here ]------------
> > WARNING: at fs/ext4/page-io.c:232 ext4_flush_unwritten_io+0x6b/0x80()
> > Hardware name: P35-DS3
> > Modules linked in:
> > Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc1-00004-g637704c #1
> > Call Trace:
> >  [<ffffffff81038f5a>] warn_slowpath_common+0x7a/0xb0
> >  [<ffffffff81038fa5>] warn_slowpath_null+0x15/0x20
> >  [<ffffffff81163b8b>] ext4_flush_unwritten_io+0x6b/0x80
> >  [<ffffffff8117ac5c>] ext4_ext_truncate+0x2c/0x1f0
> >  [<ffffffff8116c6d0>] ? ext4_msg+0x50/0x60
> >  [<ffffffff8115e050>] ext4_truncate+0x70/0xb0
> >  [<ffffffff8117190b>] ext4_fill_super+0x2bab/0x2ce0
> >  [<ffffffff810ef02a>] mount_bdev+0x1aa/0x1f0
> >  [<ffffffff8102aec9>] ? default_spin_lock_flags+0x9/0x10
> >  [<ffffffff8116ed60>] ? ext4_calculate_overhead+0x3a0/0x3a0
> >  [<ffffffff8116a870>] ext4_mount+0x10/0x20
> >  [<ffffffff810ef96b>] mount_fs+0x1b/0xd0
> >  [<ffffffff81108fc1>] vfs_kern_mount+0x71/0x110
> >  [<ffffffff8110b096>] do_mount+0x386/0x980
> >  [<ffffffff810b7f43>] ? strndup_user+0x53/0x70
> >  [<ffffffff8110b71b>] sys_mount+0x8b/0xe0
> >  [<ffffffff816afcc8>] mount_block_root+0xfe/0x298
> >  [<ffffffff816afeb8>] mount_root+0x56/0x5a
> >  [<ffffffff816afff0>] prepare_namespace+0x134/0x16d
> >  [<ffffffff8147c9c6>] kernel_init+0x196/0x2a0
> >  [<ffffffff816af539>] ? loglevel+0x31/0x31
> >  [<ffffffff8147c830>] ? rest_init+0x80/0x80
> >  [<ffffffff81482a7c>] ret_from_fork+0x7c/0xb0
> >  [<ffffffff8147c830>] ? rest_init+0x80/0x80
> > ---[ end trace 425942f4f0ed8d07 ]---
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 835709
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 835629
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 682715
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 832545
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 677529
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 838885
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 676342
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 832311
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 683216
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 828057
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 847476
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 834769
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 846534
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 842096
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 833886
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 688996
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 1085523
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 524364
> > EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 12686
> > EXT4-fs (sda2): 19 orphan inodes deleted
> > EXT4-fs (sda2): 1 truncate cleaned up
> > EXT4-fs (sda2): recovery complete
> > EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> 
> Hi Alexander,
> 
> This warning is from ext4_flush_unwritten_io() because we need to take
> i_mutex lock before calling this function.  Ohterwise we will trigger a
> WARN_ON_ONCE().  But, unfortunately, we don't take this lock in
> ext4_orphan_cleanup().  So that is why we will get this warning when
> cleaning up orphan list.  Could you please test this patch?
> 
> Thanks,
>                                         - Zheng
> 
> Subject: [PATCH] ext4: fixup a warning from ext4_flush_unwritten_io() in orphan list cleanup
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When ext4 tries to clean up orphan list, we will get the following warning from
> ext4_flush_unwritten_io() because i_mutex lock doesn't be taken.
> 
> EXT4-fs (sda2): INFO: recovery required on readonly filesystem
> EXT4-fs (sda2): write access will be enabled during recovery
> EXT4-fs (sda2): orphan cleanup on readonly fs
> EXT4-fs (sda2): ext4_orphan_cleanup: truncating inode 841849 to 0 bytes
> ------------[ cut here ]------------
> WARNING: at fs/ext4/page-io.c:232 ext4_flush_unwritten_io+0x6b/0x80()
> Hardware name: P35-DS3
> Modules linked in:
> Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc1-00004-g637704c #1
> Call Trace:
>  [<ffffffff81038f5a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff81038fa5>] warn_slowpath_null+0x15/0x20
>  [<ffffffff81163b8b>] ext4_flush_unwritten_io+0x6b/0x80
>  [<ffffffff8117ac5c>] ext4_ext_truncate+0x2c/0x1f0
>  [<ffffffff8116c6d0>] ? ext4_msg+0x50/0x60
>  [<ffffffff8115e050>] ext4_truncate+0x70/0xb0
>  [<ffffffff8117190b>] ext4_fill_super+0x2bab/0x2ce0
>  [<ffffffff810ef02a>] mount_bdev+0x1aa/0x1f0
>  [<ffffffff8102aec9>] ? default_spin_lock_flags+0x9/0x10
>  [<ffffffff8116ed60>] ? ext4_calculate_overhead+0x3a0/0x3a0
>  [<ffffffff8116a870>] ext4_mount+0x10/0x20
>  [<ffffffff810ef96b>] mount_fs+0x1b/0xd0
>  [<ffffffff81108fc1>] vfs_kern_mount+0x71/0x110
>  [<ffffffff8110b096>] do_mount+0x386/0x980
>  [<ffffffff810b7f43>] ? strndup_user+0x53/0x70
>  [<ffffffff8110b71b>] sys_mount+0x8b/0xe0
>  [<ffffffff816afcc8>] mount_block_root+0xfe/0x298
>  [<ffffffff816afeb8>] mount_root+0x56/0x5a
>  [<ffffffff816afff0>] prepare_namespace+0x134/0x16d
>  [<ffffffff8147c9c6>] kernel_init+0x196/0x2a0
>  [<ffffffff816af539>] ? loglevel+0x31/0x31
>  [<ffffffff8147c830>] ? rest_init+0x80/0x80
>  [<ffffffff81482a7c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8147c830>] ? rest_init+0x80/0x80
> ---[ end trace 425942f4f0ed8d07 ]---
> EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 835709
> EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 835629
> 
> Now we try to take i_mutex lock before orphan list cleanup, although we don't
> need to take it in ext4_orphan_cleanup() because no one write this inode.
> WARN_ON_ONCE doesn't be removed because this warning could help us to avoid some
> ciritcal errors.
You can add  Ack-by: Dmitry Monakhov <dmonakhov@openvz.org>

In fact this is my fault that we still not have autotest for that.
I'm think of add crash-test to xfstests which should trigger journal abort and forced
umount. Later test should mount FS which trigger journal_replay and orphan_cleanup.
> 
> CC: Dmitry Monakhov <dmonakhov@openvz.org>
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/super.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3cdb0a2..188d6f1 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2212,7 +2212,18 @@ static void ext4_orphan_cleanup(struct super_block *sb,
>  				__func__, inode->i_ino, inode->i_size);
>  			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
>  				  inode->i_ino, inode->i_size);
> +			/*
> +			 * Actually we don't need to take i_mutex lock
> +			 * because in orphan list cleanup no one can write
> +			 * this inode.  We take it here because in calling
> +			 * ext4_flush_unwritten_io() this lock needs to be
> +			 * taken, and we don't want to remove this
> +			 * WARN_ON_ONCE().  It is useful for us to avoid some
> +			 * critical errors.
> +			 */
> +			mutex_lock(&inode->i_mutex);
>  			ext4_truncate(inode);
> +			mutex_unlock(&inode->i_mutex);
>  			nr_truncates++;
>  		} else {
>  			ext4_msg(sb, KERN_DEBUG,
> -- 
> 1.7.12.rc2.18.g61b472e
> 
