From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 11:54:41 +0100
Message-ID: <20100326105441.GB3055@quack.suse.cz>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
 <20100326004738.GJ3145@quack.suse.cz>
 <20100326033824.GC21658@thunk.org>
 <9E7C0FF6-B02F-4470-B70A-4DBF5D5D6E0E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab0CZKy2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:28 -0400
Content-Disposition: inline
In-Reply-To: <9E7C0FF6-B02F-4470-B70A-4DBF5D5D6E0E@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 26-03-10 01:01:35, Andreas Dilger wrote:
> >Yes, quite possibly.  How quota is currently is set up is quite
> >kludgy, with magic options that do nothing but display magic options
> >in /proc/mounts, just in case that's a hard link to /etc/mtab.  It
> >also looks like that some of the magic is in various distribution's
> >init.d scripts, and so while I very much want to clean things up, it
> >wasn't clear to me how much flexibility we would have without worrying
> >about breaking the init scripts for Debian, Ubuntu, RHEL, SLES,
> >Fedora, Open SuSE, etc.
> >
> >There may also be other programs that depend on the existence of
> >aquota.user, and may be reading and writing them in various random
> >ways, and there is the question of how do we provide compatibility
> >with these other programs, some of which may not be within quotatools,
> >but in various magic virtualization or container or cluster management
> >systems....
> 
> If the quota file is already present as a regular file, I don't
> think it would be terrible to leave it in place, but to create new
> quota files as hidden files.
> It also would be nice to always enable quota journaing in ext4,
> since I don't think this does any harm, and if quotacheck isn't run
> then at least there a good chance the quotas are still correct.
  Yes, this should be a good option. I imagine we would create RO_COMPAT
features USRQUOTA and GRPQUOTA meaning that the filesystem maintains
quotas in hidden files. And mkfs would directly create these files if
it was asked to.

> >So maintaining compatibility between older kernels, newer kernels,
> >older init scripts, new init scripts, etc. may make changing the quota
> >system quite difficult.  I would like to do as much cleanup as we can,
> >though.
> >
> >One question I have --- do we really have to support the 2 or 3
> >different quota variants?  How many people/distributions are still
> >using the original old quota system?  One thing that worries me is
> >that it looks like the old (non-journaled) quota system may be the
> >primary system still being used by Canonical and Debian...  I really
> >do hope I'm wrong, but there are a bunch of HOWTO's that still people
> >to use usrquota and grpquota in /etc/fstab, and not the newer
> >usrjquota and grpjquota mount options.
> 
> If there isn't a reason to continue using unjournaled quota (i.e. it
> doesn't break to just move to journaled quota everywhere), then
> these could just become aliases for the journaled quota
> implementation.  The other alternative is to deprecate these options
> in the next kernel and have it print out a warning on the console to
> tell the user to switch over to the journaled version.
  If we make quota files hidden and teach quota-tools to not depend on
usr[j]quota options, then we don't need any quota options at all. And I'd
leave usrjquota / grpjquota as they are. Maybe we could issue a warning
when usrquota / grpquota is used but quotacheck already prints the warning
that you should use journaled quotas if it's run on ext3 / ext4. So
we already have this to some extent.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
