From: Jan Kara <jack@suse.cz>
Subject: Re: Is warn_on() right reply for i/o error?
Date: Tue, 29 Jul 2014 14:04:22 +0200
Message-ID: <20140729120422.GA5944@quack.suse.cz>
References: <20140724152721.GA4771@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, jack@suse.cz
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140724152721.GA4771@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi!

On Thu 24-07-14 17:27:22, Pavel Machek wrote:
> Just... I know, I should not be unscrewing hard drive cover while
> operating.
> 
> But on the other hand... WARN_ON() does not sound like right reply for
> a disk failure... right?
  No, it's not. Looks like a race between someone shutting down BDI and
mark_inode_dirty() running on it. Frankly we play a whack-a-mole with these
races between device removal while fs is operating on it for several years
already. I think we should decouple struct backing_dev_info from struct
request_queue, properly refcount it so that backing_dev_info can die only
after all users of it (fs et al) are done with it. There are too many
references to backing_dev_info from filesystems to remove it in race-free
way while fs still uses it. Now only to find time to do this... ;)

								Honza

> sd 6:0:0:0: [sdf] Unhandled error code
> sd 6:0:0:0: [sdf]  
> Result: hostbyte=0x01 driverbyte=0x00
> sd 6:0:0:0: [sdf] CDB: 
> cdb[0]=0x28: 28 00 00 05 4a 00 00 00 40 00
> end_request: I/O error, dev sdf, sector 346624
> Buffer I/O error on device sdf, logical block 43328
> Buffer I/O error on device sdf, logical block 43329
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 4710 at fs/fs-writeback.c:1199
> __mark_inode_dirty+0x1be/0x1d0()
> bdi-block not registered
> Modules linked in:
> CPU: 0 PID: 4710 Comm: umount Not tainted 3.16.0-rc5+ #381
> Hardware name:                  /DG41MJ, BIOS
> MJG4110H.86A.0006.2009.1223.1155 12/23/2009
>  000004af df661e18 c480956d c4a2bae0 df661e48 c403914a c4a2baf7
>  df661e74
>  00001266 c4a2bae0 000004af c41154fe c41154fe d21ffa74 c6263dec
>  d21ffc60
>  df661e60 c40391ee 00000009 df661e58 c4a2baf7 df661e74 df661e88
>  c41154fe
> Call Trace:
>  [<c480956d>] dump_stack+0x41/0x52
>  [<c403914a>] warn_slowpath_common+0x7a/0xa0
>  [<c41154fe>] ? __mark_inode_dirty+0x1be/0x1d0
>  [<c41154fe>] ? __mark_inode_dirty+0x1be/0x1d0
>  [<c40391ee>] warn_slowpath_fmt+0x2e/0x30
>  [<c41154fe>] __mark_inode_dirty+0x1be/0x1d0
>  [<c411b806>] __set_page_dirty+0x66/0xb0
>  [<c411b8a6>] mark_buffer_dirty+0x56/0x80
>  [<c415bc1d>] ext3_put_super+0x20d/0x250
>  [<c410a042>] ? evict_inodes+0xb2/0x110
>  [<c40f4888>] generic_shutdown_super+0x68/0xe0
>  [<c40f4925>] kill_block_super+0x25/0x70
>  [<c40f4b88>] deactivate_locked_super+0x48/0x70
>  [<c40f5161>] deactivate_super+0x51/0x70
>  [<c410da6f>] mntput_no_expire+0x12f/0x1f0
>  [<c410f1e7>] ? SyS_umount+0xa7/0x430
>  [<c410f1e7>] SyS_umount+0xa7/0x430
>  [<c480e41e>] ? syscall_call+0x7/0xb
>  [<c40df3e1>] ? vm_munmap+0x41/0x50
>  [<c480e41e>] syscall_call+0x7/0xb
> ---[ end trace 6642457659b6f1ae ]---
> EXT3-fs (sdf1): I/O error while writing superblock
> usb 1-1: new high-speed USB device number 8 using ehci-pci
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
