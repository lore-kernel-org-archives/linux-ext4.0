From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Fri, 4 Feb 2011 14:03:13 +0100
Message-ID: <20110204130313.GB4104@quack.suse.cz>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linuxfoundation.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1BDNFc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Feb 2011 08:05:32 -0500
Content-Disposition: inline
In-Reply-To: <4D4AC4E2.701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 03-02-11 09:08:18, Eric Sandeen wrote:
> On 2/3/11 8:40 AM, Jan Kara wrote:
> > As you well know, there are three independent code bases in kernel
> > implementing ext-based filesystems - ext2, ext3, and ext4. Of course it
> > costs some effort to maintain them all in a reasonably good condition so
> > once in a while someone comes and proposes we should drop one of ext2, ext3
> > or both. So I'd like to gather input what people think about this - should
> > we ever drop ext2 / ext3 codebases? If yes, under what condition do we deem
> > it is OK to drop it?
> > 
> > To give some facts:
> > Feature-wise, ext4 should now be almost a superset of both ext2 and
> > ext3. ext4 has nojournal mode to simulate ext2, looking at the code I only
> > don't see XIP support in ext4, arguably also nobh-mode but I personally
> > feel that these days the complication in the code isn't worth it. As far as
> > I know it should be backward compatible to writeably mount ext2/ext3
> > filesystem with ext4 (i.e., no incompatible features should be turned on
> > magically).
> > 
> > On the other hand there are differences noticeable under some conditions -
> > e.g. delayed allocation, data=ordered mode of ext3 gives better data
> > integrity than that of ext4 in practice (it's just a side effect we never
> > promised but app developers somehow got used to it ;), different allocation
> > decisions, and I believe there are more of these subtle differences.
> 
> I think that ext4 with nodelalloc should mostly mimic ext3 in those
> cases, no?
  Yeah, mostly. The biggest obstacle I see here is the different behavior
of mmap - with nodelalloc allocation happens at the time of page fault and
that fragments the file like hell for some kinds of load. Since ext3 here
essentially does delayed allocation, it might be useful to do delayed
allocation only from page fault path when we try to mimic ext3 behavior.
So mimicking ext3 is possible but needs some tweaks...

> > Then of course there is the factor of the codebase itself: Ext2 - ~9k
> > lines, Ext3+JBD - 24k lines, Ext4+JBD2 - 43k lines. Ext2 codebase is so
> > simple that it sometimes serves as a "model filesystem". But arguably it
> > also bitrots slowly so copy-and-pasting from ext2 need not be clever idea
> > anymore.
> 
> Yep at one point it was asserted that ext2 was a model filesystem and should
> therefore be kept around, but I agree with you that it may not really 
> serve that purpose too well.
> 
> While I'm no fan of having 3 kinda-similar codebases that must be maintained,
> my concerns would be:
> 
> 1) ext4 is still in active development, and may introduce instabilities
>    that ext3 would otherwise avoid.
  Sure but since ext4 is now pushed in RHEL, Fedora, openSUSE, Ubuntu, we
should be already really careful not to break stuff. I agree there is
higher potential for bugs in ext4 but sometime it should be good enough I
hope ;). And it's exactly this "sometime" which I'd like to get some
concesus on.

> 2) ext4's more, um ... unique option combinations probably get next to
>    no testing in the real world.  So while we can say that noextent,
>    nodelalloc is mostly like ext3, in practice, does that ever really
>    get much testing?
  Yes. We definitely cannot remove old codebase until the equivalent paths
in ext4 won't be beaten regularly and hard. So I agree there is definitely
lots of testing ahead if we decide to move towards removing old code.

> If we can have a real plan for moving in this direction though, I'd
> support it.  I'm just not sure how we get enough real testing under
> our belts to be comfortable with dropping ext[23], especially as
> most distros now default to ext4 anyway.
  Well, I believe this actually works for us. If the real users move to
ext4 (or a different fs), then it's easier to make ext[23] mode in ext4
good enough for the few legacy users...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
