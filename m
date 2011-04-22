From: "Peter M. Petrakis" <peter.petrakis@canonical.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Fri, 22 Apr 2011 17:26:07 -0400
Message-ID: <4DB1F26F.8040403@canonical.com>
References: <4D946DAB.3010107@jp.fujitsu.com>	<4D9AEE28.4000003@jp.fujitsu.com>	<20110405225428.GD8531@quack.suse.cz>	<4D9BF57A.6030705@jp.fujitsu.com>	<20110406055708.GB23285@quack.suse.cz>	<4D9C18DF.90803@jp.fujitsu.com>	<20110406174617.GC28689@quack.suse.cz>	<4DA84A7B.3040403@jp.fujitsu.com>	<20110415171310.GB5432@quack.suse.cz>	<4DABFEBD.7030102@jp.fujitsu.com>	<20110418105105.GB5557@quack.suse.cz>	<4DAD5934.1030901@jp.fujitsu.com> <20110422155839.3295e8e8.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com, Craig Magina <Craig.Magina@canonical.com>
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110422155839.3295e8e8.toshi.okajima@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

On 04/22/2011 02:58 AM, Toshiyuki Okajima wrote:
> Hi,
> 
> On Tue, 19 Apr 2011 18:43:16 +0900
> Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
>> Hi,
>>
>> (2011/04/18 19:51), Jan Kara wrote:
>>> On Mon 18-04-11 18:05:01, Toshiyuki Okajima wrote:
>>>>> On Fri 15-04-11 22:39:07, Toshiyuki Okajima wrote:
>>>>>>>    For ext3 or ext4 without delayed allocation we block inside writepage()
>>>>>>> function. But as I wrote to Dave Chinner, ->page_mkwrite() should probably
>>>>>>> get modified to block while minor-faulting the page on frozen fs because
>>>>>>> when blocks are already allocated we may skip starting a transaction and so
>>>>>>> we could possibly modify the filesystem.
>>>>>> OK. I think ->page_mkwrite() should also block writing the minor-faulting pages.
>>>>>>
>>>>>> (minor-pagefault)
>>>>>> ->   do_wp_page()
>>>>>>     ->   page_mkwrite(= ext4_mkwrite())
>>>>>>        =>   BLOCK!
>>>>>>
>>>>>> (major-pagefault)
>>>>>> ->   do_liner_fault()
>>>>>>     ->   page_mkwrite(= ext4_mkwrite())
>>>>>>        =>   BLOCK!
>>>>>>
>>>>>>>
>>>>>>>>>> Mizuma-san's reproducer also writes the data which maps to the file (mmap).
>>>>>>>>>> The original problem happens after the fsfreeze operation is done.
>>>>>>>>>> I understand the normal write operation (not mmap) can be blocked while
>>>>>>>>>> fsfreezing. So, I guess we don't always block all the write operation
>>>>>>>>>> while fsfreezing.
>>>>>>>>>    Technically speaking, we block all the transaction starts which means we
>>>>>>>>> end up blocking all the writes from going to disk. But that does not mean
>>>>>>>>> we block all the writes from going to in-memory cache - as you properly
>>>>>>>>> note the mmap case is one of such exceptions.
>>>>>>>> Hm, I also think we can allow the writes to in-memory cache but we can't allow
>>>>>>>> the writes to disk while fsfreezing. I am considering that mmap path can
>>>>>>>> write to disk while fsfreezing because this deadlock problem happens after
>>>>>>>> fsfreeze operation is done...
>>>>>>>    I'm sorry I don't understand now - are you speaking about the case above
>>>>>>> when writepage() does not wait for filesystem being frozen or something
>>>>>>> else?
>>>>>> Sorry, I didn't understand around the page fault path.
>>>>>> So, I had read the kernel source code around it, then I maybe understand...
>>>>>>
>>>>>> I worry whether we can update the file data in mmap case while fsfreezing.
>>>>>> Of course, I understand that we can write to in-memory cache, and it is not a
>>>>>> problem. However, if we can write to disk while fsfreezing, it is a problem.
>>>>>> So, I summarize the cases whether we can write to disk or not.
>>>>>>
>>>>>> --------------------------------------------------------------------------
>>>>>> Cases (Whether we can write the data mmapped to the file on the disk
>>>>>> while fsfreezing)
>>>>>>
>>>>>> [1] One of the page which has been mmapped is not bound. And
>>>>>>   the page is not allocated yet. (major fault?)
>>>>>>
>>>>>>     (1) user dirtys a page
>>>>>>     (2) a page fault occurs (do_page_fault)
>>>>>>     (3) __do_falut is called.
>>>>>>     (4) ext4_page_mkwrite is called
>>>>>>     (5) ext4_write_begin is called
>>>>>>     (6) ext4_journal_start_sb       =>   We can STOP!
>>>>>>
>>>>>> [2] One of the page which has been mmapped is not bound. But
>>>>>>   the page is already allocated, and the buffer_heads of the page
>>>>>>   are not mapped (BH_Mapped).  (minor fault?)
>>>>>>
>>>>>>     (1) user dirtys a page
>>>>>>     (2) a page fault occurs (do_page_fault)
>>>>>>     (3) do_wp_page is called.
>>>>>>     (4) ext4_page_mkwrite is called
>>>>>>     (5) ext4_write_begin is called
>>>>>>     (6) ext4_journal_start_sb       =>   We can STOP!
>>>>>>
>>>>>> [3] One of the page which has been mmapped is not bound. But
>>>>>>   the page is already allocated, and the buffer_heads of the page
>>>>>>   are mapped (BH_Mapped).  (minor fault?)
>>>>>>
>>>>>>     (1) user dirtys a page
>>>>>>     (2) a page fault occurs (do_page_fault)
>>>>>>     (3) do_wp_page is called.
>>>>>>     (4) ext4_page_mkwrite is called
>>>>>>     * Cannot block the dirty page to be written because all bh is mapped.
>>>>>>     (5) user munmaps the page (munmap)
>>>>>>     (6) zap_pte_range dirtys the page (struct page) which is pte_dirtyed.
>>>>>>     (7) writeback thread writes the page (struct page) to disk
>>>>>>                                             =>   We cannot STOP!
>>>>>>
>>>>>> [4] One of the page which has been mmapped is bound. And
>>>>>>   the page is already allocated.
>>>>>>
>>>>>>     (1) user dirtys a page
>>>>>>     ( ) no page fault occurs
>>>>>>     (2) user munmaps the page (munmap)
>>>>>>     (3) zap_pte_range dirtys the page (struct page) which is pte_dirtyed.
>>>>>>     (4) writeback thread writes the page (struct page) to disk
>>>>>>                                             =>   We cannot STOP!
>>>>>> --------------------------------------------------------------------------
>>>>>>
>>>>>> So, we can block the cases [1], [2].
>>>>>> But I think we cannot block the cases [3], [4] now.
>>>>>> If fixing the page_mkwrite, we can also block the case [3].
>>>>>> But the case [4] is not blocked because no page fault occurs
>>>>>> when we dirty the mmapped page.
>>>>>>
>>>>>> Therefore, to repair this problem, we need to fix the cases [3], [4].
>>>>>> I think we must modify the writeback thread to fix the case [4].
>>>>>    The trick here is that when we write a page to disk, we write-protect
>>>>> the page (you seem to call this that "the page is bound", I'm not sure why).
>>>> Hm, I want to understand how to write-protect the page under fsfreezing.
>>>    Look at what page_mkclean() called from clear_page_dirty_for_io() does...
>> Thanks. I'll read that.
>>
>>>
>>>> But, anyway, I understand we don't need to consider the case [4].
>>>    Yes.
>>>
>>>>> So we are guaranteed to receive a minor fault (case [3]) if user tries to
>>>>> modify a page after we finish writeback while freezing the filesystem.
>>>>> So principially all we need to do is just wait in ext4_page_mkwrite().
>>>> OK. I understand.
>>>> Are there any concrete ideas to fix this?
>>>> For ext4, we can rescue from the case [3] by modifying ext4_page_mkwrite().
>>>    Yes.
>>>
>>>> But for ext3 or other FSs, we must implement ->page_mkwrite() to prevent it?
>>>    Sadly I don't see a simple way to fix this issue for all filesystems at
>>> once. Implementing proper wait in block_page_mkwrite() should fix the issue
>>> for xfs. Other filesystems like GFS2 or Btrfs will have to be fixed
>>> separately as ext4. For ext3, we'd have to add ->page_mkwrite() support. I
>>> have patches for this already for some time but I have to get to properly
>>> testing them in more exotic conditions like 64k pages...
>> OK. I understand the current status of your works to fix the problem which
>> can be written with some data at mmap path while fsfreezing.
> I have confirmed that the following patch works fine while my or
> Mizuma-san's reproducer is running. Therefore,
>  we can block to write the data, which is mmapped to a file, into a disk
> by a page-fault while fsfreezing. 
> 
> I think this patch fixes the following two problems:
> - A deadlock occurs between ext4_da_writepages() (called from
> writeback_inodes_wb) and thaw_super(). (reported by Mizuma-san)
> - We can also write the data, which is mmapped to a file,
>   into a disk while fsfreezing (ext3/ext4).
>                                        (reported by me)
> 
> Please examine this patch.

We've recently identified the same root cause in 2.6.32 though the hit rate
is much much higher. The configuration is a SAN ALUA Active/Standby using
multipath. The s_wait_unfrozen/s_umount deadlock is regularly encountered
when a path comes back into service, as a result of a kpartx invocation on
behalf of this udev rule.

/lib/udev/rules.d/95-kpartx.rules

# Create dm tables for partitions
ENV{DM_STATE}=="ACTIVE", ENV{DM_UUID}=="mpath-*", \
        RUN+="/sbin/dmsetup ls --target multipath --exec '/sbin/kpartx -a -p -part' -j %M -m %m"


Below are the logs of the current incarntion of the fault with your current patch against 2.6.38.
Still working to obtain a viable crashdump.

[ 1898.017614] mptsas: ioc0: mptsas_add_fw_event: add (fw_event=0xffff880c3c815200)

[ 1898.025995] mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff880c3c814780)

