From: liang xie <xieliang007@gmail.com>
Subject: Re: Question about slow buffered io
Date: Thu, 10 Apr 2014 10:58:11 +0800
Message-ID: <CADu=CFr8KdAZKNeQjAKqZdv=NZf_FdsBV0WBXTJM6v+ZgM4gaA@mail.gmail.com>
References: <CADu=CFqjr_DovzRbPiA1KoBL1AHtZ+7bkXAQJum2SOvdWi_JQw@mail.gmail.com>
	<20140409105112.GB2854@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: liang xie <xieliang007@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:35534 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaDJC6M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2014 22:58:12 -0400
Received: by mail-vc0-f177.google.com with SMTP id if17so2813728vcb.36
        for <linux-ext4@vger.kernel.org>; Wed, 09 Apr 2014 19:58:11 -0700 (PDT)
In-Reply-To: <20140409105112.GB2854@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 9, 2014 at 6:51 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Wed, Apr 09, 2014 at 05:14:37PM +0800, liang xie wrote:
>> Hi,
>>
>> I am an Apache HDFS/HBase developer and debugging the slow buffered io
>> issue on ext4. I saw some slow sys_write caused by:
>> (mount -o noatime)
>> 0xffffffff814ed1c3 : io_schedule+0x73/0xc0 [kernel]
>> 0xffffffff81110b4d : sync_page+0x3d/0x50 [kernel]
>> 0xffffffff814eda2a : __wait_on_bit_lock+0x5a/0xc0 [kernel]
>> 0xffffffff81110ae7 : __lock_page+0x67/0x70 [kernel]
>> 0xffffffff81111abc : find_lock_page+0x4c/0x80 [kernel]
>> 0xffffffff81111b3a : grab_cache_page_write_begin+0x4a/0xc0 [kernel]
>> 0xffffffffa00d05d4 : ext4_da_write_begin+0xb4/0x200 [ext4]
>
> Delalloc obviously could cause a latency spike because of i_data_sem.
> When flusher thread tries to write out some dirty pages, it will grab
> i_data_sem locking and allocate some blocks for these dirty pages.  At
> that time if an application tries to do some buffered writes, i_data_sem
> also need to be taken.  So the application needs to wait on writeback.
>
Cool, got it :)

>>
>> seems caused by delay allocation, right?  so i reran with "mount -o
>> noatime,,nodiratime,data=writeback,nodelalloc", unfortunately, i saw
>> another stack trace contributing high latency:
>>  0xffffffff811a9416 : __wait_on_buffer+0x26/0x30 [kernel]
>>  0xffffffffa0123564 : ext4_mb_init_cache+0x234/0x9f0 [ext4]
>>  0xffffffffa0123e3e : ext4_mb_init_group+0x11e/0x210 [ext4]
>>  0xffffffffa0123ffd : ext4_mb_good_group+0xcd/0x110 [ext4]
>>  0xffffffffa01276eb : ext4_mb_regular_allocator+0x19b/0x410 [ext4]
>>  0xffffffffa0127ced : ext4_mb_new_blocks+0x38d/0x560 [ext4]
>>  0xffffffffa011dfc3 : ext4_ext_get_blocks+0x1113/0x1a10 [ext4]
>>  0xffffffffa00fb335 : ext4_get_blocks+0xf5/0x2a0 [ext4]
>>  0xffffffffa00fbdad : ext4_get_block+0xbd/0x120 [ext4]
>>  0xffffffff811ab27b : __block_prepare_write+0x1db/0x570 [kernel]
>>  0xffffffff811ab8cc : block_write_begin_newtrunc+0x5c/0xd0 [kernel]
>>  0xffffffff811abcd3 : block_write_begin+0x43/0x90 [kernel]
>>  0xffffffffa00fe408 : ext4_write_begin+0x1b8/0x2d0 [ext4]
>> and from HDFS/HBASE side, also no obvious improvement be found.
>
> From the output of calltrace, it seems that we wait on reading some meta
> data for block allocation.
Any ideas on relieving the write stall caused by it?

>
>>
>> and inside both two scenarios, the following stack trace was hit as well:
>>  0xffffffffa00dc09d : do_get_write_access+0x29d/0x520 [jbd2]
>>  0xffffffffa00dc471 : jbd2_journal_get_write_access+0x31/0x50 [jbd2]
>>  0xffffffffa011eb78 : __ext4_journal_get_write_access+0x38/0x80 [ext4]
>>  0xffffffffa01209ba : ext4_mb_mark_diskspace_used+0x7a/0x300 [ext4]
>>  0xffffffffa0127c09 : ext4_mb_new_blocks+0x2a9/0x560 [ext4]
>>  0xffffffffa011dfc3 : ext4_ext_get_blocks+0x1113/0x1a10 [ext4]
>>  0xffffffffa00fb335 : ext4_get_blocks+0xf5/0x2a0 [ext4]
>>  0xffffffffa00fbdad : ext4_get_block+0xbd/0x120 [ext4]
>>
>> My question is:
>> 1)what's the ext4 best practice for low latency append-only workload
>> like HBase application? Is there any recommended option i could try,
>> flex_bg size? nomballoc?
>
> We do the following things in our product system in order to avoid
> latency spike:
> 1. -o nodelalloc
> 2. -o data=writeback
> 3. disable stable page write

ok

>> 2)for the last strace trace, does
>> 9f203507ed277ee86e3f76a15e09db1c92e40b94 help a lot, or no big win? (i
>> haven't run on 3.10+ so far and it's inconvenient to bump kernel
>> version on my cluster currently, so forgive my this stupid question if
>> it's...)
>
> TBH, I don't know.  But it is not very hard to backport this patch into
> your kernel.
>
> BTW, as far as I understand, Hadoop just does some parallel append buffer
> writes, right?

not exactly, per my current understanding, the hdfs data files are always append
only write, but the meta files are not the same story, it possible has a minor
overwrite request under special conditions.

> Could you please write a simple program to reproduce this problem?
np, will do once get chance
Thanks for your nice reply, zheng :)

>
> Regards,
>                                                 - Zheng
