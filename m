From: Jan Kara <jack@suse.cz>
Subject: Re: warning in ext4_journal_start_sb on filesystem freeze
Date: Tue, 26 Nov 2013 13:58:26 +0100
Message-ID: <20131126125826.GA4503@quack.suse.cz>
References: <217983071.143460.1385453196946.JavaMail.zimbra@rapitasystems.com>
 <1697998867.143517.1385454051031.JavaMail.zimbra@rapitasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Matthew Rahtz <mrahtz@rapitasystems.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab3KZM63 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Nov 2013 07:58:29 -0500
Content-Disposition: inline
In-Reply-To: <1697998867.143517.1385454051031.JavaMail.zimbra@rapitasystems.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Tue 26-11-13 08:20:51, Matthew Rahtz wrote:
> We're using qemu's guest agent daemon, qemu-ga, to freeze ext4
> filesystems in guest virtual machines before taking an LVM snapshot of
> the disk volume in the host. However, in the guests' dmesg, we're
> consistently seeing warnings like: 
> 
> [1246478.632936] WARNING: at /build/buildd/linux-lts-raring-3.8.0/fs/ext4/super.c:339 ext4_journal_start_sb+0x159/0x160() 
> 
> Looking at the source at
> https://github.com/torvalds/linux/blob/v3.8/fs/ext4/super.c#L339, this
> warning seems to be generated if the function is reached despite the
> filesystem being marked as frozen:
> 
> WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
> 
> In 3.12, this has been moved to
> https://github.com/torvalds/linux/blob/v3.12/fs/ext4/ext4_jbd2.c#L48.
> 
> Is this something we should be concerned about? The process that seems to
> be responsible for triggering it is mysqld, so we're concerned the
> databases in our snapshots have a higher possibility of being corrupt.
> (Taking online snapshots of databases like this is always risky, of
> course, but this just makes us a little more nervous :) ) Full kernel
> warning is attached below.
  Yes, it's a bug in 3.8 kernel which got fixed by commit
03d95eb2f2578083a3f6286262e1cb5d88a00c02 (merged in 3.10). Looking into the
code there's really a chance the filesystem will be inconsistent because of
that bug so you might be better off updating to a kernel which has this bug
fixed if you rely on the snapshots heavily.

								Honza

> [1246478.632930] ------------[ cut here ]------------
> [1246478.632936] WARNING: at /build/buildd/linux-lts-raring-3.8.0/fs/ext4/super.c:339 ext4_journal_start_sb+0x159/0x160()
> [1246478.632938] Hardware name: Bochs
> [1246478.632939] Modules linked in: cirrus(F) ttm(F) drm_kms_helper(F) drm(F) sysimgblt(F) psmouse(F) sysfillrect(F) serio_raw(F) syscopyarea(F) microcode(F) virtio_console(F) lp(F) virtio_balloon(F) mac_hid(F) i2c_piix4(F) ext2(F) parport(F) floppy(F) e1000(F)
> [1246478.632973] Pid: 2856, comm: mysqld Tainted: GF       W    3.8.0-33-generic #48~precise1-Ubuntu
> [1246478.632975] Call Trace:
> [1246478.632981]  [<ffffffff81059b6f>] warn_slowpath_common+0x7f/0xc0
> [1246478.632985]  [<ffffffff81059bca>] warn_slowpath_null+0x1a/0x20
> [1246478.632989]  [<ffffffff8125eb59>] ext4_journal_start_sb+0x159/0x160
> [1246478.632993]  [<ffffffff8123f1c8>] ? _ext4_get_block+0x138/0x170
> [1246478.632997]  [<ffffffff8123f1c8>] _ext4_get_block+0x138/0x170
> [1246478.633002]  [<ffffffff8104e070>] ? get_user_pages_fast+0xe0/0x1a0
> [1246478.633006]  [<ffffffff8123f263>] ext4_get_block_write+0x13/0x20
> [1246478.633009]  [<ffffffff811d6d3a>] get_more_blocks+0x6a/0xa0
> [1246478.633013]  [<ffffffff811d7a7e>] do_direct_IO+0x4be/0x1530
> [1246478.633018]  [<ffffffff8107f9ab>] ? bit_waitqueue+0x1b/0xc0
> [1246478.633022]  [<ffffffff81186221>] ? kmem_cache_alloc+0x31/0x140
> [1246478.633026]  [<ffffffff811d8f22>] do_blockdev_direct_IO+0x432/0x13e0
> [1246478.633030]  [<ffffffff8123f250>] ? noalloc_get_block_write+0x30/0x30
> [1246478.633035]  [<ffffffff811d9f25>] __blockdev_direct_IO+0x55/0x60
> [1246478.633039]  [<ffffffff8123f250>] ? noalloc_get_block_write+0x30/0x30
> [1246478.633042]  [<ffffffff8123ab30>] ? ext4_journalled_invalidatepage+0x30/0x30
> [1246478.633046]  [<ffffffff8123bcd0>] ext4_ext_direct_IO+0x130/0x250
> [1246478.633050]  [<ffffffff8123f250>] ? noalloc_get_block_write+0x30/0x30
> [1246478.633053]  [<ffffffff8123ab30>] ? ext4_journalled_invalidatepage+0x30/0x30
> [1246478.633057]  [<ffffffff8123c1ad>] ext4_direct_IO+0x1ad/0x230
> [1246478.633061]  [<ffffffff8108e3ca>] ? finish_task_switch+0x4a/0xf0
> [1246478.633065]  [<ffffffff811368d6>] generic_file_direct_write+0xc6/0x180
> [1246478.633068]  [<ffffffff81136c6d>] __generic_file_aio_write+0x2dd/0x3b0
> [1246478.633072]  [<ffffffff816e5848>] ext4_file_dio_write+0x243/0x320
> [1246478.633076]  [<ffffffff810b81b2>] ? unqueue_me+0x52/0x80
> [1246478.633079]  [<ffffffff81236ed8>] ext4_file_write+0xc8/0xe0
> [1246478.633084]  [<ffffffff8119b333>] do_sync_write+0xa3/0xe0
> [1246478.633089]  [<ffffffff8119b9d3>] vfs_write+0xb3/0x180
> [1246478.633093]  [<ffffffff8119be9a>] sys_pwrite64+0x9a/0xa0
> [1246478.633097]  [<ffffffff816fd15d>] system_call_fastpath+0x1a/0x1f
> [1246478.633099] ---[ end trace f37019187d44de90 ]---
> Please Note: Rapita Systems has a new address and telephone number.
> Telephone: +44 1904 413945
> Address: Rapita Systems Ltd, Atlas House,
>           Osbaldwick Link Road, YORK, YO10 3JB
>           United Kingdom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
