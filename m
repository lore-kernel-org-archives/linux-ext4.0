From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC] ext3: don't clear orphan list on ro mount with
 errors
Date: Tue, 4 Sep 2012 23:27:06 +0200
Message-ID: <20120904212706.GA10636@quack.suse.cz>
References: <503BC685.7090707@redhat.com>
 <503BCAE0.7010900@redhat.com>
 <20120828080225.GB5146@quack.suse.cz>
 <50464DCD.2020209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2IDV1I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Sep 2012 17:27:08 -0400
Content-Disposition: inline
In-Reply-To: <50464DCD.2020209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 04-09-12 13:51:57, Eric Sandeen wrote:
> On 8/28/12 3:02 AM, Jan Kara wrote:
> > On Mon 27-08-12 14:30:40, Eric Sandeen wrote:
> >> When we have a filesystem with an orphan inode list *and* in error
> >> state, things behave differently if:
> >>
> >> 1) e2fsck -p is done prior to mount: e2fsck fixes things and exits
> >>    happily (barring other significant problems)
> >>
> >> vs.
> >>
> >> 2) mount is done first, then e2fsck -p: due to the orphan inode
> >>    list removal, more errors are found and e2fsck exits with
> >>    UNEXPECTED INCONSISTENCY.
> >>
> >> The 2nd case above, on the root filesystem, has the tendency to halt
> >> the boot process, which is unfortunate.
> >>
> >> The situation can be improved by not clearing the orphan
> >> inode list when the fs is mounted readonly.
> >   Yeah, makes sense. I've added the patch to my tree. Thanks.
> > 
> > 								Honza
> 
> After a little more investigation, I'm now wondering if this is really
> worth doing.
> 
> e2fsck zaps the orphan list just like the kernel does:
> 
>          * If the filesystem contains errors, don't run the orphan
>          * list, since the orphan list can't be trusted; and we're
>          * going to be running a full e2fsck run anyway...
> 
> and my 1) and 2) differences above were due to testing an older version
> of e2fsck which didn't properly propagate the error flag.  (Sorry...)
> 
> Since upstream e2fsck will _also_ ignore the orphan inode list, there's
> probably no great reason for preserving it on a readonly mount after all,
> unless it's just to minimize changes when mounting RO (which may be a
> sufficient reason, I suppose).  So feel free to take it or leave it,
> I guess.
  Since I've already pushed this to Linus and minimizing changes on RO
filesystem makes sense anyway, I'll leave the patch in... Thanks for the
update.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
