From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 11:42:05 +0100
Message-ID: <20100326104205.GA3055@quack.suse.cz>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
 <20100326004738.GJ3145@quack.suse.cz>
 <20100326033824.GC21658@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48875 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab0CZKlw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 06:41:52 -0400
Content-Disposition: inline
In-Reply-To: <20100326033824.GC21658@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-03-10 23:38:24, tytso@mit.edu wrote:
> On Fri, Mar 26, 2010 at 01:47:38AM +0100, Jan Kara wrote:
> >   This is definitely a move in the right direction. I'd be even happier
> > if e2fsck would write quota file directly - then we could just make
> > quota files hidden inodes, start doing quota accounting immediately
> > on mount and always do quota journaling. That would save us quite some
> > trouble in kernel. The only problem with this is that we'd need to pull
> > knowledge about quota formats in e2fsck...
> 
> Yes, quite possibly.  How quota is currently is set up is quite
> kludgy, with magic options that do nothing but display magic options
> in /proc/mounts, just in case that's a hard link to /etc/mtab.  It
> also looks like that some of the magic is in various distribution's
> init.d scripts, and so while I very much want to clean things up, it
> wasn't clear to me how much flexibility we would have without worrying
> about breaking the init scripts for Debian, Ubuntu, RHEL, SLES,
> Fedora, Open SuSE, etc.
  Well, init scripts can be fixed and if we provide some grace time for
distros to catch up I believe this isn't that hard.

> There may also be other programs that depend on the existence of
> aquota.user, and may be reading and writing them in various random
> ways, and there is the question of how do we provide compatibility
> with these other programs, some of which may not be within quotatools,
> but in various magic virtualization or container or cluster management
> systems....
  Yeah, this is possible, although I'm not aware of any such program -
except for repquota and warnquota from quota-tools but I'll take care about
those. What some programs do is that they change quota files via kernel
(quotactl) or call programs from quota-tools but that is fine (and ultimately
the only way I'd like to leave to userspace when the filesystem is mounted).

> So maintaining compatibility between older kernels, newer kernels,
> older init scripts, new init scripts, etc. may make changing the quota
> system quite difficult.  I would like to do as much cleanup as we can,
> though.
  Actually, XFS and OCFS2 already use hidden quota files. So it won't be
completely new thing.

> One question I have --- do we really have to support the 2 or 3
> different quota variants?  How many people/distributions are still
> using the original old quota system?  One thing that worries me is
> that it looks like the old (non-journaled) quota system may be the
> primary system still being used by Canonical and Debian...  I really
> do hope I'm wrong, but there are a bunch of HOWTO's that still people
> to use usrquota and grpquota in /etc/fstab, and not the newer
> usrjquota and grpjquota mount options.
  Yeah, I believe that support for the oldest quota format can be phased
out - the new format is around for something like 10 years and it had
it's problems at that time already. I guess I'll add a warning to the
next release of quota-tools to the people still using it.
  About quota journaling - it has some performance penalty (changed quota
structures have to be written on every transaction commit instead of just
once on quotaoff time / sync) but I belive that if someone is running
journaled filesystem, he also should use journaled quotas because it's
essentially filesystem metadata.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
