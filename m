From: Tao Ma <tao.ma@oracle.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync
 performance when using CFQ
Date: Mon, 28 Jun 2010 14:41:29 +0800
Message-ID: <4C284419.3000905@oracle.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>	<4C21D442.8080703@oracle.com>
	<4C22F316.3080009@oracle.com>
	<x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070603080802050506080407"
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        linux-ext4@vger.kernel.org, vgoyal@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------070603080802050506080407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jeff,

On 06/27/2010 09:48 PM, Jeff Moyer wrote:
> Tao Ma<tao.ma@oracle.com>  writes:
>
>> Hi Jeff,
>>
>> On 06/23/2010 05:30 PM, Tao Ma wrote:
>>> Hi Jeff,
>>>
>>> On 06/23/2010 05:34 AM, Jeff Moyer wrote:
>>>> Hi,
>>>>
>>>> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
>>>> far worse than that of deadline for enterprise class storage when dealing
>>>> with file sizes of 8MB or less. I used the following command line as a
>>>> representative test case:
>>>>
>>>> fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w
>>>> 4096 -F
>>>>
>>>> When run using the deadline I/O scheduler, an average of the first 5
>>>> numbers
>>>> will give you 448.4 files / second. CFQ will yield only 106.7. With
>>>> this patch series applied (and the two patches I sent yesterday), CFQ now
>>>> achieves 462.5 files / second.
>>> which 2 patches? Could you paste the link or the subject? Just want to
>>> make my test env like yours. ;)
>>> As Joel mentioned in another mail, ocfs2 also use jbd/jbd2, so I'd like
>>> to give it a try and give you some feedback about the test.
>> I am sorry to say that the patch make jbd2 locked up when I tested
>> fs_mark using ocfs2.
>> I have attached the log from my netconsole server. After I reverted
>> the patch [3/3], the box works again.
>
> I can't reproduce this, unfortunately.  Also, when building with the
> .config you sent me, the disassembly doesn't line up with the stack
> trace you posted.
>
> I'm not sure why yielding the queue would cause a deadlock.  The only
> explanation I can come up with is that I/O is not being issued.  I'm
> assuming that no other I/O will be completed to the file system in
> question.  Is that right?  Could you send along the output from sysrq-t?
yes, I just mounted it and begin the test, so there should be no 
outstanding I/O. So do you need me to setup another disk for test?
I have attached the sysrq output in sysrq.log. please check.

btw, I also met with a NULL pointer deference in cfq_yield. I have 
attached the null.log also. This seems to be related to the previous 
deadlock and happens when I try to remount the same volume after reboot 
and ocfs2 try to do some recovery.

Regards,
Tao

