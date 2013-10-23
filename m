From: Sandeep Joshi <sanjos100@gmail.com>
Subject: Re: process hangs in ext4_sync_file
Date: Wed, 23 Oct 2013 20:28:22 +0530
Message-ID: <CAEfL3KnUhETAWeh-OoRYTR5GxYL26TjaT=j_WDZeW5xa3vAdeg@mail.gmail.com>
References: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
	<20131023102042.GE1275@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:38085 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3JWO6Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Oct 2013 10:58:24 -0400
Received: by mail-ve0-f174.google.com with SMTP id pa12so98127veb.5
        for <linux-ext4@vger.kernel.org>; Wed, 23 Oct 2013 07:58:23 -0700 (PDT)
In-Reply-To: <20131023102042.GE1275@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 23, 2013 at 3:50 PM, Jan Kara <jack@suse.cz> wrote:
> On Mon 21-10-13 18:09:02, Sandeep Joshi wrote:
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
>   We are waiting for IO to complete. As the first thing, try to remount
> your filesystem without 'discard' mount option. That is often causing
> problems.
>
>                                                                 Honza


Thanks Jan,  I will remove it and see what happens.
I was also planning to switch to ext2 and see if the failure continues.
I added the discard option because the filesystem was initially
supposed to be on an SSD

is there any document which tells me what to look for in the output of
"echo w > /proc/sysrq-trigger" ?

-Sandeep

>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
