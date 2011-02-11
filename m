From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Fri, 11 Feb 2011 12:16:58 +0100
Message-ID: <20110211111658.GA5187@quack.suse.cz>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <20110204130313.GB4104@quack.suse.cz>
 <316721F8-70CD-4E29-A94E-BFEF2D762829@dilger.ca>
 <20110207161933.GB5337@quack.suse.cz>
 <946A4527-3A1C-4EC5-BEAC-4E47F3CFDF01@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	ext4 List <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1BKLRA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Feb 2011 06:17:00 -0500
Content-Disposition: inline
In-Reply-To: <946A4527-3A1C-4EC5-BEAC-4E47F3CFDF01@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 07-02-11 08:35:31, Andreas Dilger wrote:
> On 2011-02-07, at 08:19, Jan Kara wrote:
> > On Fri 04-02-11 10:36:21, Andreas Dilger wrote:
> >> The question is whether we need to mimic the runtime behavior or just the
> >> on-disk format?  Apps already need to deal with ext4 and other fs that do
> >> not do ext3 ordered mode.
> > 
> >  Well written apps do, but badly written apps don't and e.g. our distro
> > customers don't always have the choice of the application. So as a developer
> > I see your point (screw stupidly written apps) but in the real world, I'm
> > afraid it's too hard on users.
> 
> We have to remember that this is only for new kernels, and does not
> affect older kernels or existing applications, so such users shouldn't be
> affected.
  Well, customers do upgrade distros and that means they get new kernels
but still they are bound to use the same app from their ISV so I don't
think there won't be users hitting this.

> >> I think the best road forward is to make ext4 the default for ext2 and
> >> ext3 filesystems in newer kernels, and mark ext2 and ext3 obsolete. This
> >> will start to get usage and testing of these other config options. The
> >> ext2 mode is already heavily tested at Google, and don't they also test
> >> noextent mode on updated filesystems, or were all of the filesystems
> >> reformatted with ext4 options?
> > 
> >  Yes, I know you are on relatively radical side ;). My position would be
> > to test ext4 for resonable combinations of options as ext2 driver and if
> > that works, switch ext2 as you describe. Then if it works fine for an year
> > or so, we can talk about ext3 but as James said, ext3 is still widely used
> > so there might be more friction on subtle runtime differences...
> 
> Since most new distros use ext4 by default, the point is kind of moot,
> because those users will get this behaviour in any case.  Relatively few
> users upgrade their kernel on a production system after it is installed,
> except for errata kernels, and I definitely wouldn't expect such a change
> to appear in an errata kernel.
Umm, lot of our customers upgrade even production systems (e.g. SLE10 SP3
-> SLE11 SP1 these days). But still, they keep the old filesystem (they do
not reformat their storage) because they were happy with how it worked. And
yes, they are happy about things that get better but loudly complain about
things that got worse for them.

Of course this does not have a perfect solution (someone will always
complain ;) but putting reasonable effort into making behavior of ext4
in the 'compatibility' mode not too much different from ext3 is IMHO decent
to users.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
