From: Nagachandra P <nagachandra@gmail.com>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Thu, 27 Jun 2013 18:28:21 +0530
Message-ID: <CAFy9=U5bPbDqfU=NVdaxvK5gNX9O33LD6mYJYqoTQLq7UTjqFw@mail.gmail.com>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
	<20130626140205.GE3875@thunk.org>
	<20130626145417.GB32092@thunk.org>
	<CAFy9=U5O9qQP5QU_Nw4fEbfy2oVxUub=ddYgJ_ZKXmjdChO4iA@mail.gmail.com>
	<20130626163450.GA2487@thunk.org>
	<CAFy9=U5m5uew586C2eZJ7HjkRN5PvKr8+FoDdj8xtJoBeuP-_A@mail.gmail.com>
	<20130626180345.GA4128@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Vikram MP <mp.vikram@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:55310 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3F0M6X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Jun 2013 08:58:23 -0400
Received: by mail-la0-f52.google.com with SMTP id fo12so777610lab.39
        for <linux-ext4@vger.kernel.org>; Thu, 27 Jun 2013 05:58:22 -0700 (PDT)
In-Reply-To: <20130626180345.GA4128@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

Could you point me to the code where ext4_std_err is not triggered
because of LMK? As I see it, if a memory allocation returns error in
some of the case ext4_std_error would invariably be called. Please
consider the following call stack

send sigkill to 5648 (id.app.sbrowser), score_adj 1000,adj 15, size
13257 with ofree -2010 20287, cfree 18597 902 msa 1000 ma 15
id.app.sbrowser: page allocation failure: order:0, mode:0x50
[<c0013aa8>] (unwind_backtrace+0x0/0x11c) from [<c00d6530>]
(warn_alloc_failed+0xe8/0x110)
[<c00d6530>] (warn_alloc_failed+0xe8/0x110) from [<c00d9308>]
(__alloc_pages_nodemask+0x6d4/0x804)
[<c00d9308>] (__alloc_pages_nodemask+0x6d4/0x804) from [<c00d2b34>]
(find_or_create_page+0x40/0x84)
[<c00d2b34>] (find_or_create_page+0x40/0x84) from [<c0188858>]
(ext4_mb_load_buddy+0xd4/0x2b4)
[<c0188858>] (ext4_mb_load_buddy+0xd4/0x2b4) from [<c018c69c>]
(ext4_free_blocks+0x5d4/0xa08)
[<c018c69c>] (ext4_free_blocks+0x5d4/0xa08) from [<c0181218>]
(ext4_ext_remove_space+0x690/0xd9c)
[<c0181218>] (ext4_ext_remove_space+0x690/0xd9c) from [<c0183654>]
(ext4_ext_truncate+0x100/0x1c8)
[<c0183654>] (ext4_ext_truncate+0x100/0x1c8) from [<c015e2ec>]
(ext4_truncate+0xf4/0x194)
[<c015e2ec>] (ext4_truncate+0xf4/0x194) from [<c01629dc>]
(ext4_evict_inode+0x3b4/0x4ac)
[<c01629dc>] (ext4_evict_inode+0x3b4/0x4ac) from [<c011871c>] (evict+0x8c/0x150)
[<c011871c>] (evict+0x8c/0x150) from [<c010f030>] (do_unlinkat+0xdc/0x134)
[<c010f030>] (do_unlinkat+0xdc/0x134) from [<c000e100>]
(ret_fast_syscall+0x0/0x30)

The failure to allocate memory in above case is because of the kill
signal received.

__alloc_pages_slowpath would return NULL in case its received a KILL
signal. (I don't see any code in 3.4.5 that would check for something
similar to TIF_MEMDIE to make an decision on whether to call
ext4_std_error or not, is this added recently).

Thanks
Naga

On Wed, Jun 26, 2013 at 11:33 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Jun 26, 2013 at 10:35:22PM +0530, Nagachandra P wrote:
>>
>> These issue are not easy to reproduce!!! We are running multiple
>> applications (of different memory size) over a period of a 24 hrs to
>> 36 hrs and we hit this once. We have seen these issues easier to
>> reproduce typically with around 512MB memory (may be in about 16 hrs -
>> 20 hrs), and harder to reproduce with 1GB memory.
>>
>> Most of the time we get into these situation are when an application
>> (Typically AsyncTasks in Android) that is doing ext4 fs ops are of low
>> adj values (> 9, typically 10 - 12) and hence would be fairly gullible
>> to be killed (and there would be no way to distinguish this from
>> application perspective), this is one of the challenges we are facing.
>> Also, here we are don't have to completely be out of memory (but just
>> withing the LMK band for the process adj value).
>
> To be clear, if the application is killed by the low memory killer,
> we're not going to trigger the ext4_std_err() codepath.  The
> ext4_std_error() is getting called because free memory has fallen to
> _zero_ and so kmem_cache_alloc() returns an error.  Should ext4 do a
> better job with handling this?  Yes, absolutely.  I do consider this a
> fs bug that we should try to fix.  The reality though is if that free
> memory has gone to zero, it's going to put multiple kernel subsystems
> under stress.
>
> It is good to hear that this is only happening on highly memory
> constrained devices --- speaking as a owner of a Nexus 4 with 2GB of
> memory.  :-P
>
> That's why the bigger issue is why did free memory go to zero in the
> first place?  That means the LMK was probably not being aggressive
> enough, or something started consuming a lot of memory too quickly,
> before the page cleaner and write throttling algorithms could kick in
> and try to deal with it.
>
>> But, on rethinking your idea on retrying may work if we have some
>> tweaks in LMK as well (like killing multiple tasks instead of just
>> one).
>
> You might also consider looking at tweaking the mm low watermark and
> minimum watermark.  See the tunable /proc/sys/vm/min_free_kbytes.
>
> You might want to just simply try monitorinig the free memory levels
> on a continuous basis, and see how often it's dropping below some
> minimum level.  This will allow you to give you a figure of merit by
> which you can try tuning your system, without needing to wait for a
> file system error.
>
> Cheers,
>
>                                         - Ted
