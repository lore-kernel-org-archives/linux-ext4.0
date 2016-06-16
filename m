From: Jan Kara <jack@suse.cz>
Subject: Re: WARNING at fs/ext4/inode.c ext4_evict_inode() triggers on 4.0
Date: Thu, 16 Jun 2016 10:33:04 +0200
Message-ID: <20160616083304.GD22835@quack2.suse.cz>
References: <20160615204939.GA52455@calvinowens-mba.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	kernel-team@fb.com
To: Calvin Owens <calvinowens@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbcFPIdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2016 04:33:07 -0400
Content-Disposition: inline
In-Reply-To: <20160615204939.GA52455@calvinowens-mba.dhcp.thefacebook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Calvin,

On Wed 15-06-16 16:49:39, Calvin Owens wrote:
> I'm hitting the following warning on a 4.0 kernel:
> 
>   WARNING: CPU: 15 PID: 1005611 at fs/ext4/inode.c:233 ext4_evict_inode+0x4be/0x4d0()
>   CPU: 15 PID: 1005611 Comm: rocksdb:bg0 Not tainted 4.0.9-60_fbk10_rc1_3974_g796b9b6 #1
>   Call Trace: 
>   [<ffffffff8176af8e>] dump_stack+0x4d/0x63
>   [<ffffffff8106c4dc>] warn_slowpath_common+0x8c/0xd0
>   [<ffffffff8106c5da>] warn_slowpath_null+0x1a/0x20
>   [<ffffffff81242c0e>] ext4_evict_inode+0x4be/0x4d0
>   [<ffffffff811d248b>] evict+0xbb/0x190 
>   [<ffffffff811d2d6d>] iput+0x17d/0x1e0
>   [<ffffffff811ce0e0>] __dentry_kill+0x190/0x1e0
>   [<ffffffff811ce2d1>] dput+0x1a1/0x1f0
>   [<ffffffff811b952a>] __fput+0x17a/0x210
>   [<ffffffff811b960e>] ____fput+0xe/0x10
>   [<ffffffff81086dbf>] task_work_run+0xbf/0x100 
>   [<ffffffff81002bcc>] do_notify_resume+0x7c/0x90
>   [<ffffffff81771529>] int_signal+0x12/0x17
> 
> Commit 822dbba ("ext4: fix warning in ext4_evict_inode()") proportedly fixed
> this in 3.11. The check was entirely removed in 4.6.

OK, so this is the warning:

WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));

It was removed in 4.6 since we maintained i_ioend_count only to be able to
do this check and it didn't trigger for a long time. So it is interesting
that it actually triggered for you with 4.0.

> Is it interesting to you that this triggers on 4.0? I can revert 600be30 and
> see if I can reproduce it on upstream, but since the check got removed I
> was wondering if there was post-4.0 work that makes it obsolete?

It would be great. I'm attaching a revert and an additional debug patch. If
you can run with these two on the latest kernel (or even just apply the debug
patch on top of 4.0) and reproduce the issue with it, I would be grateful.

Also if you reproduce the issue, please send me also your System.map so that
I can map the address of the function where ioend was created. Thanks!

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
