From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5] e2fsprogs: some small cleanups and fixes for journal
 code
Date: Sat, 26 Jul 2014 10:31:01 -0400
Message-ID: <20140726143101.GD6725@thunk.org>
References: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
 <20140726073329.GB24045@azat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com,
	adilger@dilger.ca
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58129 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbaGZObH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 10:31:07 -0400
Content-Disposition: inline
In-Reply-To: <20140726073329.GB24045@azat>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 11:33:29AM +0400, Azat Khuzhin wrote:
> On Thu, Jul 10, 2014 at 06:35:03PM +0400, Azat Khuzhin wrote:
> > [PATCH 1/5] lib: add EXT2_ prefix for SUPERBLOCK_{OFFSET,SIZE}
> > [PATCH 2/5] journal: use consts instead of 1024 and add helper for
> > [PATCH 3/5] tune2fs: remove_journal_device(): use the correct block
> > [PATCH 4/5] tune2fs: update journal super block when changing UUID
> > [PATCH 5/5] tune2fs: update journal users while updating fs UUID
> 
> Hi Ted, any news on this?

What branch was this against?  The first patch scared me, since making
global changes to rename a constant is very likely to cause all sorts
of patch conflicts, especially when I have to juggle patches across
the maint and next branches.  So that's why I put it off.

I know there are some real bug fixes here, and it's helpful it those
come *first*, and make the minimal changes necessary, so I can apply
it to the maint branch and not have to worry about potential merge
conflicts.

In general, for global renames/cleanups, especially ones that don't
actually fix any bugs, and which are there mostly for aesthetic
reasons, I'd much prefer to hold off making them until after 1.43.0 is
released, and after I've a abandoned making any further releases
(except for truely catastrophic bugs) on the 1.42.x branch.

Cheers,

						- Ted

