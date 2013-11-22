From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: check incompatible mount options when mounting
 ext2/3 [V2]
Date: Thu, 21 Nov 2013 23:43:59 -0200
Message-ID: <20131122014358.GA7134@orion.maiolino.org>
References: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com>
 <1358870878-7369-1-git-send-email-cmaiolino@redhat.com>
 <20130123103917.GD9821@quack.suse.cz>
 <20130123122249.GA1423@localhost.localdomain>
 <20130123130037.GA23741@quack.suse.cz>
 <20131031140040.GD14337@orion.maiolino.org>
 <20131119183923.GA29056@orion.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3KVBoI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Nov 2013 20:44:08 -0500
Content-Disposition: inline
In-Reply-To: <20131119183923.GA29056@orion.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nevermind, I noticed Ted committed a patch with a different approach of this
issue.


On Tue, Nov 19, 2013 at 04:39:28PM -0200, Carlos Maiolino wrote:
> Ping?
> 
> On Thu, Oct 31, 2013 at 12:00:41PM -0200, Carlos Maiolino wrote:
> > Hi guys, my apologies to have not touched this conversation for a while, got
> > busy with other stuff.
> > 
> > So, let me continue this.
> > 
> > On Wed, Jan 23, 2013 at 02:00:37PM +0100, Jan Kara wrote:
> > > On Wed 23-01-13 07:22:49, Carlos Maiolino wrote:
> > > > On Wed, Jan 23, 2013 at 11:39:17AM +0100, Jan Kara wrote:
> > > > > On Tue 22-01-13 11:07:58, Carlos Maiolino wrote:
> > > > > > This checks for incompatible mounting options when using ext4 module to mount
> > > > > > ext3 or ext2 filesystems.
> > > > > > 
> > > > > > Sets two new flags to group ext4 mount options that are incompatible with ext2
> > > > > > and ext3, and then add two functions -- check_ext2/3_incompat_mount() -- to
> > > > > > check and warn/fail mount, if any of these options are being used.
> > > > > > 
> > > > > > I believe, some options like those expecting an argument needs to be checked
> > > > > > during parsing time.
> > > > > > 
> > > > > > barrier mount, although it has a flag, when mounting an ext2fs, where
> > > > > > barriers are not supported (afaik), should also be checked during parse
> > > > > > time, otherwise the BARRIER mount flag will be set.
> > > > > > 
> > > > > > I didn't add all mount options I believe to need to raise a warning, just
> > > > > > those with a flag set on superblock, another flags should be added after a
> > > > > > discussion to reach a concensus of all ext2/3 options that should be rejected by
> > > > > > ext4 mount.
> > > > >   Thinking about it a bit more I'm not sure if restricting mount options is
> > > > > the right thing to start with.  IMHO what we should restrict is mounting
> > > > > filesystem with certain *features* as ext3/ext2. So e.g. filesystem with
> > > > > EXT4_FEATURE_INCOMPAT_EXTENTS cannot be mounted as ext2 or ext3. Similarly
> > > > > as currently we forbid mounting ext3 filesystem with
> > > > > EXT3_FEATURE_INCOMPAT_RECOVER as ext2... This should avoid the confusion
> > > > > which could arise when someone reports problems with "ext3" filesystem but
> > > > > actually has some of the ext4 features enabled.
> > > > > 
> > > > This is interesting, but I wonder if not restricting mount options, but
> > > > features, would open a 'window' to let users change their filesystem on-disk
> > > > format without know what they are doing, but I might be wrong.
> > >   If there are mount options that enable features, then these should be
> > > disallowed for ext2/ext3 mounts. But I think we already got rid of these
> > > traps on users...
> > > 
> > > 								Honza
> > > -- 
> > > Jan Kara <jack@suse.cz>
> > > SUSE Labs, CR
> > 
> > Jan, I agree with the idea of check for incompat features and I can work on that
> > with no problem, but I still think we need to also ensure some mount options are
> > not allowed to be used with some specific ExtFS versions wheter it change the
> > disk format (we probably got rid of these as you said) or not. Not sure if my
> > previous (V2) to restrict mount options lacks something or need to be reworked
> > in some way (of course now it should to fit new kernel versions).
> > 
> > As an example, commit=<secs> option doesn't make sense to be used on ext2
> > filesystems, but you can mount an ext2 FS with this option with no problem.
> > 
> > 
> > -- 
> > Carlos
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
