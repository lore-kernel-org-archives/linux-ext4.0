From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Sun, 7 Sep 2008 16:15:57 +0400
Message-ID: <20080907121557.GA3432@x200.localdomain>
References: <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ralf.hildebrandt@charite.de, akpm@osdl.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:3430 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbYIGMON (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Sep 2008 08:14:13 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1154934fgg.17
        for <linux-ext4@vger.kernel.org>; Sun, 07 Sep 2008 05:14:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080906075713.GM3086@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 06, 2008 at 01:57:13AM -0600, Andreas Dilger wrote:
> On Sep 06, 2008  01:06 +0400, Alexey Dobriyan wrote:
> > [PATCH] ext4: fix #11321: create /proc/ext4/*/stats more carefully
> > 
> > ext4 creates per-suberblock directory in /proc/ext4/ . Name used as
> > basis is taken from bdevname, which, surprise, can contain slash.
> > 
> > However, proc while allowing to use proc_create("a/b", parent) form of
> > PDE creation, assumes that parent/a was already created.
> > 
> > bdevname in question is 'cciss/c0d0p9', directory is not created and all
> > this stuff goes directly into /proc (which is real bug).
> > 
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -2792,6 +2792,15 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
> >  		return -EINVAL;
> >  	}
> >  	bdevname(sb->s_bdev, devname);
> > +	{
> > +		char *p = devname;
> > +
> > +		while (*p != '\0') {
> > +			if (*p == '/')
> > +				*p = '!';
> > +			p++;
> > +		}
> > +	}
> 
> Why not use strchr(), which is normally optimized assembly:
> 
> 	char *p = devname;
> 	while ((p = strchr(p, '/'))
> 		*p = '_';
> 
> Using '!' as the separator makes it harder to use from shells I suspect,
> so I'd suggest '_' instead.

bdevname is only 32 bytes and done once per mount, so nobody cares.

'!' is what other code does in this situation (reiserfs, md, ...).

