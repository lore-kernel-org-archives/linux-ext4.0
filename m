From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT
Date: Thu, 2 Oct 2014 13:40:51 +0200
Message-ID: <20141002114051.GF19748@quack.suse.cz>
References: <1412236202-17178-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaJBLkx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Oct 2014 07:40:53 -0400
Content-Disposition: inline
In-Reply-To: <1412236202-17178-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 02-10-14 11:50:02, Dmitry Monakhov wrote:
> Otherwise this provokes complain like follows:
> WARNING: CPU: 12 PID: 5795 at fs/ext4/ext4_jbd2.c:48 ext4_journal_check_start+0x4e/0xa0()
> Modules linked in: brd iTCO_wdt lpc_ich mfd_core igb ptp dm_mirror dm_region_hash dm_log dm_mod
> CPU: 12 PID: 5795 Comm: python Not tainted 3.17.0-rc2-00175-gae5344f #158
> Hardware name: Intel Corporation W2600CR/W2600CR, BIOS SE5C600.86B.99.99.x028.061320111235 06/13/2011
>  0000000000000030 ffff8808116cfd28 ffffffff815c7dfc 0000000000000030
>  0000000000000000 ffff8808116cfd68 ffffffff8106ce8c ffff8808116cfdc8
>  ffff880813b16000 ffff880806ad6ae8 ffffffff81202008 0000000000000000
> Call Trace:
>  [<ffffffff815c7dfc>] dump_stack+0x51/0x6d
>  [<ffffffff8106ce8c>] warn_slowpath_common+0x8c/0xc0
>  [<ffffffff81202008>] ? ext4_ioctl+0x9e8/0xeb0
>  [<ffffffff8106ceda>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8122867e>] ext4_journal_check_start+0x4e/0xa0
>  [<ffffffff81228c10>] __ext4_journal_start_sb+0x90/0x110
>  [<ffffffff81202008>] ext4_ioctl+0x9e8/0xeb0
>  [<ffffffff8107b0bd>] ? ptrace_stop+0x24d/0x2f0
>  [<ffffffff81088530>] ? alloc_pid+0x480/0x480
>  [<ffffffff8107b1f2>] ? ptrace_do_notify+0x92/0xb0
>  [<ffffffff81186545>] do_vfs_ioctl+0x4e5/0x550
>  [<ffffffff815cdbcb>] ? _raw_spin_unlock_irq+0x2b/0x40
>  [<ffffffff81186603>] SyS_ioctl+0x53/0x80
>  [<ffffffff815ce2ce>] tracesys+0xd0/0xd5
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Ah, good spotting. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

							Honza

> ---
>  fs/ext4/ioctl.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0f2252e..3d5de16 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -532,9 +532,17 @@ group_add_out:
>  	}
>  
>  	case EXT4_IOC_SWAP_BOOT:
> +	{
> +		int err;
>  		if (!(filp->f_mode & FMODE_WRITE))
>  			return -EBADF;
> -		return swap_inode_boot_loader(sb, inode);
> +		err = mnt_want_write_file(filp);
> +		if (err)
> +			return err;
> +		err = swap_inode_boot_loader(sb, inode);
> +		mnt_drop_write_file(filp);
> +		return err;
> +	}
>  
>  	case EXT4_IOC_RESIZE_FS: {
>  		ext4_fsblk_t n_blocks_count;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
