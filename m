From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Sun, 7 Sep 2008 12:24:47 -0400
Message-ID: <20080907162447.GB32429@mit.edu>
References: <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907160414.GB26248@charite.de> <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, akpm@osdl.org,
	linux-ext4@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>,
	Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54957 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757AbYIGQZE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Sep 2008 12:25:04 -0400
Content-Disposition: inline
In-Reply-To: <20080907160414.GB26248@charite.de> <20080907121557.GA3432@x200.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 07, 2008 at 04:15:57PM +0400, Alexey Dobriyan wrote:
> > Why not use strchr(), which is normally optimized assembly:
> > 
> > 	char *p = devname;
> > 	while ((p = strchr(p, '/'))
> > 		*p = '_';
> > 
> > Using '!' as the separator makes it harder to use from shells I suspect,
> > so I'd suggest '_' instead.
> 
> bdevname is only 32 bytes and done once per mount, so nobody cares.

Bloat gets inserted into the kernel, 32 bytes at a time.  :-)

> '!' is what other code does in this situation (reiserfs, md, ...).

I'm not convinced that the consistency is as important in this case as
making it easy for people using shells typing the pathname...


On Sun, Sep 07, 2008 at 06:04:14PM +0200, Ralf Hildebrandt wrote:
> 
> Anyway, the first patch fixes the issue. Will it go into mainline soon?
> 

I'll queue the patch (with fixups) for the 2.6.27 merge window.  This
isn't a regression, and it's getting rather late in the 2.6.27-rc
series.  I've bent the rules about submitting non-regression bug fixes
back when most ext4 users were testers or developers; but now that we
are getting real users, and Linus has started yelling at developers
for ignoring the merge window rules, I'm going to be much more of a
stickler about only pushing regression bug-fixes after the merge
window closes.

						- Ted
