From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Date: Wed, 2 Jan 2008 21:51:46 +0200
Message-ID: <20080102195146.GB15898@does.not.exist>
References: <20080102013218.GO27566@does.not.exist> <20080102174157.GD3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33385 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbYABTwF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2008 14:52:05 -0500
Content-Disposition: inline
In-Reply-To: <20080102174157.GD3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2008 at 10:41:57AM -0700, Andreas Dilger wrote:
> On Jan 02, 2008  03:32 +0200, Adrian Bunk wrote:
> > It might make sense to offer ext4 in -mm and even in early -rc kernels, 
> > but I've already seen people using ext4 simply because a stable kernel 
> > offered it - and that's definitely not intended.
> > 
> > Anyone who _really_ wants to test ext4 should anyway be able to do the 
> > trivial change of removing the "depends on BROKEN" line.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > @@ -138,7 +138,7 @@ config EXT3_FS_SECURITY
> >  
> >  config EXT4DEV_FS
> >  	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
> > -	depends on EXPERIMENTAL
> > +	depends on BROKEN
> >  	select JBD2
> >  	select CRC16
> >  	help
> 
> Isn't CONFIG_EXPERIMENTAL enough?

Most people and all distributions use CONFIG_EXPERIMENTAL=y simply 
because too many options (including options required for hardware 
support) depend on it.

Compare e.g.:
- "Marvell SATA support (HIGHLY EXPERIMENTAL)"
- "Provide NFSv4 client support (EXPERIMENTAL)"
- "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"

And I really do not have the impression that ext4 is ready for being 
used by people who cannot remove this depends line from a Kconfig file
in their kernel.

> Cheers, Andreas

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
