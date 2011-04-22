From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Fri, 22 Apr 2011 23:40:46 +0200
Message-ID: <20110422214046.GE2977@quack.suse.cz>
References: <20110406055708.GB23285@quack.suse.cz>
 <4D9C18DF.90803@jp.fujitsu.com>
 <20110406174617.GC28689@quack.suse.cz>
 <4DA84A7B.3040403@jp.fujitsu.com>
 <20110415171310.GB5432@quack.suse.cz>
 <4DABFEBD.7030102@jp.fujitsu.com>
 <20110418105105.GB5557@quack.suse.cz>
 <4DAD5934.1030901@jp.fujitsu.com>
 <20110422155839.3295e8e8.toshi.okajima@jp.fujitsu.com>
 <4DB1F26F.8040403@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com, Craig Magina <Craig.Magina@canonical.com>
To: "Peter M. Petrakis" <peter.petrakis@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab1DVVkt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Apr 2011 17:40:49 -0400
Content-Disposition: inline
In-Reply-To: <4DB1F26F.8040403@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 22-04-11 17:26:07, Peter M. Petrakis wrote:
> On 04/22/2011 02:58 AM, Toshiyuki Okajima wrote:
> > On Tue, 19 Apr 2011 18:43:16 +0900
> > I have confirmed that the following patch works fine while my or
> > Mizuma-san's reproducer is running. Therefore,
> >  we can block to write the data, which is mmapped to a file, into a disk
> > by a page-fault while fsfreezing. 
> > 
> > I think this patch fixes the following two problems:
> > - A deadlock occurs between ext4_da_writepages() (called from
> > writeback_inodes_wb) and thaw_super(). (reported by Mizuma-san)
> > - We can also write the data, which is mmapped to a file,
> >   into a disk while fsfreezing (ext3/ext4).
> >                                        (reported by me)
> > 
> > Please examine this patch.
> 
> We've recently identified the same root cause in 2.6.32 though the hit rate
> is much much higher. The configuration is a SAN ALUA Active/Standby using
> multipath. The s_wait_unfrozen/s_umount deadlock is regularly encountered
> when a path comes back into service, as a result of a kpartx invocation on
> behalf of this udev rule.
> 
> /lib/udev/rules.d/95-kpartx.rules
> 
> # Create dm tables for partitions
> ENV{DM_STATE}=="ACTIVE", ENV{DM_UUID}=="mpath-*", \
>         RUN+="/sbin/dmsetup ls --target multipath --exec '/sbin/kpartx -a -p -part' -j %M -m %m"
  Hmm, I don't think this is the same problem... See:

> [ 1898.017614] mptsas: ioc0: mptsas_add_fw_event: add (fw_event=0xffff880c3c815200)
> [ 1898.025995] mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff880c3c814780)
> [ 1898.034625] mptsas: ioc0: mptsas_firmware_event_work: fw_event=(0xffff880c3c814b40), event = (0x12)
> [ 1898.044803] mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff880c3c814b40)
> [ 1898.053475] mptsas: ioc0: mptsas_firmware_event_work: fw_event=(0xffff880c3c815c80), event = (0x12)
> [ 1898.063690] mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff880c3c815c80)
> [ 1898.072316] mptsas: ioc0: mptsas_firmware_event_work: fw_event=(0xffff880c3c815200), event = (0x0f)
> [ 1898.082544] mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff880c3c815200)
> [ 1898.571426] sd 0:0:1:0: alua: port group 01 state S supports toluSnA
> [ 1898.578635] device-mapper: multipath: Failing path 8:32.
> [ 2041.345645] INFO: task kjournald:595 blocked for more than 120 seconds.
> [ 2041.353075] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2041.361891] kjournald       D ffff88063acb9a90     0   595      2 0x00000000
> [ 2041.369891]  ffff88063ace1c30 0000000000000046 ffff88063c282140 ffff880600000000
> [ 2041.378416]  0000000000013cc0 ffff88063acb96e0 ffff88063acb9a90 ffff88063ace1fd8
> [ 2041.386954]  ffff88063acb9a98 0000000000013cc0 ffff88063ace0010 0000000000013cc0
> 
> [ 2041.395561] Call Trace:
> [ 2041.398358]  [<ffffffff81192380>] ? sync_buffer+0x0/0x50
> [ 2041.404342]  [<ffffffff815d3120>] io_schedule+0x70/0xc0
> [ 2041.410227]  [<ffffffff811923c5>] sync_buffer+0x45/0x50
> [ 2041.416179]  [<ffffffff815d378f>] __wait_on_bit+0x5f/0x90
> [ 2041.422258]  [<ffffffff81192380>] ? sync_buffer+0x0/0x50
> [ 2041.428275]  [<ffffffff815d3838>] out_of_line_wait_on_bit+0x78/0x90
> [ 2041.435324]  [<ffffffff81086b90>] ? wake_bit_function+0x0/0x40
> [ 2041.441958]  [<ffffffff8119237e>] __wait_on_buffer+0x2e/0x30
> [ 2041.448333]  [<ffffffff8123ab14>] journal_commit_transaction+0x7e4/0xec0
  So kjournald is committing a transaction and waiting for IO to complete.
Which maybe never happens because of multipath being in transition? That
would be a bug...