[ 1898.034625] mptsas: ioc0: mptsas_firmware_event_work: fw_event=(0xffff880c3c814b40), event = (0x12)

[ 1898.044803] mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff880c3c814b40)

[ 1898.053475] mptsas: ioc0: mptsas_firmware_event_work: fw_event=(0xffff880c3c815c80), event = (0x12)

[ 1898.063690] mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff880c3c815c80)

[ 1898.072316] mptsas: ioc0: mptsas_firmware_event_work: fw_event=(0xffff880c3c815200), event = (0x0f)

[ 1898.082544] mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff880c3c815200)

[ 1898.571426] sd 0:0:1:0: alua: port group 01 state S supports toluSnA

[ 1898.578635] device-mapper: multipath: Failing path 8:32.

[ 2041.345645] INFO: task kjournald:595 blocked for more than 120 seconds.

[ 2041.353075] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

[ 2041.361891] kjournald       D ffff88063acb9a90     0   595      2 0x00000000

[ 2041.369891]  ffff88063ace1c30 0000000000000046 ffff88063c282140 ffff880600000000

[ 2041.378416]  0000000000013cc0 ffff88063acb96e0 ffff88063acb9a90 ffff88063ace1fd8

[ 2041.386954]  ffff88063acb9a98 0000000000013cc0 ffff88063ace0010 0000000000013cc0

