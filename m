From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 23/25] libext2fs: support modifying arbitrary extended
 attributes
Date: Fri, 29 Nov 2013 09:17:07 +0100
Message-ID: <20131129081707.GD23954@quack.suse.cz>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045134.7339.30673.stgit@birch.djwong.org>
 <20131126072115.GA22136@gmail.com>
 <20131127015617.GC3068@birch.djwong.org>
 <20131129053013.GA25516@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab3K2IRK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Nov 2013 03:17:10 -0500
Content-Disposition: inline
In-Reply-To: <20131129053013.GA25516@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 29-11-13 13:30:13, Zheng Liu wrote:
> On Tue, Nov 26, 2013 at 05:56:17PM -0800, Darrick J. Wong wrote:
> [...]
> > > > +static struct ea_name_index ea_names[] = {
> > > > +	{1, "user."},
> > > > +	{2, "system.posix_acl_access"},
> > > > +	{3, "system.posix_acl_default"},
> > > > +	{4, "trusted."},
> > > > +	{6, "security."},
> > > > +	{7, "system."},
> > > 
> > > It seems that we also have a _RICHACL name here.
> > 
> > Yes.  Do you know what it's used for?  EXT4_XATTR_INDEX_RICHACL isn't used as
> > of 3.13-rc1.
> 
> Sorry, I just look at this mail.  If I remember correctly, this flag is
> added by Jan Kara because he want to reserve this flag for rich acl
> which has been implemented out of upstream kernel tree.
  Yes, SUSE kernels use EXT4_XATTR_INDEX_RICHACL to store Samba acls.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
