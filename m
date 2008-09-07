From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Sun, 7 Sep 2008 20:41:30 +0400
Message-ID: <20080907164130.GA3376@x200.localdomain>
References: <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907160414.GB26248@charite.de> <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907162447.GB32429@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	Andreas Dilger <adilger@sun.com>, akpm@osdl.org,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:63899 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYIGQjv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Sep 2008 12:39:51 -0400
Received: by ik-out-1112.google.com with SMTP id c28so624565ika.5
        for <linux-ext4@vger.kernel.org>; Sun, 07 Sep 2008 09:39:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080907162447.GB32429@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 07, 2008 at 12:24:47PM -0400, Theodore Tso wrote:
> On Sun, Sep 07, 2008 at 04:15:57PM +0400, Alexey Dobriyan wrote:
> > > Why not use strchr(), which is normally optimized assembly:
> > > 
> > > 	char *p = devname;
> > > 	while ((p = strchr(p, '/'))
> > > 		*p = '_';
> > > 
> > > Using '!' as the separator makes it harder to use from shells I suspect,
> > > so I'd suggest '_' instead.
> > 
> > bdevname is only 32 bytes and done once per mount, so nobody cares.
> 
> Bloat gets inserted into the kernel, 32 bytes at a time.  :-)

You mean, one filesystem at time. ;-)

> > '!' is what other code does in this situation (reiserfs, md, ...).
> 
> I'm not convinced that the consistency is as important in this case as
> making it easy for people using shells typing the pathname...

A what?

	mkdir z\!ext4
	ls z[Tab]\!ext4

As for underscore, use '-' if you really care about typing.
One Shift less.

register_disk() uses '!' too, BTW.

