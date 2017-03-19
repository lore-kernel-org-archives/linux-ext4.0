From: Dmitry Monakhov <dmonlist@gmail.com>
Subject: Re: dirty_ratio
Date: Mon, 20 Mar 2017 02:53:33 +0300
Message-ID: <878to0258i.fsf@dmlp.sw.ru>
References: <CAAMvbhEbraxyJtST5-ujZvdi5T_nRByU2gXHa0dBtzwb3ovvWA@mail.gmail.com> <20170309141701.GK15874@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>,
        James Courtier-Dutton <james.dutton@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:32775 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdCSXxh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Mar 2017 19:53:37 -0400
Received: by mail-lf0-f47.google.com with SMTP id a6so49544473lfa.0
        for <linux-ext4@vger.kernel.org>; Sun, 19 Mar 2017 16:53:36 -0700 (PDT)
In-Reply-To: <20170309141701.GK15874@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> Hello!
>
> On Sat 25-02-17 11:56:58, James Courtier-Dutton wrote:
>> I have a server that has basically two tasks.
>> 1) Receiving lots of data from the network and storing it on disk.
>> 2) An App that makes relatively small use of the disk and responds to
>> requests from the network.
>> 
>> The problem I have is that sometimes (1) is filling up all the "Dirty"
>> pages, triggering a blocking flushing of the dirty buffer to the disk.
>> This essentially freezes (1) and (2) until the flushing is complete.
>> On occasions, this can take more than 60 seconds.
>> 60 seconds is far too long from (2) point of view, because it needs to
>> respond to user requests quickly, i.e less than 1 second.
>> 
>> Is there any mechanism that could result in (1) being informed about
>> the problem, (1) could then back off writing data to disk, and then at
>> the same time, asked the sending system over the network to also back
>> off.
>
> I'll need some more data to help you. So:
>
> 1) What kernel version do you use?
> 2) What kind of storage is the "disk"?
> 3) What IO scheduler do you use (you can find that in
>    /sys/block/<device>/queue/scheduler)?
> 4) What filesystem do you use?
> 5) What does "App" do when answering the query? Only reads or also writes?
>    How much roughly?
I have seen similar glitches (2-8sec) on chunk server which does
similar job as ceph-OSD.
Source of glitches was:
1) wait for journal-space inside aio_submit->mtime_update, was fixed
by lazy_mtime option, but not widely used on stable distros.
2) write_back due to balance dirty_page, Easily fixed by using O_DIRECT
3) sendmsg->sk_page_frag_refill->alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
                                          __GFP_COMP | __GFP_NOWARN |
                                          __GFP_NORETRY,
                                          SKB_FRAG_PAGE_ORDER);

Where SKB_FRAG_PAGE_ORDER = 3 (32k), so such glitches are visiable(2-3sec) and
annoying for high performance storage tasks. I have no clear idea how to
avoid that.


>  
>> On TCP/IP networks, this is reported back as "congestion" on the
>> network, the this results in throttling of the sending application on
>> a per TCP session basis.
>> 
>> In the above case, we are essentially seeing "congestion" to a
>> particular storage disk, but the application does not get any feedback
>> about this.
>> 
>> I guess the perfect solution would be Quality-of-Service for disk
>> writes, much like we have for network traffic.
>>
>> So, is there a feature available that can help me here, or will I have
>> to look at modifying the Linux kernel in order to add support for
>> "congestion notification from disk writes" ?
>
> You can actually use cgroups these days to isolate the heavy writer and
> thus give decent priority to the "App".
>
>> 
>> In my view that "dirty_ratio" causing the whole system to appear to
>> freeze due to disk blocking is too blunt an instrument.
>> 
>> Also, even detecting if the 60 second freezes are a result of the
>> "dirty_ratio" being hit is difficult to do.  It would be useful if
>> there existed a counter that would count the amount of times the
>> system resorted to "blocking" writes, as opposed to the
>> non-problematic background writes.
>
> Well, your process fetching data from network is probably permanently in
> the "blocking" writes situation so global blocking counter would not help
> you much. You would need it per task. But iowait time of a process should
> tell you that information already.
>
>> In my view, whenever the "blocking" writes was initiated, the
>> application should be informed about it.
>> Another alternative could be that the dirty pages are associated with
>> the application process and file descriptor and a dirty_ratio set per
>> file descriptor. Then, when a dirty_ratio is hit on the file
>> descriptor, only the application that holds that fd is frozen.
>> Maybe have multi-level limits. I.e. Warn App at limit A, freeze app at limit B.
>
> Dirty_limit is just a mechanism preventing the system from running
> out-of-memory due to too many dirty pages. It is not a quality-of-service
> mechanism. Cgroups are meant for that (or better for resource limiting
> of individual tasks). And wrt notifying application about blocking writes -
> IMO application has no bussiness in knowing that. It is too fragile. But
> kernel should behave better than just letting the application wait for 1
> minute...

>
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
