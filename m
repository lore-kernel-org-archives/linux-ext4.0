From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] ext4: don't use quota reservation for speculative
	metadata blocks
Date: Mon, 12 Apr 2010 15:55:11 +0200
Message-ID: <20100412135511.GG12238@atrey.karlin.mff.cuni.cz>
References: <4BBCFD10.3030504@redhat.com> <87sk76tkx9.fsf@openvz.org> <4BBDF610.8030906@redhat.com> <87eiimtjne.fsf@openvz.org> <20100412131530.GB12238@atrey.karlin.mff.cuni.cz> <87iq7whk2t.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42413 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782Ab0DLNzM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 09:55:12 -0400
Content-Disposition: inline
In-Reply-To: <87iq7whk2t.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Jan Kara <jack@suse.cz> writes:
> 
> >> Eric Sandeen <sandeen@redhat.com> writes:
> >> 
> >> > Dmitry Monakhov wrote:
> >> >> Eric Sandeen <sandeen@redhat.com> writes:
> >> >> 
> >> >>> Because we can badly over-reserve metadata when we
> >> >>> calculate worst-case, it complicates things for quota, since
> >> >>> we must reserve and then claim later, retry on EDQUOT, etc.
> >> >>> Quota is also a generally smaller pool than fs free blocks,
> >> >>> so this over-reservation hurts more, and more often.
> >> >>>
> >> >>> I'm of the opinion that it's not the worst thing to allow
> >> >>> metadata to push a user slightly over quota.  This simplifies
> >> >>> the code and avoids the false quota rejections that result
> >> >>> from worst-case speculation.
> >> >> Hm.. Totally agree with issue description. And seem there is no another
> >> >> solution except yours.
> >> >> ASAIU alloc_nofail is called from places where it is impossible to fail
> >> >> an allocation even if something goes wrong.
> >> >> I ask because currently i'm working on EIO handling in alloc/free calls.
> >> >> I've found that it is useless to fail claim/free procedures because
> >> >> caller is unable to handle it properly.
> >> >> It is impossible to fail following operation
> >> >> ->writepage
> >> >>  ->dquot_claim_space (what to do if EIO happens?)
> >> >
> >> > Hm, if these start returning EIO then maybe my patch should be modified
> >> > to treat EDQUOT differently than EIO ... assuming callers can handle
> >> > the return at all.
> >> >
> >> > In other words, make NOFAIL really just mean "don't fail for EDQUOT"
> >> Yes. agree So we have two types of errors
> >> 1) expected errors: EDQUOT
> >> 2) fatal errors: (EIO/ENOSPC/ENOMEM)
> >> So we need two types of flags:
> >> 1)FORCE (IMHO it is better name than you proposed) to allow exceed a
> >>   quota limit
> >> 2)NOFAIL to allow ignore fatal errors.
> >> 
> >> We still need NOFAIL, because for example if something is happens in
> >> ->write_page()
> >>  ->dquot_claim()
> >>      update_quota() -> EIO  /* update disk quota */
> >>      update_bytes() /* update i_bytes count */
> >> It is obvious that write_page should fail because it is too late to
> >> return the error to userspace, so data will probably lost which
> >> is much more dramatic bug than quota inconsistency.
> >> So the only options we have is to:
> >> 1) Do not modify inode->i_bytes and return error which caller will
> >>    probably ignore. IMHO this is not good because result in
> >>    incorrect stat()
> >> 
> >> 2) do as much as we can (as it happens for now), modify inode->i_bytes
> >>    and return positive error code to caller.(which signal what error
> >>    result in quota inconsystency only)
> >   Yes, agreed that 2) is a better solution.
> >
> >> This fatal errors handling logic i'll post on top of your patch-set.
> >> But please change flag name from NOFAIL to FORCE.
> >   Hmm, do we really need to distinguish between your NOFAIL and FORCE?
> > I mean there are places where we can handle quota failures (both EDQUOT
> > or others) and places where we cannot and then we just want to go on as
> > seamlessly as possible. So NOFAIL flag seems to be enough...
> >   Now I agree that in theory there can be some caller which might wish
> > to seamlessly continue on EDQUOT and bail out on EIO but I'm not aware
> > of such callsite currently so there's no immediate need for the flag.
> > So Eric's patches seem to be fine to me as they are. What do you think?
> FORCE but without NOFAIL will be useful for example in
> write to fallocated area
> extent split/convert (uninitialized=>initialized conversion)
> It is not good idea to return EDQUOT from write to reserved area
> due to metadata overhead, but it is easy to handle EIO from that method.
> So IMHO two flags is not a fancy option, but reasonable design solution.
> This design confirms to right for openvz's userbean counters.
> The only thing i ask is to rename NOFAIL => FORCE.
  But as I wrote in my other email that callsite in ext4 really needs NOFAIL,
not only FORCE as far as I can see. So Eric's patch is actually right, isn't
it?

> BTW I'm too familiar with cross-devel-tree process
> If tytso@ will get the patchset will you get an quota-related patches
> to linux-fs tree too? Otherwise everybody have to wait for ext4-tree
> push to linus's tree and when to linux-fs.
  Yes, I can carry them in my tree as well (I think git is clever enough to
recognize identical patches in two different trees and do not conflict).
Only I can push the changes dependent on them only after Ted pushes his
tree to Linus.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