[ 2041.395561] Call Trace:

[ 2041.398358]  [<ffffffff81192380>] ? sync_buffer+0x0/0x50

[ 2041.404342]  [<ffffffff815d3120>] io_schedule+0x70/0xc0

[ 2041.410227]  [<ffffffff811923c5>] sync_buffer+0x45/0x50

[ 2041.416179]  [<ffffffff815d378f>] __wait_on_bit+0x5f/0x90

[ 2041.422258]  [<ffffffff81192380>] ? sync_buffer+0x0/0x50

[ 2041.428275]  [<ffffffff815d3838>] out_of_line_wait_on_bit+0x78/0x90

[ 2041.435324]  [<ffffffff81086b90>] ? wake_bit_function+0x0/0x40

[ 2041.441958]  [<ffffffff8119237e>] __wait_on_buffer+0x2e/0x30

[ 2041.448333]  [<ffffffff8123ab14>] journal_commit_transaction+0x7e4/0xec0

[ 2041.455873]  [<ffffffff81038d09>] ? default_spin_lock_flags+0x9/0x10

[ 2041.463020]  [<ffffffff8107443c>] ? lock_timer_base+0x3c/0x70

[ 2041.469514]  [<ffffffff81074e33>] ? try_to_del_timer_sync+0x83/0xe0

[ 2041.476563]  [<ffffffff8123df7d>] kjournald+0xed/0x250

[ 2041.482349]  [<ffffffff81086b50>] ? autoremove_wake_function+0x0/0x40

[ 2041.489624]  [<ffffffff8123de90>] ? kjournald+0x0/0x250

[ 2041.495504]  [<ffffffff810865e6>] kthread+0x96/0xa0

[ 2041.501003]  [<ffffffff8100ce64>] kernel_thread_helper+0x4/0x10

[ 2041.507667]  [<ffffffff81086550>] ? kthread+0x0/0xa0

[ 2041.513301]  [<ffffffff8100ce60>] ? kernel_thread_helper+0x0/0x10

[ 2041.520247] INFO: task rsyslogd:1854 blocked for more than 120 seconds.

[ 2041.527677] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

[ 2041.536499] rsyslogd        D ffff88063c513170     0  1854      1 0x00000000

[ 2041.544533]  ffff88063d0e3cd8 0000000000000082 ffff88063c479180 0000000000000000

[ 2041.553108]  0000000000013cc0 ffff88063c512dc0 ffff88063c513170 ffff88063d0e3fd8

[ 2041.561691]  ffff88063c513178 0000000000013cc0 ffff88063d0e2010 0000000000013cc0

[ 2041.570323] Call Trace:

[ 2041.573108]  [<ffffffff8110c78d>] __generic_file_aio_write+0xbd/0x470

[ 2041.580447]  [<ffffffff8108a82d>] ? hrtimer_try_to_cancel+0x3d/0xd0

[ 2041.587496]  [<ffffffff81097e3d>] ? futex_wait_queue_me+0xcd/0x110

