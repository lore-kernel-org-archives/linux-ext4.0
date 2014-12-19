From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_da_update_reserve_space warning with kernel 3.10
Date: Fri, 19 Dec 2014 11:52:08 +0100
Message-ID: <20141219105208.GA28890@quack.suse.cz>
References: <CAHTgTXVNYNRHtDbQ1yGKbhnn-=bCzZFKjqUrW_v5+MokXPRzoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Vinson Lee <vlee@twopensource.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbaLSKw1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 05:52:27 -0500
Content-Disposition: inline
In-Reply-To: <CAHTgTXVNYNRHtDbQ1yGKbhnn-=bCzZFKjqUrW_v5+MokXPRzoQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 18-12-14 17:23:22, Vinson Lee wrote:
> We're triggering a kernel warning in ext4_da_update_reserve_space on
> kernels 3.4 and 3.10. We do not have a reproducible test case, but the
> warning happens more frequently with a slow network.
> 
> EXT4-fs warning (device sdh1): ext4_da_update_reserve_space:362: ino
> 1310732, allocated 1 with only 0 reserved metadata blocks (releasing 1
> blocks with reserved 14 data blocks)
  Yes, it looks like the problem you referenced below. But we don't plan to
fix this in 3.10 or even 3.4 stable kernel. The warning is mostly harmless
and fixing it would require rather intrusive changes to be backported...

								Honza

> ------------[ cut here ]------------
> WARNING: at fs/ext4/inode.c:363 ext4_da_update_reserve_space+0xe7/0x20c()
> Modules linked in: netconsole configfs ipv6 ppdev parport_pc lp
> parport tcp_diag inet_diag ipmi_si ipmi_devintf ipm
> O_wdt iTCO_vendor_support acpi_cpufreq freq_table mperf coretemp
> kvm_intel kvm crc32c_intel ghash_clmulni_intel mic
> i2c_core lpc_ich mfd_core shpchp mlx4_en mlx4_core video mpt2sas
> scsi_transport_sas raid_class
> CPU: 0 PID: 50134 Comm: java Not tainted 3.10.50 #1
>  0000000000000000 ffff880595dc1bb0 ffffffff814a4094 ffff880595dc1be8
>  ffffffff8103cbf9 0000000000000000 ffff88039cdd1ef0 000000000000000e
>  ffff880052527f60 ffff8807e9ad6000 ffff880595dc1bf8 ffffffff8103ccbf
> Call Trace:
>  [<ffffffff814a4094>] dump_stack+0x19/0x1b
>  [<ffffffff8103cbf9>] warn_slowpath_common+0x65/0x7d
>  [<ffffffff8103ccbf>] warn_slowpath_null+0x1a/0x1c
>  [<ffffffff81190b7e>] ext4_da_update_reserve_space+0xe7/0x20c
>  [<ffffffff811b30e7>] ext4_ext_map_blocks+0xae5/0xc09
>  [<ffffffff81190ed5>] ext4_map_blocks+0x232/0x3a0
>  [<ffffffff81192e28>] mpage_da_map_and_submit+0x8e/0x32c
>  [<ffffffff8119375e>] ext4_da_writepages+0x2cf/0x483
>  [<ffffffff810ed6d3>] do_writepages+0x1e/0x2c
>  [<ffffffff810e5b3e>] __filemap_fdatawrite_range+0x55/0x57
>  [<ffffffff810e7ef7>] SyS_fadvise64_64+0x163/0x1da
>  [<ffffffff810e7f7c>] SyS_fadvise64+0xe/0x12
>  [<ffffffff814aee46>] system_call_fastpath+0x1a/0x1f
> ---[ end trace bfdca050e80bbf21 ]---
> 
> 
> This looks similar to a bug fixed by 3.12 commit "ext4: fix warning in
> ext4_da_update_reserve_space()" [1]. However, this commit wasn't
> backported to stable [2].
> 
> Cheers,
> Vinson
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=63511
> [2] http://lists.openwall.net/linux-ext4/2013/10/23/7
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
