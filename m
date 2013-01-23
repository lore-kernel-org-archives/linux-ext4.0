From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: check incompatible mount options when mounting
 ext2/3 [V2]
Date: Wed, 23 Jan 2013 14:00:37 +0100
Message-ID: <20130123130037.GA23741@quack.suse.cz>
References: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com>
 <1358870878-7369-1-git-send-email-cmaiolino@redhat.com>
 <20130123103917.GD9821@quack.suse.cz>
 <20130123122249.GA1423@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab3AWNAi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2013 08:00:38 -0500
Content-Disposition: inline
In-Reply-To: <20130123122249.GA1423@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 23-01-13 07:22:49, Carlos Maiolino wrote:
> On Wed, Jan 23, 2013 at 11:39:17AM +0100, Jan Kara wrote:
> > On Tue 22-01-13 11:07:58, Carlos Maiolino wrote:
> > > This checks for incompatible mounting options when using ext4 module to mount
> > > ext3 or ext2 filesystems.
> > > 
> > > Sets two new flags to group ext4 mount options that are incompatible with ext2
> > > and ext3, and then add two functions -- check_ext2/3_incompat_mount() -- to
> > > check and warn/fail mount, if any of these options are being used.
> > > 
> > > I believe, some options like those expecting an argument needs to be checked
> > > during parsing time.
> > > 
> > > barrier mount, although it has a flag, when mounting an ext2fs, where
> > > barriers are not supported (afaik), should also be checked during parse
> > > time, otherwise the BARRIER mount flag will be set.
> > > 
> > > I didn't add all mount options I believe to need to raise a warning, just
> > > those with a flag set on superblock, another flags should be added after a
> > > discussion to reach a concensus of all ext2/3 options that should be rejected by
> > > ext4 mount.
> >   Thinking about it a bit more I'm not sure if restricting mount options is
> > the right thing to start with.  IMHO what we should restrict is mounting
> > filesystem with certain *features* as ext3/ext2. So e.g. filesystem with
> > EXT4_FEATURE_INCOMPAT_EXTENTS cannot be mounted as ext2 or ext3. Similarly
> > as currently we forbid mounting ext3 filesystem with
> > EXT3_FEATURE_INCOMPAT_RECOVER as ext2... This should avoid the confusion
> > which could arise when someone reports problems with "ext3" filesystem but
> > actually has some of the ext4 features enabled.
> > 
> This is interesting, but I wonder if not restricting mount options, but
> features, would open a 'window' to let users change their filesystem on-disk
> format without know what they are doing, but I might be wrong.
  If there are mount options that enable features, then these should be
disallowed for ext2/ext3 mounts. But I think we already got rid of these
traps on users...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
