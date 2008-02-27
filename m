From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Date: Wed, 27 Feb 2008 21:39:30 +0200
Message-ID: <20080227193930.GE29269@cs181133002.pp.htv.fi>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218131209.GB21080@cs181133002.pp.htv.fi> <20080218132858.GA12568@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Andreas Dilger <adilger@sun.com>, sct@redhat.com,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34176 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038AbYB0Tkk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2008 14:40:40 -0500
Content-Disposition: inline
In-Reply-To: <20080218132858.GA12568@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2008 at 08:28:58AM -0500, Theodore Tso wrote:
> On Mon, Feb 18, 2008 at 03:12:09PM +0200, Adrian Bunk wrote:
> > If me resending this old patch collides with something finally getting a 
> > user this part of my patch shouldn't be applied now (but you might get 
> > it again in 6 months if it's still unused...).
> > 
> > But generally such conflicts would become visible if "known development 
> > trees that are intended for mainline" were in -mm.
> 
> It *has* been in -mm, except for periods when akpm has dropped it due
> to conflicts due to the "must have an in-tree user" doctrinaire
> attitude due to a conflict with the r/o bind patch.

OK, that's bad luck.

> Did you actually try to do a compile test, or only made sure the patch
> would apply?  The patch won't collide at application time, but it
> would when you compile it....

Yes, I do test compilations of all of my patches.

But I don't have an overview of all development trees for all 
subsystems.

> 						- Ted

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
