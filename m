From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Mon, 7 Feb 2011 17:19:33 +0100
Message-ID: <20110207161933.GB5337@quack.suse.cz>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <20110204130313.GB4104@quack.suse.cz>
 <316721F8-70CD-4E29-A94E-BFEF2D762829@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	"lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab1BGQTg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 11:19:36 -0500
Content-Disposition: inline
In-Reply-To: <316721F8-70CD-4E29-A94E-BFEF2D762829@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 04-02-11 10:36:21, Andreas Dilger wrote:
> On 2011-02-04, at 6:03, Jan Kara <jack@suse.cz> wrote:
> >> I think that ext4 with nodelalloc should mostly mimic ext3 in those
> >> cases, no?
> >  Yeah, mostly. The biggest obstacle I see here is the different behavior
> > of mmap - with nodelalloc allocation happens at the time of page fault and
> > that fragments the file like hell for some kinds of load. Since ext3 here
> > essentially does delayed allocation, it might be useful to do delayed
> > allocation only from page fault path when we try to mimic ext3 behavior.
> > So mimicking ext3 is possible but needs some tweaks...
> 
> The question is whether we need to mimic the runtime behavior or just the
> on-disk format?  Apps already need to deal with ext4 and other fs that do
> not do ext3 ordered mode. 
  Well written apps do, but badly written apps don't and e.g. our distro
customers don't always have the choice of the application. So as a developer
I see your point (screw stupidly written apps) but in the real world, I'm
afraid it's too hard on users.

> >> If we can have a real plan for moving in this direction though, I'd
> >> support it.  I'm just not sure how we get enough real testing under
> >> our belts to be comfortable with dropping ext[23], especially as
> >> most distros now default to ext4 anyway.
> >  Well, I believe this actually works for us. If the real users move to
> > ext4 (or a different fs), then it's easier to make ext[23] mode in ext4
> > good enough for the few legacy users...
> 
> I think the best road forward is to make ext4 the default for ext2 and
> ext3 filesystems in newer kernels, and mark ext2 and ext3 obsolete. This
> will start to get usage and testing of these other config options. The
> ext2 mode is already heavily tested at Google, and don't they also test
> noextent mode on updated filesystems, or were all of the filesystems
> reformatted with ext4 options?
  Yes, I know you are on relatively radical side ;). My position would be
to test ext4 for resonable combinations of options as ext2 driver and if
that works, switch ext2 as you describe. Then if it works fine for an year
or so, we can talk about ext3 but as James said, ext3 is still widely used
so there might be more friction on subtle runtime differences...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
