From: Jan Kara <jack@suse.cz>
Subject: Re: FYI: one more way to run xfstest
Date: Wed, 20 Mar 2013 12:28:52 +0100
Message-ID: <20130320112852.GB13294@quack.suse.cz>
References: <87txo6xu5u.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab3CTL2z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 07:28:55 -0400
Content-Disposition: inline
In-Reply-To: <87txo6xu5u.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 20-03-13 14:06:05, Dmitry Monakhov wrote:
> 
> Today I've run xfstest in parallel with fsfreze/fsthaw like follows
> # I use dmsetup {suspend,resume} which does fsfreeze/fsthaw and other
> # dm's speciffic stuff (which is not related in that case)
> (while true ;do dmsetup suspend $TEST_DEV ;dmsetup resume $TEST_DEV;done)&
> (while true ;do dmsetup suspend $SCRATCH_DEV ;dmsetup resume $SCRATCH_DEV;done)&
> # And later as usual
> ./check -g auto
> I use origin/dev (current dev HEAD): c902ed2d06a
> 
> Quickly it spots a lot of traces from incorrect freeze-api state:
> ------------[ cut here ]------------
> WARNING: at fs/ext4/ext4_jbd2.c:50 __ext4_journal_start_sb+0x132/0x240()
  Heh, funny, Al Viro just found this issue as well yesterday. The problem
is that ext4_file_dio_write() is missing proper freeze protection. We are
likely going to somewhat move where freeze protection happens for writes
due to other issues (discussing that now) so it doesn't make sense to fix
it just now in ext4.

								Honza

> Hardware name:         
> Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
> Pid: 29760, comm: fsx Not tainted 3.8.0-rc3+ #98
> Call Trace:
> [<ffffffff8106fb0d>] warn_slowpath_common+0xad/0xf0
> [<ffffffff81344f97>] ? ext4_da_write_begin+0x277/0x4f0
> [<ffffffff8106fb6a>] warn_slowpath_null+0x1a/0x20
> [<ffffffff8138a122>] __ext4_journal_start_sb+0x132/0x240
> [<ffffffff81344f97>] ext4_da_write_begin+0x277/0x4f0
> [<ffffffff811a0668>] generic_perform_write+0x148/0x3c0
> [<ffffffff811a0944>] generic_file_buffered_write+0x64/0xd0
> [<ffffffff811a5c90>] __generic_file_aio_write+0x4d0/0x750
> [<ffffffff81335da3>] ext4_file_dio_write+0x253/0x4e0
> [<ffffffff81336101>] ext4_file_write+0xd1/0x190
> [<ffffffff81243072>] do_sync_write+0xb2/0x120
> [<ffffffff8124332c>] ? rw_verify_area+0x12c/0x270
> [<ffffffff812435f2>] vfs_write+0x182/0x1f0
> [<ffffffff818ff605>] ? sysret_check+0x22/0x5d
> [<ffffffff812445f4>] sys_write+0x94/0xd0
> [<ffffffff818ff5d9>] system_call_fastpath+0x16/0x1b
> ---[ end trace be4bc73619d3477b ]---
> ------------[ cut here ]------------
> 
> Also it find destroyed object in the list:
> ------------[ cut here ]------------
> WARNING: at lib/list_debug.c:62 __list_del_entry+0x1c0/0x250()
> Hardware name:         
> list_del corruption. prev->next should be ffff8801fbb747c8, but was 6b6b6b6b6b6b6b6b
> Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
> Pid: 13297, comm: jbd2/dm-3-8 Tainted: G        W    3.8.0-rc3+ #98
> Call Trace:
> [<ffffffff8106fb0d>] warn_slowpath_common+0xad/0xf0
> [<ffffffff8106fc06>] warn_slowpath_fmt+0x46/0x50
> [<ffffffff81363689>] ? ext4_journal_commit_callback+0x99/0xc0
> [<ffffffff8148c980>] __list_del_entry+0x1c0/0x250
> [<ffffffff8136365f>] ext4_journal_commit_callback+0x6f/0xc0
> [<ffffffff813ca1d6>] jbd2_journal_commit_transaction+0x23a6/0x2570
> [<ffffffff8108aa42>] ? try_to_del_timer_sync+0x82/0xa0
> [<ffffffff8108b491>] ? del_timer_sync+0x91/0x1e0
> [<ffffffff813d3d6f>] kjournald2+0x19f/0x6a0
> [<ffffffff810ad630>] ? wake_up_bit+0x40/0x40
> [<ffffffff813d3bd0>] ? bit_spin_lock+0x80/0x80
> [<ffffffff810ac6be>] kthread+0x10e/0x120
> [<ffffffff810ac5b0>] ? __init_kthread_worker+0x70/0x70
> [<ffffffff818ff52c>] ret_from_fork+0x7c/0xb0
> [<ffffffff810ac5b0>] ? __init_kthread_worker+0x70/0x70
> ---[ end trace be4bc73619d357f9 ]---
> 
> Right now I work on this issues. But I just want to let you know about
> this.
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
