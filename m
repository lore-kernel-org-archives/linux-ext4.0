From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Fri, 27 Oct 2006 09:24:24 -0500
Message-ID: <45421698.2070704@redhat.com>
References: <20061027162326sho@rifu.tnes.nec.co.jp>	<m3lkn2ryno.fsf@bzzz.home.net> <45420F76.90106@redhat.com> <m364e5svju.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sho@tnes.nec.co.jp, tytso@mit.edu, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m364e5svju.fsf@bzzz.home.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
>>>>>> Eric Sandeen (ES) writes:
> 
>  ES> Alex Tomas wrote:
>  >> 3) scalable reservation
>  >> required for delayed allocation to avoid -ENOSPC at flush time.
>  >> current version uses per-sb spinlock.
> 
>  ES> Can you elaborate on this issue?  Shouldn't delayed allocation
>  ES> decrement free space immediately, and only the actual block location
>  ES> choice is delayed?  Or is this due to potential extra metadata space
>  ES> required as blocks are allocated?
> 
> exactly. in this case, reservation has nothing to do with allocation
> or preallocation of real blocks. this is just a *per-sb counter* of
> blocks reserved for allocation at flush time. it includes all
> non-allocated-yet blocks and metadata needed to allocate them (bitmaps,
> group descriptors, blocks extent tree, etc). the previous version
> of mballoc has reservation, but it doesn't scale very well being
> a single global counter protected by the spinlock. at least, in many
> regular loads I observed the reservation function in top30 of oprofile.

Thanks. XFS recently made similar scalability changes in this area, see the 2006 
OLS paper, if you're interested.

-Eric
