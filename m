From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Sun, 20 Jan 2013 01:35:07 +0100
Message-ID: <CA+icZUVHvf_4+kcfPXGSxpJ7X6imeJEDXM8Vcd9E1MeQpyuOYw@mail.gmail.com>
References: <CA+icZUWOvk5i+XY22xdZYuxu=Vy3fG2QxJStEgNFQVS4u55y-w@mail.gmail.com>
	<CA+icZUUzNYE9QAh_p7=ZNuvZbxRPCb9zd4k7+aW-hv34mQWz=A@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33472 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3ATAfJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Jan 2013 19:35:09 -0500
In-Reply-To: <CA+icZUUzNYE9QAh_p7=ZNuvZbxRPCb9zd4k7+aW-hv34mQWz=A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 20, 2013 at 1:06 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sun, Jan 20, 2013 at 12:44 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> Hi,
>>
>> I and some others hit a similiar problem in Linux-Next
>> (next-20130118), please see [1] and [2].
>>
>> [3] has a interim analyze of my problems.
>>
>> After suspecting the problem was caused by TTY-NEXT, it turned out to
>> be a JBD2 problem finally.
>> The freezer/pm_test was helpful to hit the issue (Thanks Rafael for the hint!).
>>
>> So, the issue has two faces: TTY and JBD2.
>> [4] gives a list and URLs of the patches I had to apply to have a
>> clean system again.
>>
>> After applying the two TTY patches (without Eric's JBD2-fix!) the
>> call-trace after freezer/pm_test looked like this;
>>
>> [  433.527986] PM: Syncing filesystems ... done.
>> [  433.843761] PM: Preparing system for mem sleep
>> [  436.306002] Freezing user space processes ...
>> [  456.304956] Freezing of tasks failed after 20.01 seconds (1 tasks
>> refusing to freeze, wq_busy=0):
>> [  456.305060] Cache I/O       D ffffffff8180d780     0  2132      1 0x00000004
>> [  456.305065]  ffff88007b9dfe18 0000000000000046 ffff88007b9dfdc8
>> 0000000300000001
>> [  456.305069]  ffff880097e21720 ffff88007b9dffd8 ffff88007b9dffd8
>> ffff88007b9dffd8
>> [  456.305072]  ffff880119b32e40 ffff880097e21720 ffff88007b9dfe28
>> ffff880118077800
>> [  456.305076] Call Trace:
>> [  456.305085]  [<ffffffff816b7469>] schedule+0x29/0x70
>> [  456.305089]  [<ffffffff8129067d>] jbd2_log_wait_commit+0xcd/0x1a0
>> [  456.305094]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
>> [  456.305098]  [<ffffffff812307a5>] ext4_sync_file+0x205/0x380
>> [  456.305103]  [<ffffffff811c43ad>] do_fsync+0x5d/0x90
>> [  456.305108]  [<ffffffff8119442b>] ? sys_write+0x6b/0xa0
>> [  456.305111]  [<ffffffff811c4790>] sys_fsync+0x10/0x20
>> [  456.305114]  [<ffffffff816c0edd>] system_call_fastpath+0x1a/0x1f
>> [  456.305122]
>> [  456.305124] Restarting tasks ... done.
>> [  456.315056] video LNXVIDEO:00: Restoring backlight state
>>
>> After applying Eric's patch [5], I could not hit the call-trace again.
>> NOTE: The patch is from December 2012 and is not shipped in latest Linux-Next.
>>
>> The attached testcase script was helpful to force the call-trace.
>> I have run 50 loops of it w/o an issue!
>>
>> Feel free to add a Reported-by/Tested-by.
>> ( The issue kept me busy for the last days. )
>>
>> Regards,
>> - Sedat -
>>
>> [1] http://marc.info/?t=135283664600002&r=1&w=2
>> [2] http://marc.info/?t=135862023700004&r=1&w=2
>> [3] http://marc.info/?l=linux-kernel&m=135862010419101&w=2
>> [4] http://marc.info/?l=linux-next&m=135863550923093&w=2
>> [5] http://patchwork.ozlabs.org/patch/207237/
>
> Hi all,
>
> this is really ugly... I could cry!
>
> GRRR, I have hit the original issue again while running my testcase script!
>
> [  363.831226] PM: Syncing filesystems ... done.
> [  363.988855] PM: Preparing system for mem sleep
> [  369.032965] Freezing user space processes ... (elapsed 0.11 seconds) done.
> [  369.145792] Freezing remaining freezable tasks ...
> [  389.137643] Freezing of tasks failed after 20.01 seconds (1 tasks
> refusing to freeze, wq_busy=0):
> [  389.137760] jbd2/loop0-8    D ffffffff8180d780     0   295      2 0x00000000
> [  389.137769]  ffff8801181dfb68 0000000000000046 ffff880117de5c80
> 0000000000000001
> [  389.137778]  ffff880117de5c80 ffff8801181dffd8 ffff8801181dffd8
> ffff8801181dffd8
> [  389.137784]  ffffffff81c15440 ffff880117de5c80 ffff8801181dfb68
> ffff88011fa14738
> [  389.137791] Call Trace:
> [  389.137810]  [<ffffffff811c6830>] ? __wait_on_buffer+0x30/0x30
> [  389.137819]  [<ffffffff816b7479>] schedule+0x29/0x70
> [  389.137825]  [<ffffffff816b754f>] io_schedule+0x8f/0xd0
> [  389.137832]  [<ffffffff811c683e>] sleep_on_buffer+0xe/0x20
> [  389.137842]  [<ffffffff816b5d4f>] __wait_on_bit+0x5f/0x90
> [  389.137849]  [<ffffffff811c5ef1>] ? submit_bh+0x121/0x1e0
> [  389.137856]  [<ffffffff811c6830>] ? __wait_on_buffer+0x30/0x30
> [  389.137864]  [<ffffffff816b5dfc>] out_of_line_wait_on_bit+0x7c/0x90
> [  389.137873]  [<ffffffff8107eb00>] ? autoremove_wake_function+0x40/0x40
> [  389.137879]  [<ffffffff811c682e>] __wait_on_buffer+0x2e/0x30
> [  389.137891]  [<ffffffff8128c02c>]
> jbd2_journal_commit_transaction+0x18cc/0x1d60
> [  389.137899]  [<ffffffff816b860e>] ? _raw_spin_lock_irqsave+0x2e/0x40
> [  389.137908]  [<ffffffff81069fbf>] ? try_to_del_timer_sync+0x4f/0x70
> [  389.137915]  [<ffffffff81290836>] kjournald2+0xd6/0x3e0
> [  389.137921]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
> [  389.137926]  [<ffffffff81290760>] ? commit_timeout+0x10/0x10
> [  389.137932]  [<ffffffff8107ded0>] kthread+0xc0/0xd0
> [  389.137939]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
> [  389.137946]  [<ffffffff816c0e2c>] ret_from_fork+0x7c/0xb0
> [  389.137951]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
> [  389.138017]
> [  389.138021] Restarting kernel threads ... done.
> [  389.138173] Restarting tasks ... done.
> [  389.147980] video LNXVIDEO:00: Restoring backlight state
>
> I suspect there are still issues in JBD2 (BTW I run here EXT4FS).
>
> [  389.137643] Freezing of tasks failed after 20.01 seconds (1 tasks
> refusing to freeze, wq_busy=0):
> [  389.137760] jbd2/loop0-8    D ffffffff8180d780     0   295      2 0x00000000
>
> Have a good night, /me -> watching TV!
>
> - Sedat -

Man, what a NONSENSE I am telling...
The mentioned so-called fix is already in next-20130118, shame on me!

commit 7e2fb2d7e6a3094473f101ae33dd6431ae6d2ed1
"jbd: don't wake kjournald unnecessarily"

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=7e2fb2d7e6a3094473f101ae33dd6431ae6d2ed1