--------------070603080802050506080407
Content-Type: text/x-log;
 name="sysrq.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sysrq.log"

 SysRq : 
 Show State 
   task                        PC stack   pid father 
 init          R
   running task    
     0     1      0 0x00000000 
  ffff88013badb510
  0000000000000082
  ffffffff8271b020
  0000000001e0ef88
  
  0000000000000286
  ffffffff82050937
  0000000000000286
  ffffffff820507e7
  
  0000000000000286
  ffff88013badb510
  00000000004c4b3f
  ffff88013baddad8
  
 Call Trace: 
  [<ffffffff82050937>] ? __hrtimer_start_range_ns+0x12f/0x142 
  [<ffffffff820507e7>] ? hrtimer_try_to_cancel+0x90/0x9b 
  [<ffffffff822fc5c2>] ? schedule_hrtimeout_range_clock+0xc4/0xeb 
  [<ffffffff820503ee>] ? hrtimer_wakeup+0x0/0x22 
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffff820d053c>] ? do_select+0x46c/0x4ed 
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff820339ce>] ? __wake_up+0x30/0x44 
  [<ffffffffa00245fa>] ? journal_stop+0x20f/0x222 [jbd] 
  [<ffffffff821698f2>] ? number+0x121/0x223 
  [<ffffffffa0043d2e>] ? __ext3_journal_stop+0x1f/0x3d [ext3] 
  [<ffffffffa003dd48>] ? ext3_writeback_write_end+0x94/0xb7 [ext3] 
  [<ffffffff8216b769>] ? vsnprintf+0x3e4/0x421 
  [<ffffffff820d217d>] ? __d_lookup+0xb7/0xf6 
  [<ffffffff820ca799>] ? do_lookup+0x89/0x1e2 
  [<ffffffff820d164b>] ? dput+0x27/0x116 
  [<ffffffff820ccc4c>] ? link_path_walk+0x90a/0x930 
  [<ffffffff820d079e>] ? core_sys_select+0x1e1/0x2aa 
  [<ffffffff820cdc25>] ? user_path_at+0x52/0x79 
  [<ffffffff820c5d05>] ? cp_new_stat+0xea/0x101 
  [<ffffffff8203b7e7>] ? timespec_add_safe+0x37/0x66 
  [<ffffffff820d0bda>] ? sys_select+0x9a/0xc3 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
 kthreadd      S
  0000000000000000 
     0     2      0 0x00000000 
  ffff88013badae20
  0000000000000046
  ffff88013747b550
  00000000ffffffff
  
  ffffffff82003610
  0000000000000010
  0000000000000202
  0000000000000000
  
  0000000000000018
  ffff88013badae20
  ffff880128015ac8
  0000000000000000
  
 Call Trace: 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  [<ffffffff8204dcbf>] ? kthreadd+0x72/0xeb 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204dc4d>] ? kthreadd+0x0/0xeb 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 ksoftirqd/0   S
  0000000000000000 
     0     3      2 0x00000000 
  ffff88013bada730
  0000000000000046
  ffff88013bae8e60
  0000000000013640
  
  ffff88013bada730
  0000000000000000
  ffffffff8272bbe0
  ffffffff822fb8de
  
  ffff88013badb510
  0000000000000000
  ffffffff82791c00
  ffff88013baddd88
  
 Call Trace: 
  [<ffffffff822fb8de>] ? schedule+0x616/0x6c4 
  [<ffffffff8203c2a6>] ? run_ksoftirqd+0x0/0x116 
  [<ffffffff8203c2ed>] ? run_ksoftirqd+0x47/0x116 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 migration/0   S
  0000000000000000 
     0     4      2 0x00000000 
  ffff88013bada040
  0000000000000046
  ffff88013764cea0
  000000008205d592
  
  000000033badb510
  ffff88013abbfe68
  ffffffff820651c6
  ffff88013abbfe70
  
  0000000000000282
  ffff880001e0f000
  ffffffff820651c6
  ffff88013abbfed8
  
 Call Trace: 
  [<ffffffff820651c6>] ? stop_machine_cpu_stop+0x0/0x8f 
  [<ffffffff820651c6>] ? stop_machine_cpu_stop+0x0/0x8f 
  [<ffffffff82065696>] ? cpu_stopper_thread+0x119/0x13f 
  [<ffffffff8202d2b5>] ? finish_task_switch+0x33/0x80 
  [<ffffffff822fb8de>] ? schedule+0x616/0x6c4 
  [<ffffffff8206557d>] ? cpu_stopper_thread+0x0/0x13f 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 watchdog/0    R
   running task    
     0     5      2 0x00000000 
  ffff88013bae9550
  0000000000000046
  ffffffff8271b020
  0000000000000086
  
  01ff88013bae9550
  ffffffff82051a4d
  0000000000000286
  0000000000000286
  
  000000000000f070
  ffff88013bae9550
  0000000000000000
  ffff88013baddd98
  
 Call Trace: 
  [<ffffffff82051a4d>] ? sched_clock_local+0x9/0x6c 
  [<ffffffff8206f29a>] ? watchdog+0x0/0x9e 
  [<ffffffff8206f2e9>] ? watchdog+0x4f/0x9e 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 events/0      R
   running task    
     0     6      2 0x00000000 
  ffff88013bae8e60
  0000000000000046
  ffff88013b032ab0
  0000000082042340
  
  ffff88013baf1e90
  ffff880001e16318
  0000000000000001
  ffffffff8204dff0
  
  0000000000000246
  ffff88013baf1ef8
  ffffffff82747420
  ffff880001e16300
  
 Call Trace: 
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff821dc54f>] ? console_callback+0x0/0xf5 
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 khelper       S
  ffffffff82049cae 
     0     7      2 0x00000000 
  ffff88013bae8770
  0000000000000046
  ffff88013747b550
  0000000000000000
  
  ffff88013baf3e90
  ffff880001e16398
  0000000000000001
  ffffffff8204dff0
  
  ffff880001e16380
  ffff88013baf3ef8
  ffff88012f9872c0
  ffff880001e16380
  
 Call Trace: 
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff82049cae>] ? __call_usermodehelper+0x0/0x6f 
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 async/mgr     S
  0000000000000000 
     0    45      2 0x00000000 
  ffff88013bb62970
  0000000000000046
  ffff8801374be9b0
  000000008202e0e1
  
  ffffffff8272bbe0
  000000008202d2b5
  0000000000000003
  0000000000013640
  
  0000000000000282
  0000000000000001
  0000000000000001
  ffff88013badddb8
  
 Call Trace: 
  [<ffffffff82052a50>] ? async_manager_thread+0x0/0xe8 
  [<ffffffff82052b12>] ? async_manager_thread+0xc2/0xe8 
  [<ffffffff8202e0f3>] ? default_wake_function+0x0/0x9 
  [<ffffffff82052a50>] ? async_manager_thread+0x0/0xe8 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 sync_supers   R
   running task    
     0   153      2 0x00000000 
  ffff88013b048040
  0000000000000046
  ffffffff8271b020
  0000000000000000
  
  ffffffff8272bbe0
  ffffffff822fb8de
  ffff88013badb510
  0000000082027cc9
  
  000000033b093610
  ffff88013b095ef8
  0000000000000000
  ffff88013baddda8
  
 Call Trace: 
  [<ffffffff822fb8de>] ? schedule+0x616/0x6c4 
  [<ffffffff820a1e15>] ? bdi_sync_supers+0x0/0x54 
  [<ffffffff820a1e54>] ? bdi_sync_supers+0x3f/0x54 
  [<ffffffff820a1e15>] ? bdi_sync_supers+0x0/0x54 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 bdi-default   R
   running task    
     0   155      2 0x00000000 
  ffff88013b048e20
  0000000000000046
  ffffffff8271b020
  00000000ffffffff
  
  ffff88013b08ddf0
  00000000fffda363
  0000000000000286
  ffffffff820420c2
  
  0000000000000286
  ffffffff82894dc0
  ffffffff82894dc0
  00000000fffdb6eb
  
 Call Trace: 
  [<ffffffff820420c2>] ? try_to_del_timer_sync+0xa4/0xaf 
  [<ffffffff822fbe0d>] ? schedule_timeout+0x1ba/0x1e0 
  [<ffffffff82042139>] ? process_timeout+0x0/0x5 
  [<ffffffff820a246f>] ? bdi_forker_task+0x160/0x295 
  [<ffffffff822fb8de>] ? schedule+0x616/0x6c4 
  [<ffffffff820a230f>] ? bdi_forker_task+0x0/0x295 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 kblockd/0     S
  ffffffff8216160d 
     0   156      2 0x00000000 
  ffff88013b049510
  0000000000000046
  ffff88013747b550
  000000003a1caa20
  
  ffff88013b081e90
  ffff880001e16498
  0000000000000001
  ffffffff8204dff0
  
  ffff88013a1caa20
  ffff88013b081ef8
  ffff88013a2a5b48
  ffff880001e16480
  
 Call Trace: 
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff8216160d>] ? cfq_kick_queue+0x0/0x3a 
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 kacpid        S
  ffffffff82198b60 
     0   158      2 0x00000000 
  ffff88013b03caf0
  0000000000000046
  ffff88013b03d1e0
  000000008202cfe7
  
  ffff88013bbcfe90
  ffff880001e16518
  0000000000000001
  ffffffff8204dff0
  
  ffffffff8272bbe0
  ffff88013bbcfef8
  ffff88013bbb6620
  ffff880001e16500
  
 Call Trace: 
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff82198b60>] ? bind_to_cpu0+0x0/0x22 
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 kacpi_notify  S
  ffffffff82198b60 
     0   159      2 0x00000000 
  ffff88013b03d1e0
  0000000000000046
  ffff88013b03d8d0
  000000008202cfe7
  
  ffff88013b021e90
  ffff880001e16598
  0000000000000001
  ffffffff8204dff0
  
  ffffffff8272bbe0
  ffff88013b021ef8
  ffff88013bbb6620
  ffff880001e16580
  
 Call Trace: 
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff82198b60>] ? bind_to_cpu0+0x0/0x22 
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 kacpi_hotplug S
  ffffffff82198b60 
     0   160      2 0x00000000 
  ffff88013b03d8d0
  0000000000000046
  ffff88013badb510
  000000008202cfe7
  
  ffff88013b023e90
  ffff880001e16618
  0000000000000001
  ffffffff8204dff0
  
  ffffffff8272bbe0
  ffff88013b023ef8
  ffff88013bbb6620
  ffff880001e16600
  
 Call Trace: 
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff82198b60>] ? bind_to_cpu0+0x0/0x22 
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 khubd         S
  0000000000000001 
     0   245      2 0x00000000 
  ffff88013b052770
  0000000000000046
  ffff88013bb63060
  0000000000000004
  
  ffff88013bbd9e70
  ffffffff82752610
  0000000000000001
  ffffffff8204dff0
  
  ffff88013a107230
  ffffffff82752600
  0000000000000000
  ffff88013a107200
  
 Call Trace: 
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff8221b6c0>] ? hub_thread+0xcee/0xddc 
  [<ffffffff8202d2b5>] ? finish_task_switch+0x33/0x80 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8221a9d2>] ? hub_thread+0x0/0xddc 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 kseriod       S
  ffff88013b0ab5c0 
     0   248      2 0x00000000 
  ffff88013b088100
  0000000000000046
  ffff88013bb63060
  00000000821f3499
  
  ffff88013b0b1e90
  ffffffff82753c80
  0000000000000001
  ffffffff8204dff0
  
 Call Trace: 
  [<ffffffff8222cc37>] ? serio_thread+0x0/0x2c5 
  0000000000000000 
  ffffffff820420c2
  ffffffff82894dc0
  [<ffffffff82042139>] ? process_timeout+0x0/0x5 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
 kswapd0       S
  ffffffff8204dff0
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff8209b521>] ? kswapd+0x0/0x591 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
     0   305      2 0x00000000 
  
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  0000000000000001
 Call Trace: 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  0000000000000000
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  ffff880001e1ab98
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  0000000000000000 
  
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  ffff88013bb4cfe0
 Call Trace: 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  ffff88013a2a5010
  [<ffffffffa0064d38>] ? scsi_error_handler+0x0/0x576 [scsi_mod] 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  0000000000000293
  ffff88013a342800
  [<ffffffffa0064d38>] ? scsi_error_handler+0x0/0x576 [scsi_mod] 
  ffff88013b053550
  ffff88013a342000
  [<ffffffffa0064d38>] ? scsi_error_handler+0x0/0x576 [scsi_mod] 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  000000003a383e18
  00000000fffdb6c4
  [<ffffffff820a224d>] ? bdi_start_fn+0x0/0xc2 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  0000000000000046
  0000000000000000
  [<ffffffff822fbe0d>] ? schedule_timeout+0x1ba/0x1e0 
  [<ffffffff8204de16>] ? wake_up_bit+0x11/0x22 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  0000000000000400
  ffffffff82894dc0
  [<ffffffff820a224d>] ? bdi_start_fn+0x0/0xc2 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  ffff88013b0887f0
  0000000000000046
 Call Trace: 
  [<ffffffff8204de16>] ? wake_up_bit+0x11/0x22 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
     0   555      2 0x00000000 
  0000000000000286
  [<ffffffff82042139>] ? process_timeout+0x0/0x5 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  ffff88013baf9590
  
  [<ffffffff820a224d>] ? bdi_start_fn+0x0/0xc2 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
 flush-1:6     R
  0000000000000000
  [<ffffffff822fbe0d>] ? schedule_timeout+0x1ba/0x1e0 
  [<ffffffff8204de16>] ? wake_up_bit+0x11/0x22 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  0000000000000046
  00000000fffdb6cf
  [<ffffffff820a224d>] ? bdi_start_fn+0x0/0xc2 
  [<ffffffff820a22b0>] ? bdi_start_fn+0x63/0xc2 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 flush-1:8     R
   running task    
  000000003a3cfe18
  
  [<ffffffff822fbe0d>] ? schedule_timeout+0x1ba/0x1e0 
  [<ffffffff820a22b0>] ? bdi_start_fn+0x63/0xc2 
 flush-1:9     R
  0000000000000000
  [<ffffffff822fbe0d>] ? schedule_timeout+0x1ba/0x1e0 
  [<ffffffff820dc772>] ? bdi_writeback_task+0x79/0x104 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  000000003a3d5e18
  00000000fffdb6d6
  [<ffffffff822fbe0d>] ? schedule_timeout+0x1ba/0x1e0 
  [<ffffffff820a22b0>] ? bdi_start_fn+0x63/0xc2 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  0000000000000000
  00000000fffdb6d6
  [<ffffffff820a224d>] ? bdi_start_fn+0x0/0xc2 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  0000000000000046
  0000000000000000
 Call Trace: 
  [<ffffffff8204de16>] ? wake_up_bit+0x11/0x22 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  00000000fffda355
  
  [<ffffffff820a22b0>] ? bdi_start_fn+0x63/0xc2 
   running task    
  
  [<ffffffff820dc772>] ? bdi_writeback_task+0x79/0x104 
   running task    
  [<ffffffff822fbe0d>] ? schedule_timeout+0x1ba/0x1e0 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  ffff88013a3ee590
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  ffff88013b01c340
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  0000000000000000
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff82133275>] ? cap_file_permission+0x0/0x3 
  [<ffffffff822ffed3>] ? do_page_fault+0x324/0x346 
     0   638      2 0x00000000 
  
 Call Trace: 
  [<ffffffff822fbe0d>] ? schedule_timeout+0x1ba/0x1e0 
  [<ffffffff82042139>] ? process_timeout+0x0/0x5 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  ffff88013b027160
  ffff88013abe37c0
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  0000000000000046
  
 Call Trace: 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  ffff88013747ae60
  ffff880001e1b380
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  ffffffff8204dff0
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  
 Call Trace: 
  [<ffffffffa002907d>] ? kjournald+0x0/0x1f4 [jbd] 
  0000000000000000 
  
  
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  
  
  [<ffffffffa0398550>] ? process_req+0x0/0x12d [ib_addr] 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  0000000000000046
  0000000000000001
 Call Trace: 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  0000000000000000 
  
  
  [<ffffffff8204af28>] ? worker_thread+0x93/0x1e4 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  
  
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
     0  2512      2 0x00000000 
  
 Call Trace: 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
  0000000000000286
 Call Trace: 
  [<ffffffff820507e7>] ? hrtimer_try_to_cancel+0x90/0x9b 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  ffffffff82050937
 Call Trace: 
  [<ffffffff82050937>] ? __hrtimer_start_range_ns+0x12f/0x142 
  [<ffffffff820507e7>] ? hrtimer_try_to_cancel+0x90/0x9b 
  [<ffffffff822fc5c2>] ? schedule_hrtimeout_range_clock+0xc4/0xeb 
  [<ffffffff820503ee>] ? hrtimer_wakeup+0x0/0x22 
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff8216b8b0>] ? snprintf+0x44/0x4c 
  [<ffffffff821072bd>] ? proc_flush_task+0x130/0x25a 
  [<ffffffff82002807>] ? system_call_after_swapgs+0x17/0x65 
  
  
  [<ffffffff820507e7>] ? hrtimer_try_to_cancel+0x90/0x9b 
  [<ffffffff820d053c>] ? do_select+0x46c/0x4ed 
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff822642d5>] ? sock_aio_write+0xf5/0x10d 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  ffffffff8289a010
  [<ffffffff82058213>] ? futex_wait_queue_me+0xb6/0xd1 
  [<ffffffff8209167e>] ? __generic_file_aio_write+0x338/0x3a2 
  [<ffffffff820e01b3>] ? vfs_statfs+0x5b/0x76 
  0000000000000086
  [<ffffffff820507e7>] ? hrtimer_try_to_cancel+0x90/0x9b 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff820c2986>] ? do_sync_read+0xab/0xeb 
  ffff88013764cea0
 Call Trace: 
  [<ffffffff8204dd48>] ? bit_waitqueue+0x10/0xa0 
  [<ffffffff821524a5>] ? elv_insert+0x10e/0x1c0 
  [<ffffffff82160575>] ? cfq_close_cooperator+0xd3/0x163 
  [<ffffffff822fb8de>] ? schedule+0x616/0x6c4 
     0  3158      1 0x00000080 
  
  [<ffffffff8210d843>] ? kmsg_read+0x44/0x4e 
  [<ffffffff820c342d>] ? sys_read+0x45/0x6e 
  ffff88013bb035d0
  
  [<ffffffff82299263>] ? ip_cork_release+0x2e/0x3b 
  [<ffffffff820cff0e>] ? do_sys_poll+0x2ac/0x37e 
  [<ffffffff82264670>] ? sock_sendmsg+0xc0/0xdb 
  [<ffffffff820d0029>] ? sys_poll+0x49/0xa9 
  
  
  [<ffffffff822fc53a>] ? schedule_hrtimeout_range_clock+0x3c/0xeb 
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff822d8f16>] ? unix_dgram_sendmsg+0x3eb/0x473 
  [<ffffffff820d079e>] ? core_sys_select+0x1e1/0x2aa 
  [<ffffffff82266086>] ? sys_sendto+0xf3/0x127 
  [<ffffffff820d0bda>] ? sys_select+0x9a/0xc3 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
 rpciod/0      S
  0000000000000000 
  ffff88012f42be90
 Call Trace: 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  ffffffff8271b020
  ffffffff82894dc0
  [<ffffffff82042139>] ? process_timeout+0x0/0x5 
  [<ffffffff8202e0f3>] ? default_wake_function+0x0/0x9 
  ffff88013764cea0
  
  [<ffffffff82031caa>] ? check_preempt_wakeup+0xed/0x14b 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  0000000000000286
  [<ffffffff822fc53a>] ? schedule_hrtimeout_range_clock+0x3c/0xeb 
  [<ffffffff8226a8fa>] ? skb_queue_tail+0x17/0x3e 
  [<ffffffff822634e4>] ? sock_ioctl+0x207/0x215 
  
  [<ffffffff822fbc74>] ? schedule_timeout+0x21/0x1e0 
  [<ffffffff82091f4a>] ? filemap_fault+0xb6/0x310 
     0  3402      2 0x00000080 
  
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  ffff88012faafe98
  [<ffffffffa023f268>] ? rfcomm_run+0x190/0x1198 [rfcomm] 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffff82054c34>] ? ktime_get_ts+0x68/0xb1 
  [<ffffffff820d079e>] ? core_sys_select+0x1e1/0x2aa 
     0  3472      1 0x00000080 
  
  [<ffffffff820503ee>] ? hrtimer_wakeup+0x0/0x22 
     0  3476      1 0x00000080 
  
  
  [<ffffffff820cff0e>] ? do_sys_poll+0x2ac/0x37e 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff822d8982>] ? unix_wait_for_peer+0x9e/0xaa 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8226a8fa>] ? skb_queue_tail+0x17/0x3e 
  [<ffffffff822d8f16>] ? unix_dgram_sendmsg+0x3eb/0x473 
  [<ffffffff820a5a3e>] ? handle_mm_fault+0x3bb/0x7b3 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  00007f92897f2010
 Call Trace: 
  [<ffffffff820451e1>] ? __dequeue_signal+0x15/0x11b 
  [<ffffffff820c3ba4>] ? fput+0x1b0/0x1e1 
  ffff88013baf8ea0
  ffff88012fadbb88
  [<ffffffff82058324>] ? futex_wait+0xf6/0x230 
  [<ffffffff820598ac>] ? do_futex+0xa4/0xb1c 
  [<ffffffff820a5dd7>] ? handle_mm_fault+0x754/0x7b3 
     0  3504      1 0x00000080 
  
 Call Trace: 
  [<ffffffff820503ee>] ? hrtimer_wakeup+0x0/0x22 
  [<ffffffff8202518b>] ? flush_tlb_page+0x4f/0x6e 
  [<ffffffff8205a43f>] ? sys_futex+0x11b/0x139 
  000000003abe30c0
  
  [<ffffffff8202d2d0>] ? finish_task_switch+0x4e/0x80 
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff82095445>] ? get_page_from_freelist+0x425/0x577 
  [<ffffffff820a3c2a>] ? __do_fault+0x3a4/0x3e5 
  [<ffffffff822ffed3>] ? do_page_fault+0x324/0x346 
  ffff88013baf8ea0
  0000000000000000
  [<ffffffff82074a5c>] ? delayacct_end+0x74/0x7f 
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffff820598d2>] ? do_futex+0xca/0xb1c 
  [<ffffffff820c1708>] ? __dentry_open+0x18d/0x278 
  [<ffffffff8202d2b5>] ? finish_task_switch+0x33/0x80 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  000280da00000010
 Call Trace: 
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff82090947>] ? find_get_page+0x18/0x78 
  [<ffffffff820a5a3e>] ? handle_mm_fault+0x3bb/0x7b3 
     0  3544      1 0x00000080 
  
  [<ffffffff822fd150>] ? _raw_spin_lock_bh+0x9/0x1f 
  [<ffffffff8229f0d8>] ? inet_csk_accept+0xb6/0x205 
  [<ffffffff8206bf98>] ? audit_syscall_entry+0x1bd/0x1e8 
  
  00000000004c4b3f
  [<ffffffff822fc5c2>] ? schedule_hrtimeout_range_clock+0xc4/0xeb 
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff8209583e>] ? __alloc_pages_nodemask+0x104/0x568 
  [<ffffffff820d079e>] ? core_sys_select+0x1e1/0x2aa 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  ffff88013a08a8f0
  
 Call Trace: 
  [<ffffffff822fc53a>] ? schedule_hrtimeout_range_clock+0x3c/0xeb 
  [<ffffffffa003c0d0>] ? ext3_get_blocks_handle+0x9b/0x8df [ext3] 
  [<ffffffff82090947>] ? find_get_page+0x18/0x78 
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffffa003dd48>] ? ext3_writeback_write_end+0x94/0xb7 [ext3] 
  [<ffffffff820d079e>] ? core_sys_select+0x1e1/0x2aa 
  [<ffffffff8202511d>] ? flush_tlb_mm+0x51/0x70 
     0  3615      1 0x00000080 
  
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffffa003dd48>] ? ext3_writeback_write_end+0x94/0xb7 [ext3] 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  ffff88012fb99ad8
  [<ffffffff822fc53a>] ? schedule_hrtimeout_range_clock+0x3c/0xeb 
  [<ffffffff8226a8fa>] ? skb_queue_tail+0x17/0x3e 
     0  3657      1 0x00000080 
 Call Trace: 
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff820d910d>] ? seq_printf+0x67/0x8f 
  ffff88013a08b6d0
 Call Trace: 
  0000000000000286
  [<ffffffff82095445>] ? get_page_from_freelist+0x425/0x577 
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff82090947>] ? find_get_page+0x18/0x78 
  [<ffffffff822ffed3>] ? do_page_fault+0x324/0x346 
  ffffffff82050937
  [<ffffffff822fc66f>] ? do_nanosleep+0x73/0xa7 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  ffffffff82050937
 Call Trace: 
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffff8204de16>] ? wake_up_bit+0x11/0x22 
  [<ffffffffa0040503>] ? ext3_find_entry+0x4eb/0x586 [ext3] 
  [<ffffffff820d079e>] ? core_sys_select+0x1e1/0x2aa 
 atd           S
  ffffffff822ffed3
  
  [<ffffffff82050937>] ? __hrtimer_start_range_ns+0x12f/0x142 
  [<ffffffff822ffed3>] ? do_page_fault+0x324/0x346 
  [<ffffffff822fc66f>] ? do_nanosleep+0x73/0xa7 
  [<ffffffff820509ea>] ? hrtimer_nanosleep+0x86/0xf1 
  [<ffffffff820503ee>] ? hrtimer_wakeup+0x0/0x22 
  [<ffffffff82050aab>] ? sys_nanosleep+0x56/0x6c 
  0000000001e0ef88
  
  [<ffffffff82050937>] ? __hrtimer_start_range_ns+0x12f/0x142 
  [<ffffffff820cff0e>] ? do_sys_poll+0x2ac/0x37e 
  [<ffffffff820598d2>] ? do_futex+0xca/0xb1c 
  [<ffffffff820a5a3e>] ? handle_mm_fault+0x3bb/0x7b3 
  [<ffffffff820d0029>] ? sys_poll+0x49/0xa9 
  0000000001e0ef88
  
  [<ffffffff822fc5c2>] ? schedule_hrtimeout_range_clock+0xc4/0xeb 
  [<ffffffff820cff0e>] ? do_sys_poll+0x2ac/0x37e 
  
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  0000000000000082
 Call Trace: 
  [<ffffffff822643ee>] ? sock_aio_read+0x101/0x119 
  [<ffffffff8216ca4e>] ? __strncpy_from_user+0x28/0x41 
     0  3818      1 0x00000080 
  0000000000000003
  [<ffffffff822fc53a>] ? schedule_hrtimeout_range_clock+0x3c/0xeb 
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff82164448>] ? cpumask_any_but+0x27/0x33 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  0000000000000001
  0000000000000003
  [<ffffffff822fc53a>] ? schedule_hrtimeout_range_clock+0x3c/0xeb 
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff82164448>] ? cpumask_any_but+0x27/0x33 
  [<ffffffff820a5dd7>] ? handle_mm_fault+0x754/0x7b3 
  [<ffffffff820c2de6>] ? do_readv_writev+0x182/0x197 
  [<ffffffff820d0029>] ? sys_poll+0x49/0xa9 
  
 Call Trace: 
  [<ffffffff8223449a>] ? evdev_read+0xc7/0x200 
 hald-addon-ke S
  
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  ffff88013b032ab0
  ffff88013a5fa000
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
   running task    
  
  
  [<ffffffff820503ee>] ? hrtimer_wakeup+0x0/0x22 
     0  3890      1 0x00000080 
  
  
  [<ffffffff820507e7>] ? hrtimer_try_to_cancel+0x90/0x9b 
  [<ffffffff822fc5c2>] ? schedule_hrtimeout_range_clock+0xc4/0xeb 
  [<ffffffff820503ee>] ? hrtimer_wakeup+0x0/0x22 
  [<ffffffff820cfbc1>] ? poll_schedule_timeout+0x43/0x60 
  [<ffffffff820cff0e>] ? do_sys_poll+0x2ac/0x37e 
  [<ffffffff820a0f11>] ? zone_statistics+0x3a/0x5b 
  [<ffffffff820a5a3e>] ? handle_mm_fault+0x3bb/0x7b3 
  [<ffffffff820d0029>] ? sys_poll+0x49/0xa9 
 Call Trace: 
  [<ffffffff820585e1>] ? futex_wake+0xf2/0x104 
  [<ffffffff820d6dc9>] ? mntput_no_expire+0x1c/0x97 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  0000000000000286
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff820a3c2a>] ? __do_fault+0x3a4/0x3e5 
  [<ffffffff820d0029>] ? sys_poll+0x49/0xa9 
  
  [<ffffffff820d0867>] ? __pollwait+0x0/0xd9 
  [<ffffffff82090947>] ? find_get_page+0x18/0x78 
  [<ffffffff820d0bda>] ? sys_select+0x9a/0xc3 
  
  [<ffffffff8204df83>] ? prepare_to_wait_exclusive+0x35/0x6d 
  [<ffffffff822d9652>] ? unix_accept+0x54/0x101 
  
  
  [<ffffffff820503ee>] ? hrtimer_wakeup+0x0/0x22 
  [<ffffffff820d0940>] ? pollwake+0x0/0x54 
  [<ffffffff82091f4a>] ? filemap_fault+0xb6/0x310 
  [<ffffffff8203b7e7>] ? timespec_add_safe+0x37/0x66 
  ffff88013a475060
  ffff88012f6c7eb8
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff820ce623>] ? sys_fcntl+0x2f4/0x48d 
  
 Call Trace: 
  [<ffffffff8216c84d>] ? __put_user_4+0x1d/0x30 
 saslauthd     S
  ffffffff8204dff0
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  
  
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffff820f2070>] ? fcntl_setlk+0x1a6/0x25f 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8216c84d>] ? __put_user_4+0x1d/0x30 
  [<ffffffff820ce623>] ? sys_fcntl+0x2f4/0x48d 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  
  
  [<ffffffff82050937>] ? __hrtimer_start_range_ns+0x12f/0x142 
  [<ffffffff82050aab>] ? sys_nanosleep+0x56/0x6c 
  ffff88013a08a200
  ffff88013bb58240
  [<ffffffff822ffed3>] ? do_page_fault+0x324/0x346 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  0000001300000000
  [<ffffffff820a3c2a>] ? __do_fault+0x3a4/0x3e5 
  [<ffffffff821ce324>] ? n_tty_read+0x3e9/0x6b2 
  [<ffffffff821caf36>] ? tty_read+0x6f/0xbb 
     0  4071      1 0x00000080 
  ffff8801374da800
  [<ffffffff822fbc74>] ? schedule_timeout+0x21/0x1e0 
  [<ffffffff821cfe10>] ? tty_ldisc_ref_wait+0x10/0x91 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  00000000821db81b
  ffff88012f758800
  [<ffffffff8204ac92>] ? flush_work+0xe/0x7e 
  [<ffffffff821caf36>] ? tty_read+0x6f/0xbb 
  [<ffffffff820c342d>] ? sys_read+0x45/0x6e 
  
  
  [<ffffffff820420c2>] ? try_to_del_timer_sync+0xa4/0xaf 
  [<ffffffff821cfe10>] ? tty_ldisc_ref_wait+0x10/0x91 
  [<ffffffff8200286b>] ? system_call_fastpath+0x16/0x1b 
  0000001300000000
 Call Trace: 
  [<ffffffff8204ac92>] ? flush_work+0xe/0x7e 
  [<ffffffff821cfe10>] ? tty_ldisc_ref_wait+0x10/0x91 
     0  4085   4069 0x00000080 
  
  [<ffffffff82039518>] ? session_of_pgrp+0xe/0x37 
  [<ffffffff8203a215>] ? do_wait+0x1ba/0x20e 
     0  4134      2 0x00000080 
  
  [<ffffffffa04954dc>] ? ocfs2_truncate_log_worker+0x0/0x140 [ocfs2] 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 o2quot/0      S
 Call Trace: 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
 jbd2/sda11-15 R
   running task    
  
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  ffff88013bb6f0a0
  0000000000000000
  [<ffffffff8203a2f9>] ? sys_wait4+0x90/0xab 
  ffffffffa00bac05
  [<ffffffff82034d46>] ? __cond_resched+0x1d/0x26 
  [<ffffffff822ffd62>] ? do_page_fault+0x1b3/0x346 
  [<ffffffff82029bf1>] ? update_curr+0x77/0xe4 
  [<ffffffffa005fcde>] ? scsi_done+0x0/0x41 [scsi_mod] 
  [<ffffffff82030fa5>] ? enqueue_task_fair+0x213/0x23b 
  [<ffffffffa02fbdb3>] ? jbd2_journal_start+0x90/0xbf [jbd2] 
  [<ffffffff820911fb>] ? filemap_write_and_wait_range+0x3b/0x4a 
   .sysctl_sched_features                   : 15471 
   .nr_uninterruptible            : 0 
   .cpu_load[1]                   : 55559 
   .sched_goidle                  : 11896 
  
   .max_vruntime                  : 19789.211500 
   .nr_spread_over                : 9 
   .rt_throttled                  : 0 
  
 ---------------------------------------------------------------------------------------------------------- 
  
     19786.211500         0.102040    152126.157713
     19786.211500         0.184139    152631.345425
  
  
     19786.211500         0.048046    147560.772980
     19786.211500         0.051120    147561.204512
     19786.211500         0.047465    147561.197120
  
 last message repeated 3 times
     19786.211500         0.036472    147561.895980
  
          iscsid  2520     19786.211500       494   110 
  
  
     19786.211500         0.536960    117158.277565
     19786.211500         0.015188    120124.852286
          python  3549     19786.211500        24   120 
        sendmail  3657     19786.211500        27   120 
  
  
     19786.211500        18.205067    106358.280463
     19786.211500         1.547554    105330.629658
     19786.211500         1.231707    105331.170248
   jbd2/sda11-15  4137     89173.901514         2   120 

