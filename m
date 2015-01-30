From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Writes blocked on wait_for_stable_page (Writes of less than page
 size sometimes take too long)
Date: Fri, 30 Jan 2015 13:53:32 -0800
Message-ID: <20150130215332.GA26226@birch.djwong.org>
References: <54C93169.3000600@codeaurora.org>
 <54C93811.1040107@codeaurora.org>
 <20150128213914.GE9976@birch.djwong.org>
 <54C96F87.7000502@codeaurora.org>
 <54C97262.3010406@codeaurora.org>
 <20150128235705.GI21455@birch.djwong.org>
 <54CBF6E6.3090406@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44961 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763197AbbA3Vxi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jan 2015 16:53:38 -0500
Content-Disposition: inline
In-Reply-To: <54CBF6E6.3090406@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 30, 2015 at 01:25:58PM -0800, Nikhilesh Reddy wrote:
> Thanks so much Darrick for all your help.
> That patch helped.
> 
> I had a bit of a query with respect to stable pages though...
> 
> From what I understand only backing devices that need some sort of
> checksumming seem to need stable pages... AS in regular emmc
> shouldnt need it correct?

Right.

> If not then the below patch would now cause a pass-through rather than
> wait for writeback and I was wondering  if that could cause corruptions
> when the same page is dirtied again with writeback in progress.

It looked ok to me and several other reviewers.  On a non-stable-pages device,
dirtying a page during writeback should be fine since the dirty bit will be
set and the page will eventually be written back again.

> Also with respect to the flush... since the applications are
> prettymuch third party I cant really do much there...

There's eatmydata, but that's evil... :)

> But I was wondering now that there is no contention with the pages
> after the patch ... if reducing the cache may actually be bad.
> 
> Still running metrics so wont know until they are done.

--D