[ 2041.594489]  [<ffffffff81086b50>] ? autoremove_wake_function+0x0/0x40

[ 2041.601833]  [<ffffffff8110cba2>] generic_file_aio_write+0x62/0xd0

[ 2041.608831]  [<ffffffff81163a9a>] do_sync_write+0xda/0x120

[ 2041.615165]  [<ffffffff812de756>] ? rb_erase+0xd6/0x160

[ 2041.621050]  [<ffffffff812ac918>] ? apparmor_file_permission+0x18/0x20

[ 2041.628395]  [<ffffffff81279b23>] ? security_file_permission+0x23/0x90

[ 2041.635827]  [<ffffffff81164018>] vfs_write+0xc8/0x190

[ 2041.641649]  [<ffffffff811641d1>] sys_write+0x51/0x90

[ 2041.647337]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b

[ 2041.654091] INFO: task multipathd:1337 blocked for more than 120 seconds.

[ 2041.661750] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

[ 2041.670669] multipathd      D ffff88063e3303b0     0  1337      1 0x00000000

[ 2041.678746]  ffff88063c0fda18 0000000000000082 0000000000000000 ffff880600000000

[ 2041.687219]  0000000000013cc0 ffff88063e330000 ffff88063e3303b0 ffff88063c0fdfd8

[ 2041.695818]  ffff88063e3303b8 0000000000013cc0 ffff88063c0fc010 0000000000013cc0

[ 2041.704369] Call Trace:

[ 2041.707128]  [<ffffffff815d349d>] schedule_timeout+0x21d/0x300

[ 2041.713679]  [<ffffffff8104c8ec>] ? resched_task+0x2c/0x90

[ 2041.719846]  [<ffffffff8105f763>] ? try_to_wake_up+0xc3/0x410

[ 2041.726301]  [<ffffffff815d2436>] wait_for_common+0xd6/0x180

[ 2041.732685]  [<ffffffff8105fb05>] ? wake_up_process+0x15/0x20

[ 2041.739138]  [<ffffffff8105fab0>] ? default_wake_function+0x0/0x20

[ 2041.746079]  [<ffffffff815d25bd>] wait_for_completion+0x1d/0x20

[ 2041.752716]  [<ffffffff8107de18>] call_usermodehelper_exec+0xd8/0xe0

[ 2041.759853]  [<ffffffff814a3110>] ? parse_hw_handler+0xb0/0x240

[ 2041.766503]  [<ffffffff8107e060>] __request_module+0x190/0x210

[ 2041.773054]  [<ffffffff812e0c28>] ? sscanf+0x38/0x40

[ 2041.778636]  [<ffffffff814a3110>] parse_hw_handler+0xb0/0x240

[ 2041.785121]  [<ffffffff814a38c3>] multipath_ctr+0x83/0x1d0

[ 2041.791312]  [<ffffffff8149abd5>] ? dm_split_args+0x75/0x140

[ 2041.797671]  [<ffffffff8149b9af>] dm_table_add_target+0xff/0x250

[ 2041.804413]  [<ffffffff8149de3a>] table_load+0xca/0x2f0

[ 2041.810317]  [<ffffffff8149dd70>] ? table_load+0x0/0x2f0

[ 2041.816316]  [<ffffffff8149f0d5>] ctl_ioctl+0x1a5/0x240

[ 2041.822184]  [<ffffffff8149f183>] dm_ctl_ioctl+0x13/0x20

[ 2041.828188]  [<ffffffff81175245>] do_vfs_ioctl+0x95/0x3c0

[ 2041.834250]  [<ffffffff8109ae6b>] ? sys_futex+0x7b/0x170

[ 2041.840219]  [<ffffffff81175611>] sys_ioctl+0xa1/0xb0

[ 2041.845898]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b

[ 2041.852639] INFO: task iozone:1871 blocked for more than 120 seconds.

[ 2041.859921] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

[ 2041.868760] iozone          D ffff880c3bc21a90     0  1871   1869 0x00000000

[ 2041.876728]  ffff880c3e743e20 0000000000000086 0000000000000001 ffff880c00000000

[ 2041.885177]  0000000000013cc0 ffff880c3bc216e0 ffff880c3bc21a90 ffff880c3e743fd8

[ 2041.893647]  ffff880c3bc21a98 0000000000013cc0 ffff880c3e742010 0000000000013cc0

[ 2041.902112] Call Trace:

[ 2041.906302]  [<ffffffff8104c8ec>] ? resched_task+0x2c/0x90

[ 2041.912494]  [<ffffffff815d4ddd>] rwsem_down_failed_common+0xcd/0x170

[ 2041.919718]  [<ffffffff8118f480>] ? sync_one_sb+0x0/0x30

[ 2041.925719]  [<ffffffff815d4eb5>] rwsem_down_read_failed+0x15/0x17

