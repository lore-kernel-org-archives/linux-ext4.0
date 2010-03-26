From: tytso@mit.edu
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Thu, 25 Mar 2010 23:38:24 -0400
Message-ID: <20100326033824.GC21658@thunk.org>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
 <20100326004738.GJ3145@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35364 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab0CZDkq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Mar 2010 23:40:46 -0400
Content-Disposition: inline
In-Reply-To: <20100326004738.GJ3145@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 26, 2010 at 01:47:38AM +0100, Jan Kara wrote:
>   This is definitely a move in the right direction. I'd be even happier
> if e2fsck would write quota file directly - then we could just make
> quota files hidden inodes, start doing quota accounting immediately
> on mount and always do quota journaling. That would save us quite some
> trouble in kernel. The only problem with this is that we'd need to pull
> knowledge about quota formats in e2fsck...

Yes, quite possibly.  How quota is currently is set up is quite
kludgy, with magic options that do nothing but display magic options
in /proc/mounts, just in case that's a hard link to /etc/mtab.  It
also looks like that some of the magic is in various distribution's
init.d scripts, and so while I very much want to clean things up, it
wasn't clear to me how much flexibility we would have without worrying
about breaking the init scripts for Debian, Ubuntu, RHEL, SLES,
Fedora, Open SuSE, etc.

There may also be other programs that depend on the existence of
aquota.user, and may be reading and writing them in various random
ways, and there is the question of how do we provide compatibility
with these other programs, some of which may not be within quotatools,
but in various magic virtualization or container or cluster management
systems....

So maintaining compatibility between older kernels, newer kernels,
older init scripts, new init scripts, etc. may make changing the quota
system quite difficult.  I would like to do as much cleanup as we can,
though.

One question I have --- do we really have to support the 2 or 3
different quota variants?  How many people/distributions are still
using the original old quota system?  One thing that worries me is
that it looks like the old (non-journaled) quota system may be the
primary system still being used by Canonical and Debian...  I really
do hope I'm wrong, but there are a bunch of HOWTO's that still people
to use usrquota and grpquota in /etc/fstab, and not the newer
usrjquota and grpjquota mount options.

	       	     	   	   	     	 - Ted
