From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHES/RFC v1.0.12] e2fsprogs: Next3 patch series
Date: Tue, 20 Jul 2010 18:38:25 +0200
Message-ID: <20100720163825.GC12998@quack.suse.cz>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
 <AANLkTinlL0YEiDGWw0qjyYYzR31D_DBKQxFczSu4UYt6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761312Ab0GTQiv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Jul 2010 12:38:51 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinlL0YEiDGWw0qjyYYzR31D_DBKQxFczSu4UYt6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-07-10 18:57:26, Amir G. wrote:
> On Tue, Jul 20, 2010 at 6:16 PM, Amir Goldstein wrote:
> > Hi guys,
> >
> > The following patches apply and tested on e2fsprogs master branch (on July 20).
> >
> > Please help me review and push these patches upstream.
> >
> > Thanks,
> > Amir.
> >
> > [PATCH 01/12] e2fsprogs: Next3 on-disk format changes
> > [PATCH 02/12] e2fsprogs: Create a big journal for Next3
> > [PATCH 03/12] e2fsprogs: Create/check exclude inode for Next3
> > [PATCH 04/12] e2fsprogs: Next3 snapshot control with chattr/lsattr -X
> > [PATCH 05/12] e2fsprogs: Avoid offline modifications to a file system with snapshots
> > [PATCH 06/12] e2fsprogs: Cleanup Next3 snapshot list when removing has_snapshot feature
> > [PATCH 07/12] e2fsprogs: Check Next3 exclude bitmap on fsck
> > [PATCH 08/12] e2fsprogs: Check Next3 snapshot list on fsck
> > [PATCH 09/12] e2fsprogs: Delete all snapshots on fsck -x
> > [PATCH 10/12] e2fsprogs: Map maximum filesystem size with a single snapshot file
> > [PATCH 11/12] e2fsprogs: Dump Next3 message buffer on fsck
> > [PATCH 12/12] e2fsprogs: Migrate old to new on-disk format
> >
> So I thought it is worth a shot to ask you personally if you will have
> time to review my Next3 patches.
> 
> In fact, the posted patches are only the small patches to e2fsprogs.
> The more challenging job is the review of the Next3 snapshot patches,
> which apply on top of ext3 (or rather a forked branch of ext3 called next3).
> They are available for download at
> http://sourceforge.net/projects/next3/files/Latest%20patch%20series
> but I can also post them to the list if you like (about 40 medium size patches).
  Well, I can have a look at those patches. But I'd like to know what is
exactly your motivation - is it that you have some customers running with
this clone and want to upstream the fs, or is it that you'd like to
contribute the cool feature you've developped, or something else? Because
on this depends where we should go from the current situation...
  To state my position: I'm not willing to merge the feature into ext3
because it's basically in a maintenance mode so we don't accept larger
features to it anymore (for stability reasons).
  You could, of course, copy ext3 code base and create a separate next3
filesystem. But such code duplication would be generally frowned upon and I
personally wouldn't like to take the burden of maintaining such code so
you'd have to do it. Moreover you have to port all ext3 fixes to your code
and you have a problem that as time progresses, new features are added to
ext4, not ext3, so I think it would be less and less attractive to run
Next3 instead of ext4... So this doesn't seem like an ideal solution either.
  For future, the most promising to me would be to change the
implementation to work with ext4 and merge it there. I understand there are
technical issues with this and I'm not sure how hard they would be to
solve. But for me as a filesystem developper this would seem like a
direction where it's worth to invest some time and energy and I can help
with that (and I believe other ext4 developpers might lend a hand as well).
  Just my thoughts... Anyway, I've added to my todo an item to have a look
at your patches so that I have better idea what we are discussing about.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
