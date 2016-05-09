From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: guarantee already started handles to successfully
 finish while ro remounting
Date: Mon, 9 May 2016 10:40:49 +0200
Message-ID: <20160509084049.GD11897@quack2.suse.cz>
References: <593570881.453531462514471895.JavaMail.weblogic@ep2mlwas08c>
 <20160506130034.GE31860@thunk.org>
 <14935C7A-F680-4E9A-9048-DAACAE1ABAB4@dilger.ca>
 <20160506233623.GD7303@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Daeho Jeong <daeho.jeong@samsung.com>, jack@suse.cz,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?B?7J206riw7YOc?= <kitae87.lee@samsung.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbcEIIkw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2016 04:40:52 -0400
Content-Disposition: inline
In-Reply-To: <20160506233623.GD7303@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 06-05-16 23:36:23, Ted Tso wrote:
> On Fri, May 06, 2016 at 02:01:17PM -0600, Andreas Dilger wrote:
> > 
> > The problem is that emergency remount-ro doesn't block in-progress writes,
> > since most operations only check the MS_RDONLY at the start of an operation.
> > It would be possible for do_emergency_remount() call ->freeze_fs() first for
> > all the filesystems, then doing the remount read-only (would need a change to
> > do_remount_ro() to allow this)?
> 
> I thought about doing that, but that would mean that the code path
> might need to take some locks along the way, and if you have multiple
> file systems, for which one has wedged, the do_emergency_remount()
> function might end up blocking when it tries calling freeze_fs() on
> one of the file system before it managed to get to the rest of the
> file systems in the system.
> 
> This really goes to the question of what is do_emergency_remount()
> for.  If the goal is to minimize damage, then you want to keep things
> as simple as possible, and to not allow any emergency remounts for any
> file system to block.
> 
> If the goal is to allow the normal shutdown path to use this because
> the userspace code is too lazy to do a proper shutdown of all user
> processes, and too lazy to go through all of the mounted file systems
> and individually call FIFREEZE, then sure, we could iterate over the
> file systems and call freeze_fs() in kernel code.  But I'm not really
> sure I see the point......
> 
> > That ensures the filesystem is in a (more) consistent state when force
> > remount-ro is called (i.e. which doesn't block or return an error if there
> > are writers on the filesystem).  
> 
> Right, but if the kernel is calling freeze_fs(), freeze_fs() might
> block, and then what would we do?

Yeah, 100% agreed. Emergency remount is for the case where the system is
too hosed to allow for normal shutdown (e.g. kernel has oopsed while
holding fs locks so normal unmount attempt will just block) and you want to
limit fs damage. So emergency remount should not block and thus it cannot
wait for any outstanding writes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
