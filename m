From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 12:51:58 +0100
Message-ID: <20080421115158.GB4193@shareable.org>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org> <20080420234241.GB23292@shareable.org> <20080421080111.GD14446@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080421080111.GD14446@one.firstfloor.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andi Kleen wrote:
> On Mon, Apr 21, 2008 at 12:42:42AM +0100, Jamie Lokier wrote:
> > Andi Kleen wrote:
> > > [LVM] always disables barriers if you don't apply a so far unmerged
> > > patch that enables them in some special circumstances (only single
> > > backing device)
> > 
> > (I continue to be surprised at the un-safety of Linux fsync)
> 
> Note barrier less does not necessarily always mean unsafe fsync,
> it just often means that.
> 
> Also surprisingly lot more syncs or write cache off tend to lower the MTBF 
> of your disk significantly, so "unsafer" fsync might actually be more safe
> for your unbackuped data.

That's really interesting, thanks.  Do you have something to cite
about syncs reducing the MTBF?

( I'm really glad I added barriers instead of write cache off to my
2.4.26 based disk using devices now ;-) )

> > > Not having barriers sometimes makes your workloads faster (and less
> > > safe) and in other cases slower.
> > 
> > I'm curious, how does it make them slower?  Merely not issuing barrier
> > calls seems like it will always be the same speed or faster.
> 
> Some setups detect the no barrier case and switch to full sync +
> wait (or write cache off) which depending on the disk supporting NCQ
> can be slower.

But to issue full syncs, that's implemented as barrier calls in the
block request layers isn't it?  The filesystem isn't given a facility
to request the block device do full syncs or disable the write cache.

So when a blockdev doesn't offer barriers to the filesystem, it means
the driver doesn't support full syncs or cache disabling either, since
if it did, the request layer would expose them to the fs as barriers.

What am I missing from this picture?  Do you mean that manual setup
(such as by a DBA) tends to disable the write cache?

Thanks,
-- Jamie
