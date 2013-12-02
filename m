From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 23/25] libext2fs: support modifying arbitrary extended
 attributes
Date: Mon, 2 Dec 2013 09:38:33 +0100
Message-ID: <20131202083833.GB2188@quack.suse.cz>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045134.7339.30673.stgit@birch.djwong.org>
 <20131126072115.GA22136@gmail.com>
 <20131127015617.GC3068@birch.djwong.org>
 <20131129053013.GA25516@gmail.com>
 <20131129081707.GD23954@quack.suse.cz>
 <20131130202436.GB9541@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3LBIif (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 03:38:35 -0500
Content-Disposition: inline
In-Reply-To: <20131130202436.GB9541@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 30-11-13 12:24:36, Darrick J. Wong wrote:
> On Fri, Nov 29, 2013 at 09:17:07AM +0100, Jan Kara wrote:
> > On Fri 29-11-13 13:30:13, Zheng Liu wrote:
> > > On Tue, Nov 26, 2013 at 05:56:17PM -0800, Darrick J. Wong wrote:
> > > [...]
> > > > > > +static struct ea_name_index ea_names[] = {
> > > > > > +	{1, "user."},
> > > > > > +	{2, "system.posix_acl_access"},
> > > > > > +	{3, "system.posix_acl_default"},
> > > > > > +	{4, "trusted."},
> > > > > > +	{6, "security."},
> > > > > > +	{7, "system."},
> > > > > 
> > > > > It seems that we also have a _RICHACL name here.
> > > > 
> > > > Yes.  Do you know what it's used for?  EXT4_XATTR_INDEX_RICHACL isn't used as
> > > > of 3.13-rc1.
> > > 
> > > Sorry, I just look at this mail.  If I remember correctly, this flag is
> > > added by Jan Kara because he want to reserve this flag for rich acl
> > > which has been implemented out of upstream kernel tree.
> >   Yes, SUSE kernels use EXT4_XATTR_INDEX_RICHACL to store Samba acls.
> 
> Just to confirm, the prefix is 'system.richacl'?
  Yes.

> Also, does anyone know if the value 5 maps to anything?
  I'm not aware of anything.

> /me adds the attribute name index map to the wiki page.
  Thanks!

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