> [ 2041.670669] multipathd      D ffff88063e3303b0     0  1337      1 0x00000000
> [ 2041.678746]  ffff88063c0fda18 0000000000000082 0000000000000000 ffff880600000000
> [ 2041.687219]  0000000000013cc0 ffff88063e330000 ffff88063e3303b0 ffff88063c0fdfd8
> [ 2041.695818]  ffff88063e3303b8 0000000000013cc0 ffff88063c0fc010 0000000000013cc0
> [ 2041.704369] Call Trace:
> [ 2041.707128]  [<ffffffff815d349d>] schedule_timeout+0x21d/0x300
> [ 2041.713679]  [<ffffffff8104c8ec>] ? resched_task+0x2c/0x90
> [ 2041.719846]  [<ffffffff8105f763>] ? try_to_wake_up+0xc3/0x410
> [ 2041.726301]  [<ffffffff815d2436>] wait_for_common+0xd6/0x180
> [ 2041.732685]  [<ffffffff8105fb05>] ? wake_up_process+0x15/0x20
> [ 2041.739138]  [<ffffffff8105fab0>] ? default_wake_function+0x0/0x20
> [ 2041.746079]  [<ffffffff815d25bd>] wait_for_completion+0x1d/0x20
> [ 2041.752716]  [<ffffffff8107de18>] call_usermodehelper_exec+0xd8/0xe0
> [ 2041.759853]  [<ffffffff814a3110>] ? parse_hw_handler+0xb0/0x240
> [ 2041.766503]  [<ffffffff8107e060>] __request_module+0x190/0x210
> [ 2041.773054]  [<ffffffff812e0c28>] ? sscanf+0x38/0x40
> [ 2041.778636]  [<ffffffff814a3110>] parse_hw_handler+0xb0/0x240
> [ 2041.785121]  [<ffffffff814a38c3>] multipath_ctr+0x83/0x1d0
> [ 2041.791312]  [<ffffffff8149abd5>] ? dm_split_args+0x75/0x140
> [ 2041.797671]  [<ffffffff8149b9af>] dm_table_add_target+0xff/0x250
> [ 2041.804413]  [<ffffffff8149de3a>] table_load+0xca/0x2f0
> [ 2041.810317]  [<ffffffff8149dd70>] ? table_load+0x0/0x2f0
> [ 2041.816316]  [<ffffffff8149f0d5>] ctl_ioctl+0x1a5/0x240
> [ 2041.822184]  [<ffffffff8149f183>] dm_ctl_ioctl+0x13/0x20
> [ 2041.828188]  [<ffffffff81175245>] do_vfs_ioctl+0x95/0x3c0
> [ 2041.834250]  [<ffffffff8109ae6b>] ? sys_futex+0x7b/0x170
> [ 2041.840219]  [<ffffffff81175611>] sys_ioctl+0xa1/0xb0
> [ 2041.845898]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b
  multipathd is hung waiting for module to be loaded? How come?

> [ 2041.964575] INFO: task kpartx:1897 blocked for more than 120 seconds.
> [ 2041.971801] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2041.980626] kpartx          D ffff88063d05df30     0  1897   1896 0x00000000
> [ 2041.988607]  ffff88063c3a5b58 0000000000000082 0000000e3c3a5ac8 ffff880c00000000
> [ 2041.997056]  0000000000013cc0 ffff88063d05db80 ffff88063d05df30 ffff88063c3a5fd8
> [ 2042.005496]  ffff88063d05df38 0000000000013cc0 ffff88063c3a4010 0000000000013cc0
> [ 2042.013939] Call Trace:
> [ 2042.016702]  [<ffffffff8123dc85>] log_wait_commit+0xc5/0x150
> [ 2042.023089]  [<ffffffff81086b50>] ? autoremove_wake_function+0x0/0x40
> [ 2042.030321]  [<ffffffff815d4eee>] ? _raw_spin_lock+0xe/0x20
> [ 2042.036584]  [<ffffffff811e6256>] ext3_sync_fs+0x66/0x70
> [ 2042.042552]  [<ffffffff811ba7c1>] dquot_quota_sync+0x1c1/0x330
> [ 2042.049133]  [<ffffffff81115391>] ? do_writepages+0x21/0x40
> [ 2042.055423]  [<ffffffff8110ae8b>] ? __filemap_fdatawrite_range+0x5b/0x60
> [ 2042.062944]  [<ffffffff8118f42c>] __sync_filesystem+0x3c/0x90
> [ 2042.069430]  [<ffffffff8118f56b>] sync_filesystem+0x4b/0x70
> [ 2042.075690]  [<ffffffff81166a85>] freeze_super+0x55/0x100
> [ 2042.081754]  [<ffffffff811993b8>] freeze_bdev+0x98/0xe0
> [ 2042.087625]  [<ffffffff81499001>] dm_suspend+0xa1/0x2e0
> [ 2042.093495]  [<ffffffff8149ced9>] ? __get_name_cell+0x99/0xb0
> [ 2042.099948]  [<ffffffff8149e2d0>] ? dev_suspend+0x0/0xb0
> [ 2042.105916]  [<ffffffff8149e29b>] do_resume+0x17b/0x1b0
> [ 2042.111784]  [<ffffffff8149e2d0>] ? dev_suspend+0x0/0xb0
> [ 2042.117753]  [<ffffffff8149e365>] dev_suspend+0x95/0xb0
> [ 2042.123621]  [<ffffffff8149e2d0>] ? dev_suspend+0x0/0xb0
> [ 2042.129591]  [<ffffffff8149f0d5>] ctl_ioctl+0x1a5/0x240
> [ 2042.135493]  [<ffffffff815d4eee>] ? _raw_spin_lock+0xe/0x20
> [ 2042.141770]  [<ffffffff8149f183>] dm_ctl_ioctl+0x13/0x20
> [ 2042.147739]  [<ffffffff81175245>] do_vfs_ioctl+0x95/0x3c0
> [ 2042.153801]  [<ffffffff81175611>] sys_ioctl+0xa1/0xb0
> [ 2042.159478]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b
  kpartx is waiting for kjournald to finish transaction commit and it is
holding s_umount but that doesn't really seem to be a problem...

So as I say, find a reason why kjournald is not able to finish committing a
transaction and you should solve this riddle ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
