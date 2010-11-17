From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Wed, 17 Nov 2010 15:38:45 +1100
Message-ID: <20101117043845.GA3586@amd>
References: <20101116110058.GA4298@amd>
 <20101116130146.GG4757@quack.suse.cz>
 <4CE35A6D.2040906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28518 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932950Ab0KQEiz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 23:38:55 -0500
Content-Disposition: inline
In-Reply-To: <4CE35A6D.2040906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 10:30:37PM -0600, Eric Sandeen wrote:
> On 11/16/10 7:01 AM, Jan Kara wrote:
> > On Tue 16-11-10 22:00:58, Nick Piggin wrote:
> >> I saw a lock order warning on ext4 trigger. This should solve it.
> >> Raciness shouldn't matter much, because writeback can stop just
> >> after we make the test and return anyway (so the API is racy anyway).
> >   Hmm, for now the fix is OK. Ultimately, we probably want to call
> > writeback_inodes_sb() directly from all the callers. They all just want to
> > reduce uncertainty of delayed allocation reservations by writing delayed
> > data and actually wait for some of the writeback to happen before they
> > retry again the allocation.
> 
> For ext4, at least, it's just best-effort.  We're not actually out of
> space yet when this starts pushing.  But it helps us avoid enospc:
> 
> commit c8afb44682fcef6273e8b8eb19fab13ddd05b386
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Wed Dec 23 07:58:12 2009 -0500
> 
>     ext4: flush delalloc blocks when space is low
>     
>     Creating many small files in rapid succession on a small
>     filesystem can lead to spurious ENOSPC; on a 104MB filesystem:
>     
>     for i in `seq 1 22500`; do
>         echo -n > $SCRATCH_MNT/$i
>         echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
>     done
>     
>     leads to ENOSPC even though after a sync, 40% of the fs is free
>     again.
> 
>     <snip>
> 
> We don't need it to be synchronous - in fact I didn't think it was ...

By synchronous, I just mean that the caller is the one who pushes
the data into writeout. It _may_ be better if it was done by background
writeback, with a feedback loop to throttle the caller (preferably
placed outside any locks it is holding).

To be pragmatic, I think the thing is fine to actually solve the
problem at hand. I was just saying that it has a tiny little hackish
feeling anyway, so a trylock will be right at home there :)

 
> ext4 should probably use btrfs's new variant and just get rid of the
> one I put in, for a very large system/filesystem it could end up doing
> a rather insane amount of IO when the fs starts to get full.
> 
> as for the locking problems ... sorry about that!

That's no problem. So is that an ack? :)

