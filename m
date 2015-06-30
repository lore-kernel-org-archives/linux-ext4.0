From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Tue, 30 Jun 2015 09:35:23 +0300
Message-ID: <559238AB.3020000@kyup.com>
References: <558BD447.1010503@kyup.com> <558BD507.9070002@kyup.com> <20150625112116.GC17237@dhcp22.suse.cz> <558BE96E.7080101@kyup.com> <20150625115025.GD17237@dhcp22.suse.cz> <20150625133138.GH14324@thunk.org> <5591097D.6010602@kyup.com> <20150629093640.GD28471@dhcp22.suse.cz> <20150630015206.GL22807@dastard> <20150630030207.GB14839@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Michal Hocko <mhocko@suse.cz>, linux-ext4@vger.kernel.org,
	Marian Marinov <mm@1h.com>
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.siteground.com ([67.19.240.234]:48075 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbF3Gf1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Jun 2015 02:35:27 -0400
In-Reply-To: <20150630030207.GB14839@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/30/2015 06:02 AM, Theodore Ts'o wrote:
> On Tue, Jun 30, 2015 at 11:52:06AM +1000, Dave Chinner wrote:
>> Yes, and looks at the caller path....
>>
>>>>  #8 [ffff88177374af50] shrink_inactive_list at ffffffff81135845
>>>>  #9 [ffff88177374b060] shrink_lruvec at ffffffff81135ead
>>>> #10 [ffff88177374b150] shrink_zone at ffffffff811360c3
>>>> #11 [ffff88177374b220] shrink_zones at ffffffff81136eff
>>>> #12 [ffff88177374b2a0] do_try_to_free_pages at ffffffff8113712f
>>>> #13 [ffff88177374b300] try_to_free_mem_cgroup_pages at ffffffff811372be
>>>> #14 [ffff88177374b380] try_charge at ffffffff81189423
>>>> #15 [ffff88177374b430] mem_cgroup_try_charge at ffffffff8118c6f5
>>>> #16 [ffff88177374b470] __add_to_page_cache_locked at ffffffff8112137d
>>>> #17 [ffff88177374b4e0] add_to_page_cache_lru at ffffffff81121618
>>>> #18 [ffff88177374b510] pagecache_get_page at ffffffff8112170b
>>>> #19 [ffff88177374b560] grow_dev_page at ffffffff811c8297
>>>> #20 [ffff88177374b5c0] __getblk_slow at ffffffff811c91d6
>>>> #21 [ffff88177374b600] __getblk_gfp at ffffffff811c92c1
>>>> #22 [ffff88177374b630] ext4_ext_grow_indepth at ffffffff8124565c
>>>> #23 [ffff88177374b690] ext4_ext_create_new_leaf at ffffffff81246ca8
>>>> #24 [ffff88177374b6e0] ext4_ext_insert_extent at ffffffff81246f09
>>>> #25 [ffff88177374b750] ext4_ext_map_blocks at ffffffff8124a848
>>>> #26 [ffff88177374b870] ext4_map_blocks at ffffffff8121a5b7
>>>> #27 [ffff88177374b910] mpage_map_one_extent at ffffffff8121b1fa
>>>> #28 [ffff88177374b950] mpage_map_and_submit_extent at ffffffff8121f07b
>>>> #29 [ffff88177374b9b0] ext4_writepages at ffffffff8121f6d5
>>>> #30 [ffff88177374bb20] do_writepages at ffffffff8112c490
>>>> #31 [ffff88177374bb30] __filemap_fdatawrite_range at ffffffff81120199
>>>> #32 [ffff88177374bb80] filemap_flush at ffffffff8112041c
>>
>> That's a potential self deadlocking path, isn't it? i.e. the
>> writeback path has been entered, may hold pages locked in the
>> current bio being built (waiting for submission), then memory
>> reclaim has been entered while trying to map more contiguous blocks
>> to submit, and that waits on page IO to complete on a page in a bio
>> that ext4 hasn't yet submitted?
>>
>> i.e. shouldn't ext4 be doing GFP_NOFS allocations all through this
>> writeback path?
> 
> All of the direct allocations in fs/ext4/extents.c are using GFP_NOFS.
> The problem is that we're calling sb_getblk(), which does _not_ set
> GFP_NOFS.  What we need to do is to add a sb_getblk_gfp() inline
> function in include/linux/buffer_head.h, and use that in
> fs/ext4/extents.c.

I've already sent your suggestion as a separate patch series, but what
about just changing sb_getblk to pass GFP_NOFS alongside _GFP_MOVABLE? I
see this function is purely FS related and is used a lot in various
FSes. Shouldn't it be prudent to change it and eliminate possible issues
in other filesystems as well (I haven't looked into detail the execution
context in other filesystems)?

> 
> Thanks for pointing that out!  I'll create a patch as soon as I get
> back from vacation.
> 
>        	   	    	 	     	      - Ted
> 
