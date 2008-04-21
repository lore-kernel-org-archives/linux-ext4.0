From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
	checker)
Date: Mon, 21 Apr 2008 08:53:58 -0400
Message-ID: <20080421125358.GD9700@mit.edu>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <f19298770804201723v12b78da6w187984debf8ef97c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45342 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756915AbYDUNRu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 09:17:50 -0400
Content-Disposition: inline
In-Reply-To: <f19298770804201723v12b78da6w187984debf8ef97c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 04:23:42AM +0400, Alexey Zaytsev wrote:
> Not really. In my application I propose some changes to the fsck pass
> order to avoid the need to rerun it. And I don't get what dependency you
> are talking about. The only one I see is between the directory entries and
> the directory inode. Should not be hard to solve.
> (Or do I miss something? Could you give more examples maybe?)

And *this* is why I ultimately decided I didn't have the time to
mentor you.  There are large numbers of other dependencies.

For example, between the direct and indirect blocks in the inode, and
the block allocation bitmaps.  (Note that e2fsck keeps up to 3
different block bitmaps and 6 different inofr bitmaps.)  

You need to know which inodes are directories and which inodes are
regular files.  E2fsck currently keeps these bitmaps so we don't have
the cache the entire 128 byte inode for all inodes.  (Instead, we
cache a single bit for every single inode.  There's a ***reason*** for
all of these bitmaps.)

You also need to know which blocks are being used to store extended
attributes, which may potentially be shared across multiple inodes.  

That's just *three* additional dependencis, and there are many more.
If you can't think of them, how much time would it take for me as
mentor to explain all of this to you?

> >  In either case, there is still the issue of knowing exactly whether a
> >  particular read happened before or after some change in the
> >  filesystem.  This race condition is a really hard one to deal with,
> >  especially on a multiple CPU system and the filesystem checker is
> >  running in userspace.
> 
> I don't see why should fsck care about this. The notification is always sent
> after the write happened, so fsck should just re-read the data. No problem
> if it already read the (half-)updated version just before the notification.

Keep in mind that when a file gets deleted, a *large* number of
metadata blocks will potentially get updated.  So while e2fsck is
handling these reads, a bunch more can start coming in from other
filesystem transactions, and since the kernel doesn't know what
userspace has already cached, it will have to send them again... and
again...  

In fact if the filesystem is being very quickly updated, the
notifications could easily overrun whatever buffers has been set up to
transfer this information from userspace to the kernel side.  Worse
yet, unless you also send down transaction boundaries, the userspace
won't know when the filesystem has reached a "stable state" which
would be internally consistent.

There are ways that this could be solved, but at the end of the day,
the $1,000,000 question is why not just do a kernel-side snapshot?
Then you don't have to completely rewrite e2fsck --- and given that
you've claimed the e2fsck code is "hard to understand", it seems
especially audacious that you would have thought you could do this in
3 months.  If you really don't want to use LVM, you could have
proposed a snapshot solution which didn't involve devicemapper.  It's
not clear it would have entered mainline, but at least there would
have been some non-zero chance that you would complete the project
successfully.

Regards,

						- Ted
