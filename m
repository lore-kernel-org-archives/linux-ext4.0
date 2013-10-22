From: Sandeep Joshi <sanjos100@gmail.com>
Subject: Re: process hangs in ext4_sync_file
Date: Tue, 22 Oct 2013 08:54:52 +0530
Message-ID: <CAEfL3KnB_j-3v50Z3UF4T+uP2Rje2d0Zgjeb3h0byyQ7uFib2w@mail.gmail.com>
References: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
	<20131021125758.GA3253@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Sandeep Joshi <sanjos100@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:41677 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3JVDYx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 23:24:53 -0400
Received: by mail-vb0-f54.google.com with SMTP id q12so55323vbe.41
        for <linux-ext4@vger.kernel.org>; Mon, 21 Oct 2013 20:24:52 -0700 (PDT)
In-Reply-To: <20131021125758.GA3253@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 21, 2013 at 6:27 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> Hi Sandeep,
>
> On Mon, Oct 21, 2013 at 06:09:02PM +0530, Sandeep Joshi wrote:
>> I am seeing a problem reported 4 years earlier
>> https://lkml.org/lkml/2009/3/12/226
>> (same stack as seen by Alexander)
>>
>> The problem is reproducible.  Let me know if you need any info in
>> addition to that seen below.
>>
>> I have multiple threads in a process doing heavy IO on a ext4
>> filesystem mounted with (discard, noatime) on a SSD or HDD.
>>
>> This is on Linux 3.8.0-29-generic #42~precise1-Ubuntu SMP Wed Aug 14
>> 16:19:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>>
>> For upto minutes at a time, one of the threads seems to hang in sync to disk.
>>
>> When I check the thread stack in /proc, I find that the stack is one
>> of the following two
>>
>> <ffffffff81134a4e>] sleep_on_page+0xe/0x20
>> [<ffffffff81134c88>] wait_on_page_bit+0x78/0x80
>> [<ffffffff81134d9c>] filemap_fdatawait_range+0x10c/0x1a0
>> [<ffffffff811367d8>] filemap_write_and_wait_range+0x68/0x80
>> [<ffffffff81236a4f>] ext4_sync_file+0x6f/0x2b0
>> [<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
>> [<ffffffff81168fb3>] sys_msync+0x143/0x1d0
>> [<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>>
>> OR
>>
>>
>> [<ffffffff812947f5>] jbd2_log_wait_commit+0xb5/0x130
>> [<ffffffff81297213>] jbd2_complete_transaction+0x53/0x90
>> [<ffffffff81236bcd>] ext4_sync_file+0x1ed/0x2b0
>> [<ffffffff811cba9b>] vfs_fsync+0x2b/0x40
>> [<ffffffff81168fb3>] sys_msync+0x143/0x1d0
>> [<ffffffff816fc8dd>] system_call_fastpath+0x1a/0x1f
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> Any clues?
>
> Thanks for reporting this.  Could you please try your test in latest
> mainline kernel?  Further, could you please run the following command?
>   'echo w >/proc/sysrq-trigger'
> After running this command, system will dump all blocked tasks in dmesg.
>
> Regards,
>                                                 - Zheng

Zheng

The problem occurred as part of a larger system.  It might be too much
effort to reuild the whole code on the latest mainline kernel.   Are
there any ext4 bug fixes in the latest version which might make it
worth the effort ?

And are there any other debug options that I can turn on inside the
kernel which might help ?

-Sandeep
