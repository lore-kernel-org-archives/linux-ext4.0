From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix potential deadlock in ext4_nonda_switch()
Date: Thu, 27 Sep 2012 21:18:30 +0400
Message-ID: <87ipaziduh.fsf@openvz.org>
References: <1348111390-23083-1-git-send-email-tytso@mit.edu> <505CE635.6060101@redhat.com> <20120921235912.GA27207@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:39653 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2I0RSf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2012 13:18:35 -0400
In-Reply-To: <20120921235912.GA27207@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 21 Sep 2012 19:59:12 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Sep 21, 2012 at 05:12:05PM -0500, Eric Sandeen wrote:
> > > -	if (free_blocks < 2 * dirty_blocks)
> > > -		writeback_inodes_sb_if_idle(sb, WB_REASON_FS_FREE_SPACE);
> > > +	if ((free_blocks < 2 * dirty_blocks) && writeback_in_progress(sb->s_bdi))
> > > +		writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
> > 
> > Looks to me like this inverts the logic.
> > 
> > We used to write back if idle, now we fire it off if it's already underway.
> > 
> > Shouldn't it be:
> > 
> > +	if ((free_blocks < 2 * dirty_blocks) && !writeback_in_progress(sb->s_bdi))
> > +		writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
> 
> Oops, nice catch.  Thanks for the review!!
> 
> I've added the missing '!' to the patch.
Hmm... even this '!' patch is still not good. I've got that complain
WARNING: at fs/fs-writeback.c:1316 writeback_inodes_sb_nr+0x1a3/0x200()
Hardware name:         
Modules linked in: ext4 jbd2 cpufreq_ondemand acpi_cpufreq freq_table
mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode
sg xhci_hcd button ext3 jbd mbcache sd_mod crc_t10dif aesni_intel
ablk_helper cryptd aes_x86_64 aes_generic ahci libahci pata_acpi
ata_generic dm_mirror dm_region_hash dm_log dm_mod
Pid: 1896, comm: fio Not tainted 3.6.0-rc1+ #77
Call Trace:
 [<ffffffff81069433>] warn_slowpath_common+0xc3/0xf0
 [<ffffffff8106947a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81253a13>] writeback_inodes_sb_nr+0x1a3/0x200
 [<ffffffff81253f4e>] writeback_inodes_sb+0x2e/0x40
 [<ffffffffa03d73d9>] ext4_nonda_switch+0xe9/0x120 [ext4]
 [<ffffffffa03dd2ea>] ext4_da_write_begin+0x4a/0x330 [ext4]
 [<ffffffff811874ca>] generic_perform_write+0x11a/0x360
 [<ffffffff810dc9f7>] ? current_kernel_time+0x97/0xb0
 [<ffffffff81187771>] generic_file_buffered_write+0x61/0xd0
 [<ffffffff8118b98a>] __generic_file_aio_write+0x6ca/0x820
 [<ffffffff8118bb93>] generic_file_aio_write+0xb3/0x150
 [<ffffffffa03d2785>] ext4_file_write+0x155/0x190 [ext4]
 [<ffffffffa03d2630>] ? ext4_file_dio_write+0x550/0x550 [ext4]
 [<ffffffff81281f6e>] aio_rw_vect_retry+0xce/0x200
 [<ffffffff81281ea0>] ? aio_advance_iovec+0x130/0x130
 [<ffffffff81281ea0>] ? aio_advance_iovec+0x130/0x130
 [<ffffffff812832b6>] aio_run_iocb+0xd6/0x2e0
 [<ffffffff817397c8>] io_submit_one+0x38a/0x3ff
 [<ffffffff81284c8e>] do_io_submit+0x2be/0x3d0
 [<ffffffff81284db0>] sys_io_submit+0x10/0x20
 [<ffffffff8175c8e9>] system_call_fastpath+0x16/0x1b
---[ end trace 586bc928292ed61e ]---

> 
>      	   					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
