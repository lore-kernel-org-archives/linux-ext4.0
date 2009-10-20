From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: changing stride and stripe_width post-fs-creation?
Date: Tue, 20 Oct 2009 16:16:47 -0500
Message-ID: <4ADE28BF.6000605@redhat.com>
References: <7284e2210910201032h74cf437bm6043d97748ece4c9@mail.gmail.com> <EA1A7036-FD43-4996-9665-E04FD32A449F@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Doug Hunley <doug@hunley.homeip.net>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZJTVQz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2009 17:16:55 -0400
In-Reply-To: <EA1A7036-FD43-4996-9665-E04FD32A449F@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 20-Oct-09, at 11:32, Doug Hunley wrote:
>> Is it safe to use tune2fs to alter stride and stripe_width on an ext4
>> fs once it has been created? Any caveats I should know about? Thanks
> 
> 
> The stride is mostly used at fs creation time, but there is no problem
> with changing it.  The stripe_width is used by the allocator to align
> file allocations with the RAID layout.
> 
> One question for Eric is whether the new libdisk patches he made will set
> the stripe_width to something ridiculous like 512 or 4096 bytes, or if it
> just leaves that field unset in that case.  I suspect it would be bad for
> mballoc to see the stripe_width be such a small value.

well... yes, it does set it to whatever is reported:

+       min_io = blkid_topology_get_minimum_io_size(tp);
+       opt_io = blkid_topology_get_optimal_io_size(tp);
+       blocksize = EXT2_BLOCK_SIZE(fs_param);
+
+       fs_param->s_raid_stride = min_io / blocksize;
+       fs_param->s_raid_stripe_width = opt_io / blocksize;


if mballoc can't handle certain values then maybe the kernel code should 
be changed to ignore it?  Small values could just as easily come from a 
user too ...

-Eric
