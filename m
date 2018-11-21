Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:49120 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbeKUMCt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 07:02:49 -0500
Date: Tue, 20 Nov 2018 17:30:36 -0800
From: Liu Bo <bo.liu@linux.alibaba.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Ext4: fix slow writeback under dioread_nolock and
 nodelalloc
Message-ID: <20181121013035.ab4xp7evjyschecy@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1542694270-47732-1-git-send-email-bo.liu@linux.alibaba.com>
 <20181121000718.GC6401@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121000718.GC6401@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Tue, Nov 20, 2018 at 07:07:18PM -0500, Theodore Y. Ts'o wrote:
> On Tue, Nov 20, 2018 at 02:11:10PM +0800, Liu Bo wrote:
> > With "nodelalloc", blocks are allocated at the time of writing, and with
> > "dioread_nolock", these allocated blocks are marked as unwritten as well,
> > so bh(s) attached to the blocks have BH_Unwritten and BH_Mapped.
> 
> Hi Liu,
> 
> Could I ask a larger question, which is why is it that you find it
> desirable to use both nodelalloc and dioread_nolock at the same time?
> What's the use case which is causing you to want to do this?
>

So the story started with the fact that we found with '-o delalloc',
applications were experiencing latency fluctuation because of
%i_data_sem's contention between sys_write(2) and writepages().

Things are not always bad with "delalloc", but if applications do
append only writing where new blocks are always needed and are latency
critical workloads, then it'll be noticable.

On a centOS7, a fio test doing a buffered write workload with bs=4k,
5M/s append writes and runtime=180s, (results may be different on
upstream ext4.)

------------------------
- delalloc: 
lat (usec): min=2 , max=193466 , avg= 5.86, stdev=227.91

-nodelalloc:
lat (usec): min=3 , max=16388 , avg= 7.00, stdev=28.92
------------------------

For dioread_nolock, this is suggested to fix the IO priority inversion
issue we've already discussed. (but there're other priority issues,
e.g. do_get_write_access()'s lock_buffer, buffer_shadow())

> One of the things which I have been thinking about doing to simplify
> ext4's test matrix and so we can improve performance in a more direct
> way --- and also so it would make it much easier for us to switch over
> to using more of iomap --- was to consider deprecating and removing
> some of ext4's flexibility.  This includes:
> 
> *) Making dioread_nolock the default for 4k --- and fixing
>    dioread_nolock so it works for cases where page_size != block_size.
>    Once that is done, we would use dioread_nolock everywhere and drop
>    the older code path.
> 
> *) Drop support for data=journal mode (it could be specified, but it
>    would be ignored).  It's not clear anyone is using it, since the
>    double-write overhead is huge.  Furthermore, requiring the use of
>    nodelalloc means is a further performance hit on data=journal mode.
> 
> *) Drop support for nodelalloc, and make delayed allocation the
>    default.  (This requires dropping data=journal mode, since
>    data=journal mode does not co-exist with delalloc.)
> 
> The last was assuming that there really wasn't good use cases where
> people would really want to use nodelalloc, aside from ext3
> bug-for-bug compatibility, and hopefully since most people are using
> ext4 these days, it becomes easier to make the case tha we don't need
> to support ext3's unusual performance attributes.
> 
> The fact that you have done work trying to improve dioread_nolock &&
> nodelalloc implies that perhaps I'm wrong about my assumption.  So I'd
> like to understand more about what it is that you're trying to do, and
> to figure out of perhaps there's a better way to do it.  After all,
> delalloc makes it a lot easier for the block allocator to do a good
> job, and it also decreases the CPU overhead for the block allocator.
> And while forcing writes to the disk every five seconds might be
> advantageous for some application, it also can add significant latency
> variability for file system operations during a commit.
> 
> What am I missing?
>

So looks like the only big complain from us is the contention on
i_data_sem.

If upstream ext4 has already addressed the problems, please let me
know, I'm happy to suggest people to switch to delalloc.

thanks,
-liubo
