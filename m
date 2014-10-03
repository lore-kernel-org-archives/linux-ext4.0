From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT
Date: Fri, 3 Oct 2014 12:50:30 -0400
Message-ID: <20141003165030.GD24109@thunk.org>
References: <1412236202-17178-1-git-send-email-dmonakhov@openvz.org>
 <20141002114051.GF19748@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34699 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbaJCQui (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Oct 2014 12:50:38 -0400
Content-Disposition: inline
In-Reply-To: <20141002114051.GF19748@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 02, 2014 at 01:40:51PM +0200, Jan Kara wrote:
> On Thu 02-10-14 11:50:02, Dmitry Monakhov wrote:
> > Otherwise this provokes complain like follows:
> > WARNING: CPU: 12 PID: 5795 at fs/ext4/ext4_jbd2.c:48 ext4_journal_check_start+0x4e/0xa0()
> > Modules linked in: brd iTCO_wdt lpc_ich mfd_core igb ptp dm_mirror dm_region_hash dm_log dm_mod
> > CPU: 12 PID: 5795 Comm: python Not tainted 3.17.0-rc2-00175-gae5344f #158
> > Hardware name: Intel Corporation W2600CR/W2600CR, BIOS SE5C600.86B.99.99.x028.061320111235 06/13/2011
> >  0000000000000030 ffff8808116cfd28 ffffffff815c7dfc 0000000000000030
> >  0000000000000000 ffff8808116cfd68 ffffffff8106ce8c ffff8808116cfdc8
> >  ffff880813b16000 ffff880806ad6ae8 ffffffff81202008 0000000000000000
> > Call Trace:
> >  [<ffffffff815c7dfc>] dump_stack+0x51/0x6d
> >  [<ffffffff8106ce8c>] warn_slowpath_common+0x8c/0xc0
> >  [<ffffffff81202008>] ? ext4_ioctl+0x9e8/0xeb0
> >  [<ffffffff8106ceda>] warn_slowpath_null+0x1a/0x20
> >  [<ffffffff8122867e>] ext4_journal_check_start+0x4e/0xa0
> >  [<ffffffff81228c10>] __ext4_journal_start_sb+0x90/0x110
> >  [<ffffffff81202008>] ext4_ioctl+0x9e8/0xeb0
> >  [<ffffffff8107b0bd>] ? ptrace_stop+0x24d/0x2f0
> >  [<ffffffff81088530>] ? alloc_pid+0x480/0x480
> >  [<ffffffff8107b1f2>] ? ptrace_do_notify+0x92/0xb0
> >  [<ffffffff81186545>] do_vfs_ioctl+0x4e5/0x550
> >  [<ffffffff815cdbcb>] ? _raw_spin_unlock_irq+0x2b/0x40
> >  [<ffffffff81186603>] SyS_ioctl+0x53/0x80
> >  [<ffffffff815ce2ce>] tracesys+0xd0/0xd5
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>   Ah, good spotting. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