[ 2041.932690]  [<ffffffff812e41a4>] call_rwsem_down_read_failed+0x14/0x30

[ 2041.940116]  [<ffffffff815d4207>] ? down_read+0x17/0x20

[ 2041.945990]  [<ffffffff811665e1>] iterate_supers+0x71/0xf0

[ 2041.952149]  [<ffffffff8118f4df>] sys_sync+0x2f/0x70

[ 2041.957763]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b

[ 2041.964575] INFO: task kpartx:1897 blocked for more than 120 seconds.

[ 2041.971801] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

[ 2041.980626] kpartx          D ffff88063d05df30     0  1897   1896 0x00000000

[ 2041.988607]  ffff88063c3a5b58 0000000000000082 0000000e3c3a5ac8 ffff880c00000000

[ 2041.997056]  0000000000013cc0 ffff88063d05db80 ffff88063d05df30 ffff88063c3a5fd8

[ 2042.005496]  ffff88063d05df38 0000000000013cc0 ffff88063c3a4010 0000000000013cc0

[ 2042.013939] Call Trace:

[ 2042.016702]  [<ffffffff8123dc85>] log_wait_commit+0xc5/0x150

[ 2042.023089]  [<ffffffff81086b50>] ? autoremove_wake_function+0x0/0x40

[ 2042.030321]  [<ffffffff815d4eee>] ? _raw_spin_lock+0xe/0x20

[ 2042.036584]  [<ffffffff811e6256>] ext3_sync_fs+0x66/0x70

[ 2042.042552]  [<ffffffff811ba7c1>] dquot_quota_sync+0x1c1/0x330

[ 2042.049133]  [<ffffffff81115391>] ? do_writepages+0x21/0x40

[ 2042.055423]  [<ffffffff8110ae8b>] ? __filemap_fdatawrite_range+0x5b/0x60

[ 2042.062944]  [<ffffffff8118f42c>] __sync_filesystem+0x3c/0x90

[ 2042.069430]  [<ffffffff8118f56b>] sync_filesystem+0x4b/0x70

[ 2042.075690]  [<ffffffff81166a85>] freeze_super+0x55/0x100

[ 2042.081754]  [<ffffffff811993b8>] freeze_bdev+0x98/0xe0

[ 2042.087625]  [<ffffffff81499001>] dm_suspend+0xa1/0x2e0

[ 2042.093495]  [<ffffffff8149ced9>] ? __get_name_cell+0x99/0xb0

[ 2042.099948]  [<ffffffff8149e2d0>] ? dev_suspend+0x0/0xb0

[ 2042.105916]  [<ffffffff8149e29b>] do_resume+0x17b/0x1b0

[ 2042.111784]  [<ffffffff8149e2d0>] ? dev_suspend+0x0/0xb0

[ 2042.117753]  [<ffffffff8149e365>] dev_suspend+0x95/0xb0

[ 2042.123621]  [<ffffffff8149e2d0>] ? dev_suspend+0x0/0xb0

[ 2042.129591]  [<ffffffff8149f0d5>] ctl_ioctl+0x1a5/0x240

[ 2042.135493]  [<ffffffff815d4eee>] ? _raw_spin_lock+0xe/0x20

[ 2042.141770]  [<ffffffff8149f183>] dm_ctl_ioctl+0x13/0x20

[ 2042.147739]  [<ffffffff81175245>] do_vfs_ioctl+0x95/0x3c0

[ 2042.153801]  [<ffffffff81175611>] sys_ioctl+0xa1/0xb0

[ 2042.159478]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b

[ 2161.971321] INFO: task rsyslogd:1854 blocked for more than 120 seconds.

[ 2161.978798] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

[ 2161.987656] rsyslogd        D ffff88063c513170     0  1854      1 0x00000000

[ 2161.995718]  ffff88063d0e3cd8 0000000000000082 ffff88063c479180 0000000000000000

[ 2162.004340]  0000000000013cc0 ffff88063c512dc0 ffff88063c513170 ffff88063d0e3fd8

[ 2162.012932]  ffff88063c513178 0000000000013cc0 ffff88063d0e2010 0000000000013cc0

[ 2162.021481] Call Trace:

[ 2162.024290]  [<ffffffff8110c78d>] __generic_file_aio_write+0xbd/0x470

[ 2162.031627]  [<ffffffff8108a82d>] ? hrtimer_try_to_cancel+0x3d/0xd0

[ 2162.038711]  [<ffffffff81097e3d>] ? futex_wait_queue_me+0xcd/0x110

[ 2162.045662]  [<ffffffff81086b50>] ? autoremove_wake_function+0x0/0x40

[ 2162.053007]  [<ffffffff8110cba2>] generic_file_aio_write+0x62/0xd0

[ 2162.059962]  [<ffffffff81163a9a>] do_sync_write+0xda/0x120

[ 2162.066165]  [<ffffffff812de756>] ? rb_erase+0xd6/0x160