> 
> 
> On 01/28/2015 03:57 PM, Darrick J. Wong wrote:
> >On Wed, Jan 28, 2015 at 03:36:02PM -0800, Nikhilesh Reddy wrote:
> >>Also can someone please confirm if the following patch  help address
> >>this issue That I described below?
> >>
> >>https://kernel.googlesource.com/pub/scm/linux/kernel/git/tytso/ext4/+/7afe5aa59ed3da7b6161617e7f157c7c680dc41e
> >>
> >>Quick Summary:
> >>
> >>in the function
> >>wait_on_page_writeback(page)  inside ext4_da_write_begin seems to
> >>take long and the process is stuck waiting.
> >>
> >>The writeback just seems to take long.. but only when we write to the
> >>same page over again...
> >>The grab_cache_page_write_begin gives the same page until we  write
> >>enough...
> >>Is there a wait to not wait for the writeback?
> >
> >Oh, right.  <smacks head>
> >
> >Yes, that wait_for_page_writeback() was replaced with a call to
> >wait_for_stable_page() upstream, so it'll probably work for your 3.10
> >kernel.
> >
> >(I also wonder why not jump to a newer LTS kernel, but that's neither
> >here nor there.)
> >
> ><more below>
> >
> >>On 01/28/2015 03:23 PM, Nikhilesh Reddy wrote:
> >>>
> >>>Hi Darrick
> >>>Thanks so much for your reply.
> >>>I apologize  the stable  page wait seems to be an odd outlier in that
> >>>run ... I ran multiple traces again.
> >>>
> >>>Please find my answers inline below.
> >>>
> >>>On 01/28/2015 01:39 PM, Darrick J. Wong wrote:
> >>>>On Wed, Jan 28, 2015 at 11:27:13AM -0800, Nikhilesh Reddy wrote:
> >>>>>Hi
> >>>>>I am working on a 64 bit Android device and have been trying to
> >>>>>improve performance for stream based data download (for example an
> >>>>>ftp)
> >>>>>The device has 3GB of ram and the dirty_ratio and
> >>>>>dirty_background_ratio are set to 5 and 1 respectively.
> >>>>>
> >>>>>Kernel 3.10 , Highmem is not enabled and the backing device is a
> >>>>>emmc and checksumming is not enabled
> >>>>Ok, 3.10 kernel is new enough that stable page writes only apply to
> >>>>devices that demand it, and apparently your eMMC demands it.
> >>>I tried checking my logs again .. and yes the stable pages dont apply
> >>>... that seems to be an odd instance where it took a while.
> >>>/My apologies.
> >>>
> >>>So On running many more trace runs it appears that the wait is actually
> >>>on in the function
> >>>
> >>>wait_on_page_writeback(page) ext4_da_write_begin
> >>>
> >>>Snippet below
> >>>
> >>>     /*
> >>>      * grab_cache_page_write_begin() can take a long time if the
> >>>      * system is thrashing due to memory pressure, or if the page
> >>>      * is being written back.  So grab it first before we start
> >>>      * the transaction handle.  This also allows us to allocate
> >>>      * the page (if needed) without using GFP_NOFS.
> >>>      */
> >>>retry_grab:
> >>>     page = grab_cache_page_write_begin(mapping, index, flags);
> >>>     if (!page)
> >>>         return -ENOMEM;
> >>>     unlock_page(page);
> >>>
> >>>retry_journal:
> >>>     handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
> >>>     if (IS_ERR(handle)) {
> >>>         page_cache_release(page);
> >>>         return PTR_ERR(handle);
> >>>     }
> >>>
> >>>     lock_page(page);
> >>>     if (page->mapping != mapping) {
> >>>         /* The page got truncated from under us */
> >>>         unlock_page(page);
> >>>         page_cache_release(page);
> >>>         ext4_journal_stop(handle);
> >>>         goto retry_grab;
> >>>     }
> >>>     wait_on_page_writeback(page); <<<<<<<<<<<<<<<<<<This is where the
> >>>wait is!
> >>>
> >>>
> >>>
> >>>The writeback just seems to take long.. but only when we write to the
> >>>same page over again...
> >>>The grab_cache_page_write_begin gives the same page until we  write
> >>>enough...
> >>>
> >>>Is there a wait to not wait for the writeback?
> >>>
> >>>
> >>>>
> >>>>>I noticed when profiling writes that if we dont use streamed IO (ie.
> >>>>>use write of whatever size data was read on the tcp stream) there
> >>>>>are some writes that seem to get blocked on
> >>>>>wait_for_stable_page.
> >>>>>
> >>>>>If I force the writes to be buffered in the userspace and ensure
> >>>>>writing 4k chunks the writes never seem to stall.
> >>>>That's consistent with a page being partially dirtied, written out,
> >>>>and partially dirtied again before write-out finishes.  If you buffer
> >>>>the incoming data such that a page is only dirtied once, you'll never
> >>>>notice wait_for_stable_page.
> >>>>
> >>>>Are you explicitly forcing writeout (i.e. fsync()) after every chunk
> >>>>arrives?  Or, is the rate of incoming data high enough such that we
> >>>>hit either dirty*ratio limit?  It isn't too hard to hit 30MB these
> >>>>days.  Why are you lowering the ratios from their defaults?
> >>
> >>>Using the higher values seems to cause longer stall ...when we do stall...
> >>>Smaller values are cause the write out to happen often but each one
> >>>takes less time.
> >>>
> >>>Setting it to the defaults causes a longer stall which seems to be
> >>>impacting TCP due to the delay in reading.
> >>>Additional info : dirty_expire_centisecs was set to 200 and the data
> >>>rate is close to 300Mbps. so yea 30MB should be less than a second.
> >
> >Ah, you're concerned about the writeout latency, and it's important
> >that incoming data end up on flash as quickly as is convenient.  Hm.
> >
> >That patch you found will probably get rid of the symptoms; I'd also
> >suggest fsync()ing after each page boundary instead of lowering the
> >writeback ratios since that increases the write load systemwide,
> >which will make the writeouts for your app take more time and wear out
> >the flash sooner.
> >
> >--D
> >
> >>>
> >>>Am I missing something obvious here?
> >>>
> >>>Please do let me know.
> >>>
> >>>Thanks so much for you help
> >>>
> >>>
> >>>>
> >>>>>I noticed there was earlier discussion on this and idea were
> >>>>>proposed to use snapshotting of the pages to avoid stalls...
> >>>>>For example: https://lwn.net/Articles/546658/
> >>>>>
> >>>>>But this seems to only snapshot ext3 ... (unless i misunderstood
> >>>>>what the patch is doing)
> >>>>>
> >>>>>Is there a similar patch to snapshot the buffers to not stall the
> >>>>>writes for ext4?
> >>>>No, there is not -- the problem with the snapshot solution is that it
> >>>>requires page allocations when the FS is (potentially) trying to
> >>>>reclaim memory by writing out dirty pages.
> >>>>
> >>>>--D
> >>>>
> >>>>>Please let me know.
> >>>>>
> >>>>>I would really appreciate any help you can give me.
> >>>>>
> >>>>>
> >>>>>--
> >>>>>Thanks
> >>>>>Nikhilesh Reddy
> >>>>>
> >>>>>Qualcomm Innovation Center, Inc.
> >>>>>The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> >>>>>Forum,
> >>>>>a Linux Foundation Collaborative Project.
> >>>>>--
> >>>>>To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >>>>>the body of a message to majordomo@vger.kernel.org
> >>>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>>
> >>
> >>
> >>--
> >>Thanks
> >>Nikhilesh Reddy
> >>
> >>Qualcomm Innovation Center, Inc.
> >>The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> >>a Linux Foundation Collaborative Project.
> 
> 
> -- 
> Thanks
> Nikhilesh Reddy
> 
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project.