--------------070603080802050506080407
Content-Type: text/x-log;
 name="null.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="null.log"

 BUG: unable to handle kernel 
 NULL pointer dereference
  at (null) 
 IP:
  [<ffffffff82161537>] cfq_yield+0x5f/0x135 
 PGD 1342ff067 
 PUD 1342ee067 
 PMD 0 
  
 Oops: 0002 [#1] 
 SMP 
  
 last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:04:02.0/irq 
 CPU 0 
  
 Modules linked in:
  ocfs2
  jbd2
  ocfs2_nodemanager
  configfs
  ocfs2_stackglue
  netconsole
  autofs4
  hidp
  rfcomm
  l2cap
  crc16
  bluetooth
  rfkill
  sunrpc
  ib_iser
  rdma_cm
  ib_cm
  iw_cm
  ib_sa
  ib_mad
  ib_core
  ib_addr
  ipv6
  iscsi_tcp
  libiscsi_tcp
  libiscsi
  scsi_transport_iscsi
  dm_mirror
  dm_region_hash
  dm_log
  dm_multipath
  dm_mod
  video
  output
  sbs
  sbshc
  battery
  acpi_memhotplug
  ac
  lp
  sg
  dcdbas
  sr_mod
  cdrom
  option
  usb_wwan
  usbserial
  serio_raw
  parport_pc
  parport
  rtc_cmos
  rtc_core
  rtc_lib
  snd_hda_codec_analog
  tpm_tis
  tpm
  tpm_bios
  button
  snd_hda_intel
  snd_hda_codec
  snd_seq_dummy
  tg3
  snd_seq_oss
  snd_seq_midi_event
  snd_seq
  e1000
  snd_seq_device
  libphy
  snd_pcm_oss
  snd_mixer_oss
  i2c_i801
  i2c_core
  snd_pcm
  snd_timer
  snd
  soundcore
  snd_page_alloc
  shpchp
  pcspkr
  ata_piix
  libata
  sd_mod
  scsi_mod
  ext3
  jbd
  ehci_hcd
  ohci_hcd
  uhci_hcd
  [last unloaded: microcode]
  
  
 Pid: 4130, comm: ocfs2_wq Not tainted 2.6.35-rc3+ #5 0MM599/OptiPlex 745                  
 RIP: 0010:[<ffffffff82161537>] 
  [<ffffffff82161537>] cfq_yield+0x5f/0x135 
 RSP: 0018:ffff880123061c60  EFLAGS: 00010246 
 RAX: 0000000000000000 RBX: ffff88012c2b5ea8 RCX: ffff88012c3a30d0 
 RDX: ffff8801255953d8 RSI: 0000000000000000 RDI: ffff88013a2a3800 
 RBP: ffff88012c3ba770 R08: ffff88012c3a30b8 R09: ffff880001e136a0 
 R10: ffff88012c3bb598 R11: ffff88012c3a30c8 R12: ffff88013a2a3800 
 R13: ffff88013a1d0a20 R14: 0000000000000000 R15: 0000000000000000 
 FS:  0000000000000000(0000) GS:ffff880001e00000(0000) knlGS:0000000000000000 
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
 CR2: 0000000000000000 CR3: 00000001342da000 CR4: 00000000000006f0 
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
 Process ocfs2_wq (pid: 4130, threadinfo ffff880123060000, task ffff88013ab38240) 
 Stack: 
  ffff88012c3a3000
  ffff88012c3a3024
  ffff88013414e580
  ffff8801255953d8
  
 
  0000000000000003
  ffffffffa030e260
  ffff88012c3a3000
  0000000000000003
  
 
  ffff8801255953d8
  0000000000000003
  0000000000000282
  ffffffffa030db11
  
 Call Trace: 
  [<ffffffffa030e260>] ? jbd2_log_wait_commit+0x3c/0x10e [jbd2] 
  [<ffffffffa030db11>] ? __jbd2_log_start_commit+0x2c/0x33 [jbd2] 
  [<ffffffffa030856b>] ? jbd2_journal_stop+0x1f7/0x21f [jbd2] 
  [<ffffffffa0308db3>] ? jbd2_journal_start+0x90/0xbf [jbd2] 
  [<ffffffffa04cd8f8>] ? ocfs2_commit_trans+0x23/0xb1 [ocfs2] 
  [<ffffffffa04d2212>] ? ocfs2_complete_local_alloc_recovery+0x2fa/0x3a1 [ocfs2] 
  [<ffffffff82029bf1>] ? update_curr+0x77/0xe4 
  [<ffffffffa04cf681>] ? ocfs2_complete_recovery+0x0/0xab2 [ocfs2] 
  [<ffffffffa04cf887>] ? ocfs2_complete_recovery+0x206/0xab2 [ocfs2] 
  [<ffffffff822fb8de>] ? schedule+0x616/0x6c4 
  [<ffffffff8204dff0>] ? prepare_to_wait+0x35/0x6d 
  [<ffffffffa04cf681>] ? ocfs2_complete_recovery+0x0/0xab2 [ocfs2] 
  [<ffffffff8204afdf>] ? worker_thread+0x14a/0x1e4 
  [<ffffffff8204de27>] ? autoremove_wake_function+0x0/0x2e 
  [<ffffffff8204ae95>] ? worker_thread+0x0/0x1e4 
  [<ffffffff8204db33>] ? kthread+0x79/0x81 
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10 
  [<ffffffff8204daba>] ? kthread+0x0/0x81 
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10 
 Code: 
 0f 
 84 
 f2 
 00 
 last message repeated 2 times
 48 
 8d 
 bd 
 a0 
 05 
 00 
 00 
 e8 
 ab 
 ba 
 19 
 00 
 48 
 8b 
 b5 
 00 
 06 
 00 
 00 
 4c 
 89 
 e7 
 e8 
 69 
 eb 
 ff 
 ff 
 49 
 89 
 c6 
 48 
 8b 
 85 
 00 
 06 
 00 
 00 
 e> 
 48 
 ff 
 00 
 fe 
 85 
 a0 
 05 
 00 
 00 
 4d 
 85 
 f6 
 0f 
 84 
 a6 
 00 
 last message repeated 2 times
 49 
 8b 
  
 RIP 
  [<ffffffff82161537>] cfq_yield+0x5f/0x135 
  RSP <ffff880123061c60> 
 CR2: 0000000000000000 
 ---[ end trace 374ddf0f57161b27 ]--- 

--------------070603080802050506080407
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--------------070603080802050506080407--