[ 2162.072048]  [<ffffffff812ac918>] ? apparmor_file_permission+0x18/0x20

[ 2162.079387]  [<ffffffff81279b23>] ? security_file_permission+0x23/0x90

[ 2162.086761]  [<ffffffff81164018>] vfs_write+0xc8/0x190

[ 2162.092552]  [<ffffffff811641d1>] sys_write+0x51/0x90

[ 2162.098247]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b

[ 2162.105042] INFO: task multipathd:1337 blocked for more than 120 seconds.

[ 2162.112667] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

[ 2162.121487] multipathd      D ffff88063e3303b0     0  1337      1 0x00000000

[ 2162.129517]  ffff88063c0fda18 0000000000000082 0000000000000000 ffff880600000000

[ 2162.138112]  0000000000013cc0 ffff88063e330000 ffff88063e3303b0 ffff88063c0fdfd8

[ 2162.146688]  ffff88063e3303b8 0000000000013cc0 ffff88063c0fc010 0000000000013cc0

[ 2162.155253] Call Trace:

[ 2162.158073]  [<ffffffff815d349d>] schedule_timeout+0x21d/0x300

[ 2162.164639]  [<ffffffff8104c8ec>] ? resched_task+0x2c/0x90

[ 2162.170886]  [<ffffffff8105f763>] ? try_to_wake_up+0xc3/0x410

[ 2162.177389]  [<ffffffff815d2436>] wait_for_common+0xd6/0x180

[ 2162.183852]  [<ffffffff8105fb05>] ? wake_up_process+0x15/0x20

[ 2162.190317]  [<ffffffff8105fab0>] ? default_wake_function+0x0/0x20

[ 2162.197304]  [<ffffffff815d25bd>] wait_for_completion+0x1d/0x20

[ 2162.203968]  [<ffffffff8107de18>] call_usermodehelper_exec+0xd8/0xe0

[ 2162.211111]  [<ffffffff814a3110>] ? parse_hw_handler+0xb0/0x240

[ 2162.217807]  [<ffffffff8107e060>] __request_module+0x190/0x210

[ 2162.224461]  [<ffffffff812e0c28>] ? sscanf+0x38/0x40

[ 2162.230054]  [<ffffffff814a3110>] parse_hw_handler+0xb0/0x240

[ 2162.236503]  [<ffffffff814a38c3>] multipath_ctr+0x83/0x1d0

[ 2162.242673]  [<ffffffff8149abd5>] ? dm_split_args+0x75/0x140

[ 2162.249079]  [<ffffffff8149b9af>] dm_table_add_target+0xff/0x250

[ 2162.255840]  [<ffffffff8149de3a>] table_load+0xca/0x2f0

[ 2162.261719]  [<ffffffff8149dd70>] ? table_load+0x0/0x2f0

[ 2162.267701]  [<ffffffff8149f0d5>] ctl_ioctl+0x1a5/0x240

[ 2162.273621]  [<ffffffff8149f183>] dm_ctl_ioctl+0x13/0x20

[ 2162.279592]  [<ffffffff81175245>] do_vfs_ioctl+0x95/0x3c0

[ 2162.285710]  [<ffffffff8109ae6b>] ? sys_futex+0x7b/0x170

[ 2162.291694]  [<ffffffff81175611>] sys_ioctl+0xa1/0xb0

[ 2162.297383]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b

[ 2162.304169] INFO: task iozone:1871 blocked for more than 120 seconds.

[ 2162.311407] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

[ 2162.320229] iozone          D ffff880c3bc21a90     0  1871   1869 0x00000000

[ 2162.328317]  ffff880c3e743e20 0000000000000086 0000000000000001 ffff880c00000000

[ 2162.336901]  0000000000013cc0 ffff880c3bc216e0 ffff880c3bc21a90 ffff880c3e743fd8

[ 2162.345415]  ffff880c3bc21a98 0000000000013cc0 ffff880c3e742010 0000000000013cc0

[ 2162.353887] Call Trace:

[ 2162.356650]  [<ffffffff8104c8ec>] ? resched_task+0x2c/0x90

[ 2162.362815]  [<ffffffff815d4ddd>] rwsem_down_failed_common+0xcd/0x170

[ 2162.370042]  [<ffffffff8118f480>] ? sync_one_sb+0x0/0x30

[ 2162.376121]  [<ffffffff815d4eb5>] rwsem_down_read_failed+0x15/0x17

[ 2162.383075]  [<ffffffff812e41a4>] call_rwsem_down_read_failed+0x14/0x30

[ 2162.390575]  [<ffffffff815d4207>] ? down_read+0x17/0x20

[ 2162.396501]  [<ffffffff811665e1>] iterate_supers+0x71/0xf0

[ 2162.402768]  [<ffffffff8118f4df>] sys_sync+0x2f/0x70

[ 2162.408360]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b

