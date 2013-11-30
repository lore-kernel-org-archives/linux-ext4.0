From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 23/25] libext2fs: support modifying arbitrary extended
 attributes
Date: Sat, 30 Nov 2013 12:24:36 -0800
Message-ID: <20131130202436.GB9541@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045134.7339.30673.stgit@birch.djwong.org>
 <20131126072115.GA22136@gmail.com>
 <20131127015617.GC3068@birch.djwong.org>
 <20131129053013.GA25516@gmail.com>
 <20131129081707.GD23954@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3K3UYo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Nov 2013 15:24:44 -0500
Content-Disposition: inline
In-Reply-To: <20131129081707.GD23954@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 29, 2013 at 09:17:07AM +0100, Jan Kara wrote:
> On Fri 29-11-13 13:30:13, Zheng Liu wrote:
> > On Tue, Nov 26, 2013 at 05:56:17PM -0800, Darrick J. Wong wrote:
> > [...]
> > > > > +static struct ea_name_index ea_names[] = {
> > > > > +	{1, "user."},
> > > > > +	{2, "system.posix_acl_access"},
> > > > > +	{3, "system.posix_acl_default"},
> > > > > +	{4, "trusted."},
> > > > > +	{6, "security."},
> > > > > +	{7, "system."},
> > > > 
> > > > It seems that we also have a _RICHACL name here.
> > > 
> > > Yes.  Do you know what it's used for?  EXT4_XATTR_INDEX_RICHACL isn't used as
> > > of 3.13-rc1.
> > 
> > Sorry, I just look at this mail.  If I remember correctly, this flag is
> > added by Jan Kara because he want to reserve this flag for rich acl
> > which has been implemented out of upstream kernel tree.
>   Yes, SUSE kernels use EXT4_XATTR_INDEX_RICHACL to store Samba acls.

Just to confirm, the prefix is 'system.richacl'?

Also, does anyone know if the value 5 maps to anything?

/me adds the attribute name index map to the wiki page.

--D
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
