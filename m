From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH 0/5] e2fsprogs: some small cleanups and fixes for journal
 code
Date: Mon, 28 Jul 2014 12:06:19 +0400
Message-ID: <20140728080619.GA6041@azat>
References: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
 <20140726073329.GB24045@azat>
 <20140726143101.GD6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34285 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaG1IGX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 04:06:23 -0400
Received: by mail-lb0-f173.google.com with SMTP id p9so5491977lbv.18
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2014 01:06:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140726143101.GD6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 26 Jul 2014 18:31, "Theodore Ts'o" <tytso <tytso@mit.edu>@ 
<tytso@mit.edu>mit.edu <tytso@mit.edu>> wrote:
>
> On Sat, Jul 26, 2014 at 11:33:29AM +0400, Azat Khuzhin wrote:
> > On Thu, Jul 10, 2014 at 06:35:03PM +0400, Azat Khuzhin wrote:
> > > [PATCH 1/5] lib: add EXT2_ prefix for SUPERBLOCK_{OFFSET,SIZE}
> > > [PATCH 2/5] journal: use consts instead of 1024 and add helper for
> > > [PATCH 3/5] tune2fs: remove_journal_device(): use the correct block
> > > [PATCH 4/5] tune2fs: update journal super block when changing UUID
> > > [PATCH 5/5] tune2fs: update journal users while updating fs UUID
> >
> > Hi Ted, any news on this?
>
> What branch was this against?  The first patch scared me, since making
> global changes to rename a constant is very likely to cause all sorts
> of patch conflicts, especially when I have to juggle patches across
> the maint and next branches.  So that's why I put it off.

AFAIR it was against master.
Yeah massive rename will do a lot of conflicts, I've just rebased them
against maint without first patch and sent new patchset (v3).

>
> I know there are some real bug fixes here, and it's helpful it those
> come *first*, and make the minimal changes necessary, so I can apply
> it to the maint branch and not have to worry about potential merge
> conflicts.

There is one patch that I decide to leave, while it's not bugfix -
"journal: use consts instead of 1024 and add helper for journal with 1k
blocksize" because it will add one helper that is really useful instead
of hardcoding it in place in next patches.

>
> In general, for global renames/cleanups, especially ones that don't
> actually fix any bugs, and which are there mostly for aesthetic
> reasons, I'd much prefer to hold off making them until after 1.43.0 is
> released, and after I've a abandoned making any further releases
> (except for truely catastrophic bugs) on the 1.42.x branch.
>

Got it.

Thanks.
Azat.