[ 2162.415159] INFO: task kpartx:1897 blocked for more than 120 seconds.

[ 2162.422493] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

[ 2162.431405] kpartx          D ffff88063d05df30     0  1897   1896 0x00000000

[ 2162.439440]  ffff88063c3a5b58 0000000000000082 0000000e3c3a5ac8 ffff880c00000000

[ 2162.448021]  0000000000013cc0 ffff88063d05db80 ffff88063d05df30 ffff88063c3a5fd8

[ 2162.456468]  ffff88063d05df38 0000000000013cc0 ffff88063c3a4010 0000000000013cc0

[ 2162.464962] Call Trace:

[ 2162.467724]  [<ffffffff8123dc85>] log_wait_commit+0xc5/0x150

[ 2162.474088]  [<ffffffff81086b50>] ? autoremove_wake_function+0x0/0x40

[ 2162.481319]  [<ffffffff815d4eee>] ? _raw_spin_lock+0xe/0x20

[ 2162.487577]  [<ffffffff811e6256>] ext3_sync_fs+0x66/0x70

[ 2162.493548]  [<ffffffff811ba7c1>] dquot_quota_sync+0x1c1/0x330

[ 2162.500107]  [<ffffffff81115391>] ? do_writepages+0x21/0x40

[ 2162.506415]  [<ffffffff8110ae8b>] ? __filemap_fdatawrite_range+0x5b/0x60

[ 2162.513947]  [<ffffffff8118f42c>] __sync_filesystem+0x3c/0x90

[ 2162.520514]  [<ffffffff8118f56b>] sync_filesystem+0x4b/0x70

[ 2162.526783]  [<ffffffff81166a85>] freeze_super+0x55/0x100

[ 2162.532896]  [<ffffffff811993b8>] freeze_bdev+0x98/0xe0

[ 2162.538819]  [<ffffffff81499001>] dm_suspend+0xa1/0x2e0

[ 2162.544705]  [<ffffffff8149ced9>] ? __get_name_cell+0x99/0xb0

[ 2162.551174]  [<ffffffff8149e2d0>] ? dev_suspend+0x0/0xb0

[ 2162.557160]  [<ffffffff8149e29b>] do_resume+0x17b/0x1b0

[ 2162.563082]  [<ffffffff8149e2d0>] ? dev_suspend+0x0/0xb0

[ 2162.569102]  [<ffffffff8149e365>] dev_suspend+0x95/0xb0

[ 2162.574987]  [<ffffffff8149e2d0>] ? dev_suspend+0x0/0xb0

[ 2162.581068]  [<ffffffff8149f0d5>] ctl_ioctl+0x1a5/0x240

[ 2162.586954]  [<ffffffff815d4eee>] ? _raw_spin_lock+0xe/0x20

[ 2162.593217]  [<ffffffff8149f183>] dm_ctl_ioctl+0x13/0x20

[ 2162.599190]  [<ffffffff81175245>] do_vfs_ioctl+0x95/0x3c0

[ 2162.605298]  [<ffffffff81175611>] sys_ioctl+0xa1/0xb0

[ 2162.610990]  [<ffffffff8100c042>] system_call_fastpath+0x16/0x1b

[ 2191.336354] Uhhuh. NMI received for unknown reason 21 on CPU 0.

[ 2191.343064] Do you have a strange power saving mode enabled?

[ 2191.349476] Kernel panic - not syncing: NMI: Not continuing

[ 2191.355753] Pid: 0, comm: swapper Not tainted 2.6.38-8-server #43

[ 2191.362593] Call Trace:

[ 2191.365380]  <NMI>  [<ffffffff815d2083>] ? panic+0x91/0x19e

[ 2191.371779]  [<ffffffff815d21f8>] ? printk+0x68/0x70

[ 2191.377381]  [<ffffffff815d6333>] ? default_do_nmi+0x1f3/0x200

[ 2191.383929]  [<ffffffff815d63c0>] ? do_nmi+0x80/0x90

[ 2191.389526]  [<ffffffff815d5b50>] ? nmi+0x20/0x30

[ 2191.394816]  [<ffffffff81332d74>] ? intel_idle+0x94/0x120

[ 2191.400897]  <<EOE>>  [<ffffffff814b3472>] ? cpuidle_idle_call+0xb2/0x1b0

[ 2191.408606]  [<ffffffff8100b067>] ? cpu_idle+0xb7/0x110

[ 2191.414497]  [<ffffffff815b7682>] ? rest_init+0x72/0x80

[ 2191.420367]  [<ffffffff81ae2c95>] ? start_kernel+0x374/0x37b

[ 2191.426780]  [<ffffffff81ae2346>] ? x86_64_start_reservations+0x131/0x135

[ 2191.434457]  [<ffffffff81ae244d>] ? x86_64_start_kernel+0x103/0x112


Thanks.

Peter




