From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: remove metadata reservation checks
Date: Fri, 27 Jun 2014 13:29:50 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406271316300.2349@localhost.localdomain>
References: <1403490981-5457-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1406231140560.2169@localhost.localdomain> <20140623125958.GB14887@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1929671767-1403868593=:2349"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbaF0L3z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jun 2014 07:29:55 -0400
In-Reply-To: <20140623125958.GB14887@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1929671767-1403868593=:2349
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 23 Jun 2014, Theodore Ts'o wrote:

> Date: Mon, 23 Jun 2014 08:59:58 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH] ext4: remove metadata reservation checks
> 
> On Mon, Jun 23, 2014 at 11:56:23AM +0200, Lukáš Czerner wrote:
> > 
> > However I am still on the fence about this patch, because it was not
> > designed, at least initially to cover all metadata reservation, but
> > mainly those we sometimes can not predict (unwritten extent
> > conversion for example), or those when the prediction failed (in
> > this case we would see a warning).
> 
> I was driven to revisit this because we have a map reduce workload
> that triggers the warning fairly consistently, and it's dirtying up
> our logs and monitoring systems.  The prediction algorithm we are
> using is actually pretty awful, unfortunately, and fixing it to do a
> better job is non-trivial.

Fair enough. I think that removing all the metadata reservation in
favour of the pool of reserved blocks for metadata is the right way
to go. We get rid of some of the complexity and it will become
easier to make sure that we will have enough blocks for metadata
allocation.

> 
> > I think that if we can be really sure, that the reserved space will
> > always have enough space to cover all possible metadata blocks
> > needed on writeback time (is there any other time we might need
> > metadata block and can not fail with ENOSPC?), then this patch is
> > definitely very useful.
> 
> The only time we need blocks where we can't fail with ENOSPC is
> delayed allocation writeback and the unwritten extent conversion.  And
> in both cases, the number of blocks we need are quite small; we can,
> after all, fit 340 entries into each extent tree block.
> 
> The main worry I might have is the worst case scenario where have a
> very small file system.  For example, if you create a file system
> which is only 58k, we only have one free block.  But then again, such
> a file system only has 4 free blocks, so it's physically impossible to
> have any extent tree blocks.  :-)
> 
> Here's a potential carefully structured case where 2% of the free
> blocks wouldn't be enough.  I'll let folks decide if we think this is
> realistic enough that we need to care.  Suppose we have a 4M file
> system, using 4k blocks, we would only have 51 reserved blocks.  On
> such a file system, there would be 982 free blocks available to be
> allocated.  If you then had 200 inodes that had exactly 4 extents
> (using 4 blocks written using sparse writes), then there would be 182
> free blocks.  If we then posted 100 sparse writes to half of these
> inodes, we could end up using 100 data blocks, and also require 100
> metadata blocks for the extent tree splits --- and we would then hit
> the ENOSPC failure condition.

That is a perfect test case :) But seriously I think that we might
want to do better than just hand wave 2% and be done with it. It is
rather arbitrary number I've used, but it was supposed to be a last
resort solution, not the regular allocation pattern.

Also for huge file system this pool might be unnecessarily large, so
we might want to come up with a better heuristic to guess the size
of the pool.

On the other hand, this is something we can add later as well as
export better information about the pool utilization to the user. I
am just trying to be careful because this really is a big change and
there might be some unexpected consequences and we do not have
exactly huge amount of enospc regression tests.

> 
> So this is a "proof" that 2% is quite enough for small file systems.
> Do we care?  Eh.  I'm not at all convinced such a worst case scenario
> could ever happen in real life, but we could fix this by adding a
> "floor" to the 2% calculation so that we reserve at least 128 or 256
> blocks.  Or we already have code which disables delayed allocation if
> we are close to full, and we could extend that to cover super small
> file systems, or simply entirely disable delalloc for super small file
> systems in the first case.

yes this is yet another thing we can use to make it more solid.

Thanks!
-Lukas
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1929671767-1403868593=:2349--
