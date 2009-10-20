From: Andreas Dilger <adilger@sun.com>
Subject: Re: changing stride and stripe_width post-fs-creation?
Date: Tue, 20 Oct 2009 15:30:59 -0600
Message-ID: <0ABACA66-004A-43AE-83B0-203CFD73AB86@sun.com>
References: <7284e2210910201032h74cf437bm6043d97748ece4c9@mail.gmail.com>
 <EA1A7036-FD43-4996-9665-E04FD32A449F@sun.com> <4ADE28BF.6000605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Doug Hunley <doug@hunley.homeip.net>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43678 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbZJTVa4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 17:30:56 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n9KLV0EY009279
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 14:31:00 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KRU00G000TPZB00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 20 Oct 2009 14:31:00 -0700 (PDT)
In-reply-to: <4ADE28BF.6000605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 20-Oct-09, at 15:16, Eric Sandeen wrote:
> Andreas Dilger wrote:
>> The stride is mostly used at fs creation time, but there is no  
>> problem
>> with changing it.  The stripe_width is used by the allocator to align
>> file allocations with the RAID layout.
>> One question for Eric is whether the new libdisk patches he made  
>> will set
>> the stripe_width to something ridiculous like 512 or 4096 bytes, or  
>> if it
>> just leaves that field unset in that case.  I suspect it would be  
>> bad for
>> mballoc to see the stripe_width be such a small value.
>
> well... yes, it does set it to whatever is reported:
>
> +       min_io = blkid_topology_get_minimum_io_size(tp);
> +       opt_io = blkid_topology_get_optimal_io_size(tp);
> +       blocksize = EXT2_BLOCK_SIZE(fs_param);
> +
> +       fs_param->s_raid_stride = min_io / blocksize;
> +       fs_param->s_raid_stripe_width = opt_io / blocksize;
>
>
> if mballoc can't handle certain values then maybe the kernel code  
> should be changed to ignore it?  Small values could just as easily  
> come from a user too

That probably makes the most sense to have the kernel ignore the  
value.  It's
not that it can't "handle" it, just that I suspect mballoc will work  
poorly if
it is trying to align the allocations to 1-block values (i.e. no  
alignment at
all).  Even with regular disks, reading in 64kB-aligned chunks is more  
efficient
than reading misaligned chunks because of the track buffer.

Probably ignoring anything below 64kB makes sense, or possibly using  
some
multiple of the specified size until it is larger than 64kB is better  
(in
case someone formats their RAID-5 with 5 disks * 8kB chunk size or  
similar).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