> 
> Thanks,
> Toshiyuki Okajima
> ---
>  fs/ext3/file.c          |   19 ++++++++++++-
>  fs/ext3/inode.c         |   71 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/inode.c         |    4 ++-
>  include/linux/ext3_fs.h |    1 +
>  4 files changed, 93 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/file.c b/fs/ext3/file.c
> index f55df0e..6d376ef 100644
> --- a/fs/ext3/file.c
> +++ b/fs/ext3/file.c
> @@ -52,6 +52,23 @@ static int ext3_release_file (struct inode * inode, struct file * filp)
>  	return 0;
>  }
>  
> +static const struct vm_operations_struct ext3_file_vm_ops = {
> +	.fault          = filemap_fault,
> +	.page_mkwrite   = ext3_page_mkwrite,
> +};
> +
> +static int ext3_file_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct address_space *mapping = file->f_mapping;
> +
> +	if (!mapping->a_ops->readpage)
> +		return -ENOEXEC;
> +	file_accessed(file);
> +	vma->vm_ops = &ext3_file_vm_ops;
> +	vma->vm_flags |= VM_CAN_NONLINEAR;
> +	return 0;
> +}
> +
>  const struct file_operations ext3_file_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read		= do_sync_read,
> @@ -62,7 +79,7 @@ const struct file_operations ext3_file_operations = {
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl	= ext3_compat_ioctl,
>  #endif
> -	.mmap		= generic_file_mmap,
> +	.mmap		= ext3_file_mmap,
>  	.open		= dquot_file_open,
>  	.release	= ext3_release_file,
>  	.fsync		= ext3_sync_file,
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 68b2e43..66c31dd 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -3496,3 +3496,74 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
>  
>  	return err;
>  }
> +
> +int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> +	struct page *page = vmf->page;
> +	loff_t size;
> +	unsigned long len;
> +	int ret = -EINVAL;
> +	void *fsdata;
> +	struct file *file = vma->vm_file;
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct address_space *mapping = inode->i_mapping;
> +
> +	/*
> +	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
> +	 * get i_mutex because we are already holding mmap_sem.
> +	 */
> +	down_read(&inode->i_alloc_sem);
> +	size = i_size_read(inode);
> +	if (page->mapping != mapping || size <= page_offset(page)
> +	   || !PageUptodate(page)) {
> +		/* page got truncated from under us? */
> +		goto out_unlock;
> +	}
> +	ret = 0;
> +	if (PageMappedToDisk(page))
> +		goto out_frozen;
> +
> +	if (page->index == size >> PAGE_CACHE_SHIFT)
> +		len = size & ~PAGE_CACHE_MASK;
> +	else
> +		len = PAGE_CACHE_SIZE;
> +
> +	lock_page(page);
> +	/*
> +	 * return if we have all the buffers mapped. This avoid
> +	 * the need to call write_begin/write_end which does a
> +	 * journal_start/journal_stop which can block and take
> +	 * long time
> +	 */
> +	if (page_has_buffers(page)) {
> +		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> +					buffer_unmapped)) {
> +			unlock_page(page);
> +out_frozen:
> +			vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> +			goto out_unlock;
> +		}
> +	}
> +	unlock_page(page);
> +	/*
> +	 * OK, we need to fill the hole... Do write_begin write_end
> +	 * to do block allocation/reservation.We are not holding
> +	 * inode.i__mutex here. That allow * parallel write_begin,
> +	 * write_end call. lock_page prevent this from happening
> +	 * on the same page though
> +	 */
> +	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
> +			len, AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
> +	if (ret < 0)
> +		goto out_unlock;
> +	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
> +			len, len, page, fsdata);
> +	if (ret < 0)
> +		goto out_unlock;
> +	ret = 0;
> +out_unlock:
> +	if (ret)
> +		ret = VM_FAULT_SIGBUS;
> +	up_read(&inode->i_alloc_sem);
> +	return ret;
> +}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f2fa5e8..44979ae 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5812,7 +5812,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	}
>  	ret = 0;
>  	if (PageMappedToDisk(page))
> -		goto out_unlock;
> +		goto out_frozen;
>  
>  	if (page->index == size >> PAGE_CACHE_SHIFT)
>  		len = size & ~PAGE_CACHE_MASK;
> @@ -5830,6 +5830,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
>  					ext4_bh_unmapped)) {
>  			unlock_page(page);
> +out_frozen:
> +			vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
>  			goto out_unlock;
>  		}
>  	}
> diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
> index 85c1d30..a0e39ca 100644
> --- a/include/linux/ext3_fs.h
> +++ b/include/linux/ext3_fs.h
> @@ -919,6 +919,7 @@ extern void ext3_get_inode_flags(struct ext3_inode_info *);
>  extern void ext3_set_aops(struct inode *inode);
>  extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		       u64 start, u64 len);
> +extern int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
>  
>  /* ioctl.c */
>  extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
