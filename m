From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Thu, 11 Aug 2011 19:46:10 -0700
Message-ID: <CAFgt=MCgfN-6_uBm=pDaeLqJKJQkSHry91XbYwWq=iBXip3D-w@mail.gmail.com>
References: <4E4262A5.6030903@msgid.tls.msk.ru>
	<20110811115943.GF4755@quack.suse.cz>
	<4E43C956.3060507@msgid.tls.msk.ru>
	<20110811140101.GA18802@quack.suse.cz>
	<4E4435F4.6000406@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41990 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1HLCqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 22:46:16 -0400
Received: from hpaq1.eem.corp.google.com (hpaq1.eem.corp.google.com [172.25.149.1])
	by smtp-out.google.com with ESMTP id p7C2kFYL015637
	for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2011 19:46:15 -0700
Received: from gyh3 (gyh3.prod.google.com [10.243.50.195])
	by hpaq1.eem.corp.google.com with ESMTP id p7C2kCww010710
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2011 19:46:13 -0700
Received: by gyh3 with SMTP id 3so2222329gyh.23
        for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2011 19:46:12 -0700 (PDT)
In-Reply-To: <4E4435F4.6000406@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Michael,

Could you try your test with the patch I just posted:
http://marc.info/?l=3Dlinux-ext4&m=3D131311627101278&w=3D2
and see whether it fixes the problem?

Thanks!

Jiaying

On Thu, Aug 11, 2011 at 1:05 PM, Michael Tokarev <mjt@tls.msk.ru> wrote=
:
> 11.08.2011 18:01, Jan Kara wrote:
> []
>>>>> When it happens, a process doing direct AIO stalls
>>>>> infinitely, with the following backtrace:
>>>>>
>>>>> [87550.759848] INFO: task oracle:23176 blocked for more than 120 =
seconds.
>>>>> [87550.759892] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message.
>>>>> [87550.759955] oracle =A0 =A0 =A0 =A0 =A0D 0000000000000000 =A0 =A0=
 0 23176 =A0 =A0 =A01 0x00000000
>>>>> [87550.760006] =A0ffff8820457b47d0 0000000000000082 ffff880600000=
000 ffff881278e3f7d0
>>>>> [87550.760085] =A0ffff8806215c1fd8 ffff8806215c1fd8 ffff8806215c1=
fd8 ffff8820457b47d0
>>>>> [87550.760163] =A0ffffea0010bd7c68 ffffffff00000000 ffff882045512=
ef8 ffffffff810eeda2
>>>>> [87550.760245] Call Trace:
>>>>> [87550.760285] =A0[<ffffffff810eeda2>] ? __do_fault+0x422/0x520
>>>>> [87550.760327] =A0[<ffffffff81111ded>] ? kmem_getpages+0x5d/0x170
>>>>> [87550.760367] =A0[<ffffffff81112e58>] ? ____cache_alloc_node+0x4=
8/0x140
>>>>> [87550.760430] =A0[<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x=
260 [ext4]
>>>>> [87550.760475] =A0[<ffffffff8106aee0>] ? abort_exclusive_wait+0xb=
0/0xb0
>>>>> [87550.760523] =A0[<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 =
[ext4]
>>>>> [87550.760566] =A0[<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0=
x1d0
>>>>> [87550.760607] =A0[<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
>>>>> [87550.760646] =A0[<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
>>>>> [87550.760689] =A0[<ffffffff81359b52>] ? system_call_fastpath+0x1=
6/0x1b
>>>> =A0 Hmm, the stack trace does not quite make sense to me - the par=
t between
>>>> __do_fault and aio_rw_vect_retry is somehow broken. I can imagine =
we
>>>> blocked in ext4_file_write() but I don't see any place there where=
 we would
>>>> allocate memory. By any chance, are there messages like "Unaligned=
 AIO/DIO
>>>> on inode ..." in the kernel log?
>>>
>>> Yes, there are warnings about unaligned DIO, referring to this same
>>> process actually. Oracle does almost good job at aligning writes
>>> (usually it does i/o by its blocks which are 4Kb by default but
>>> are set to something larger - like 16Kb - for larger database).
>>> Except of a few cases, and lgwr process is one of them (*) - it
>>> writes logfiles using 512b blocks. =A0This is okay for a raw device
>>> with 512bytes blocks, but ext4 expects 4k writes at min.
>>>
>>> (*) another case is writing to control file, which is also done in
>>> 512byte chunks.
>> =A0 Ah, OK. I think the code ext4_end_io_nolock() handling the wait =
queue
>> might be racy. waitqueue_active() check is missing a barrier I think=
=2E
>> Does attached (untested) patch fix the issue for you?
>
> With this patch applied, I can reproduce the problem easily too:
>
> [ =A0 76.982985] EXT4-fs (dm-1): Unaligned AIO/DIO on inode 3407879 b=
y oracle; performance will be poor.
> [ 1469.734114] SysRq : Show Blocked State
> [ 1469.734157] =A0 task =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PC stack =A0 pid father
> [ 1469.734473] oracle =A0 =A0 =A0 =A0 =A0D 0000000000000000 =A0 =A0 0=
 =A06146 =A0 =A0 =A01 0x00000000
> [ 1469.734525] =A0ffff88103f604810 0000000000000082 ffff881000000000 =
ffff881079791040
> [ 1469.734603] =A0ffff880432c19fd8 ffff880432c19fd8 ffff880432c19fd8 =
ffff88103f604810
> [ 1469.734681] =A0ffffea000ec13590 ffffffff00000000 ffff881438c8dad8 =
ffffffff810eeda2
> [ 1469.734760] Call Trace:
> [ 1469.734800] =A0[<ffffffff810eeda2>] ? __do_fault+0x422/0x520
> [ 1469.734863] =A0[<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 =
[ext4]
> [ 1469.734909] =A0[<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0x=
b0
> [ 1469.734956] =A0[<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext=
4]
> [ 1469.734999] =A0[<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
> [ 1469.735039] =A0[<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
> [ 1469.735078] =A0[<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
> [ 1469.735122] =A0[<ffffffff81359b52>] ? system_call_fastpath+0x16/0x=
1b
>
> which is exactly the same as with previous "w" into sysrq-trigger.
>
> So it's something else... :(
>
> Thank you!
>
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
