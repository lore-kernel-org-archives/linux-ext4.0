From: Jan Kara <jack@suse.cz>
Subject: Re: Support for ext4 hidden quota inodes in quota-tools
Date: Wed, 23 Nov 2011 12:32:28 +0100
Message-ID: <20111123113228.GB9775@quack.suse.cz>
References: <20111122201206.GA5029@quack.suse.cz>
 <20111122235153.GA5167@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Aditya Kali <adityakali@google.com>,
	adilger@dilger.ca, dmonakhov@openvz.org, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1KWLcb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Nov 2011 06:32:31 -0500
Content-Disposition: inline
In-Reply-To: <20111122235153.GA5167@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 22-11-11 18:51:53, Ted Tso wrote:
> On Tue, Nov 22, 2011 at 09:12:06PM +0100, Jan Kara wrote:
> > 
> >   this is just a heads up that I've modified quota tools to handle
> > quota files in hidden inodes for ext4. Current source code can be pulled
> > from git repository at sf.net: linuxquota.git.sourceforge.net
> 
> Could you give a quick summary of what the functionality the quota
> tools will have vis-a-vis the hidden inodes?  I assume things like
> repquota will work.  But will quotacheck work?  Quite frankly I'd much
> rather it didn't since then it might get confusing since some people
> might try to do the evil thing of running quota check on a live file
> system, with all of the races that might imply, versus using e2fsck to
> check and update the quota files as part of the fsck process.
> 
> Also, I had hoped to have the model where quota tracking would be
> enabled automatically when the file system was mounted, and there
> would not be a way of disabling quota tracking except when the file
> system was unmounted, so at least in theory the only way the quota
> files could get stale is if the file system was corrupted or modified
> directly via tools like e2tools or debugfs.  Presumably we'll be able
> to enforce this by having the kernel refuse the quotaoff quotactl
> request, but I just want to make sure the overall user experience
> between the kernel support, the e2fsprogs support, and the quota tools
> all come together in a way that's optimal for the sysadmin who will
> need to use all of this stuff.
  Sure. So quota-tools will provide functions like repquota(8), quota(1),
warnquota(1), setquota(8), and edquota(8) - i.e. editting of quota limits
and viewing of quota usage. Also quota_nld(8) will provide translation of
quota warnings coming via netlink into user visible messages on console (or
dbus messages).

  quotacheck(8) will just refuse to do anything when it detects a
filesystem with hidden quota files so that should be OK. Behavior of
quotaon(8) pretty much depends on the kernel patch to ext4 since ext4
provides it's ->quotaon callback. In the last iteration of the patch quota
accounting was turned on during mount and quotaon(8) only influenced
whether we actually enforce set quota limits or not. So quota accounting
cannot be turned off and is precise all the time.

  So I believe we are having the same target in mind.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
