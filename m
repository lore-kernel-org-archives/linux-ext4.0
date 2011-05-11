From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext3: Implement delayed allocation on page_mkwrite
 time
Date: Wed, 11 May 2011 17:38:41 +0200
Message-ID: <20110511153841.GG5057@quack.suse.cz>
References: <1304369816-14545-1-git-send-email-jack@suse.cz>
 <1304369816-14545-5-git-send-email-jack@suse.cz>
 <20110502141230.4a7640f9.akpm@linux-foundation.org>
 <20110502222020.GB14889@quack.suse.cz>
 <20110502152917.550d2475.akpm@linux-foundation.org>
 <20110503170948.GE6009@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52237 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab1EKP6S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2011 11:58:18 -0400
Content-Disposition: inline
In-Reply-To: <20110503170948.GE6009@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 03-05-11 19:09:48, Jan Kara wrote:
> On Mon 02-05-11 15:29:17, Andrew Morton wrote:
> > On Tue, 3 May 2011 00:20:20 +0200
> > Jan Kara <jack@suse.cz> wrote:
> > > On Mon 02-05-11 14:12:30, Andrew Morton wrote:
> > > > On Mon,  2 May 2011 22:56:56 +0200
> > > > Jan Kara <jack@suse.cz> wrote:
> > > > 
> > > > > So far, ext3 was allocating necessary blocks for mmapped writes when
> > > > > writepage() was called. There are several issues with this. The worst
> > > > > being that user is allowed to arbitrarily exceed disk quotas because
> > > > > writepage() is called from flusher thread context (which is root) and thus
> > > > > quota limits are ignored. Another bad consequence is that data is just lost
> > > > > if we find there's no space on the filesystem during ->writepage() time.
> > > > > 
> > > > > We solve these issues by implementing block reservation in page_mkwrite()
> > > > > callback. We don't want to really allocate blocks on page_mkwrite() time
> > > > > because for random writes via mmap (as seen for example with applications using
> > > > > BerkeleyDB) it results in much more fragmented files and thus much worse
> > > > > performance. So we allocate indirect blocks and reserve space for data block in
> > > > > page_mkwrite() and do the allocation of data block from writepage().
> > > > 
> > > > Yes, instantiating the metadata and accounting the data is a good
> > > > approach.  The file layout will be a bit suboptimal, but surely that
> > > > will be a minor thing.
> > > > 
> > > > But boy, it's a complicated patch!  Are we really sure that we want to
> > > > make changes this extensive to our antiquated old fs?  Or do we just
> > > > say "yeah, it's broken with quotas - use ext4"?
> > >   The patch isn't trivial, I agree (although it's mostly straightforward).
> > > Regarding telling users to switch to ext4 - it seems a bit harsh to me
> > > to ask people to switch to ext4 as a response to a (possibly security)
> > > issue they uncover. Because for most admins switching to ext4 will require
> > > some non-trivial testing I presume. Of course, the counterweight is the
> > > possibility of new bugs introduced to the code by my patch.
> > 
> > Yes.
> > 
> > > But after some
> > > considerations I've decided it's worth it and and fixed the bug...
> > 
> > Well.  How did you come to that decision?
>   So my thoughts were: If a company runs a hosting or similar service and
> some load either inadvertedly or even maliciously triggers this bug, your
> systems can be DOSed. That's bad and you need to fix that ASAP. From my
> experience with our SLE customers, they are willing to listen to advices
> such as fs choice when they plan a system deployment. After that they
> vehemently refuse any major change (and fs driver change is a major one).
> So I'm quite certain they'd rather accept this largish ext3 change.
> Finally, admittedly, I didn't think the patch will end up so large.
> 
> Looking into the patch, I could split off some cleanups and code
> reorganizations which are 20-30% of the patch but it probably does not make
> sense to split it more. What I think is a plus of the patch is that there
> are only two code paths that really change - ext3_get_blocks() has two new
> cases how it is called (to allocate only indirect blocks and to allocate
> already reserved data block) and trucate path which has to do more work to
> check whether indirect block can be removed.
>   
> > Are real users hurting from this problem?
>   I've got a report of this from NEC
> (http://ns3.spinics.net/lists/linux-ext4/msg20239.html) and OpenVZ people
> were also concerned
> (http://ns3.spinics.net/lists/linux-ext4/msg20288.html). I think there was
> one more report of this problem but I can't find it now. So yes, there are
> users who care.
> 
> >  What's the real-world case for fixing it?
>   Sorry, I don't understand the question (or how it is different from the
> previous one).
  Andrew, does this change your opinion in any way?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
