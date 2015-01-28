From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Writes blocked on wait_for_stable_page (Writes of less than page
 size sometimes take too long)
Date: Wed, 28 Jan 2015 13:39:14 -0800
Message-ID: <20150128213914.GE9976@birch.djwong.org>
References: <54C93169.3000600@codeaurora.org>
 <54C93811.1040107@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:46236 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbbA2BcR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jan 2015 20:32:17 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t0SLdJfi010947
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2015 21:39:21 GMT
Content-Disposition: inline
In-Reply-To: <54C93811.1040107@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 28, 2015 at 11:27:13AM -0800, Nikhilesh Reddy wrote:
> Hi
> I am working on a 64 bit Android device and have been trying to
> improve performance for stream based data download (for example an
> ftp)
> The device has 3GB of ram and the dirty_ratio and
> dirty_background_ratio are set to 5 and 1 respectively.
> 
> Kernel 3.10 , Highmem is not enabled and the backing device is a
> emmc and checksumming is not enabled

Ok, 3.10 kernel is new enough that stable page writes only apply to
devices that demand it, and apparently your eMMC demands it.

> I noticed when profiling writes that if we dont use streamed IO (ie.
> use write of whatever size data was read on the tcp stream) there
> are some writes that seem to get blocked on
> wait_for_stable_page.
> 
> If I force the writes to be buffered in the userspace and ensure
> writing 4k chunks the writes never seem to stall.

That's consistent with a page being partially dirtied, written out,
and partially dirtied again before write-out finishes.  If you buffer
the incoming data such that a page is only dirtied once, you'll never
notice wait_for_stable_page.

Are you explicitly forcing writeout (i.e. fsync()) after every chunk
arrives?  Or, is the rate of incoming data high enough such that we
hit either dirty*ratio limit?  It isn't too hard to hit 30MB these
days.  Why are you lowering the ratios from their defaults?

> I noticed there was earlier discussion on this and idea were
> proposed to use snapshotting of the pages to avoid stalls...
> For example: https://lwn.net/Articles/546658/
> 
> But this seems to only snapshot ext3 ... (unless i misunderstood
> what the patch is doing)
> 
> Is there a similar patch to snapshot the buffers to not stall the
> writes for ext4?

No, there is not -- the problem with the snapshot solution is that it
requires page allocations when the FS is (potentially) trying to
reclaim memory by writing out dirty pages.

--D

> Please let me know.
> 
> I would really appreciate any help you can give me.
> 
> 
> -- 
> Thanks
> Nikhilesh Reddy
> 
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
