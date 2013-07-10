From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: Try to better reuse recently freed space
Date: Wed, 10 Jul 2013 13:18:05 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1307101301240.4122@localhost.localdomain>
References: <alpine.LFD.2.00.1307041730590.30302@localhost.localdomain> <1373269107-9678-1-git-send-email-lczerner@redhat.com> <20130708085603.GB5988@quack.suse.cz> <alpine.LFD.2.00.1307081108380.1843@localhost.localdomain>
 <20130708115951.GC5988@quack.suse.cz>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-925185708-1373455088=:4122"
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab3GJLSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jul 2013 07:18:11 -0400
In-Reply-To: <20130708115951.GC5988@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-925185708-1373455088=:4122
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 8 Jul 2013, Jan Kara wrote:

> Date: Mon, 8 Jul 2013 13:59:51 +0200
> From: Jan Kara <jack@suse.cz>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
>     Andreas Dilger <adilger.kernel@dilger.ca>
> Subject: Re: [PATCH v2] ext4: Try to better reuse recently freed space
> 
> On Mon 08-07-13 11:24:01, Lukáš Czerner wrote:
> > On Mon, 8 Jul 2013, Jan Kara wrote:
> > 
> > > Date: Mon, 8 Jul 2013 10:56:03 +0200
> > > From: Jan Kara <jack@suse.cz>
> > > To: Lukas Czerner <lczerner@redhat.com>
> > > Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
> > >     Andreas Dilger <adilger.kernel@dilger.ca>
> > > Subject: Re: [PATCH v2] ext4: Try to better reuse recently freed space
> > > 
> > > On Mon 08-07-13 09:38:27, Lukas Czerner wrote:
> > > > Currently if the block allocator can not find the goal to allocate we
> > > > would use global goal for stream allocation. However the global goal
> > > > (s_mb_last_group and s_mb_last_start) will move further every time such
> > > > allocation appears and never move backwards.
> > > > 
> > > > This causes several problems in certain scenarios:
> > > > 
> > > > - the goal will move further and further preventing us from reusing
> > > >   space which might have been freed since then. This is ok from the file
> > > >   system point of view because we will reuse that space eventually,
> > > >   however we're allocating block from slower parts of the spinning disk
> > > >   even though it might not be necessary.
> > > > - The above also causes more serious problem for example for thinly
> > > >   provisioned storage (sparse images backed storage as well), because
> > > >   instead of reusing blocks which are already provisioned we would try
> > > >   to use new blocks. This would unnecessarily drain storage free blocks
> > > >   pool.
> > > > - This will also cause blocks to be allocated further from the given
> > > >   goal than it's necessary. Consider for example truncating, or removing
> > > >   and rewriting the file in the loop. This workload will never reuse
> > > >   freed blocks until we continually claim and free all the block in the
> > > >   file system.
> > > > 
> > > > Note that file systems like xfs, ext3, or btrfs does not have this
> > > > problem. This is simply caused by the notion of global pool.
> > > > 
> > > > Fix this by changing the global goal to be goal per inode. This will
> > > > allow us to invalidate the goal every time the inode has been truncated,
> > > > or newly created, so in those cases we would try to use the proper more
> > > > specific goal which is based on inode position.
> > >   When looking at your patch for second time, I started wondering, whether
> > > we need per-inode stream goal at all. We already do set goal in the
> > > allocation request for mballoc (ar->goal) e.g. in ext4_ext_find_goal().
> > > It seems strange to then reset it inside mballoc and I don't even think
> > > mballoc will change it to something else now when the goal is per-inode and
> > > not global.
> > 
> > Yes, we do set the goal in the allocation request and it is supposed
> > to be the "best" goal. However sometimes it can not be fulfilled
> > because we do not have any free block at "goal".
> > 
> > That's when the global (or per-inode) goal comes into play. I suppose
> > that there was several reasons for that. First of all it makes it
> > easier for allocator, because it can directly jump at the point
> > where we allocated last time and it is likely that there is some
> > free space to allocate from - so the benefit is that we do not have
> > to walk all the space in between which is likely to be allocated.
>   Yep, but my question is: If we have per-inode streaming goal, can you
> show an example when the "best" goal will be different from the "streaming"
> goal? Because from a (I admit rather quick) look at how each of these is
> computed, it seems that both will point after the next allocated block in
> case of streaming IO.

EXT4_MB_STREAM_ALLOC or "streaming IO" is quite misleading name for
what we have in ext4. It simply means that the file (or allocation)
is bigger than certain threshold.

So I think that one example would be when writing in the middle of
sparse file when other processes might have already allocated
requested blocks. This might be the case for file system images for
example. Also for some reason I am seeing this when writing into
file system image even though there are no other processes
allocating from that file system.

Simply hacking ext4 to print out the numbers when the goals differs
and running xfstests shows that there are cases where it differs and
where it helps to allocate from the per-inode goal.

-Lukas

> 
> 								Honza
> 
--8323328-925185708-1373455088=:4122--
