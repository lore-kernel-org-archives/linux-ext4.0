From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: large directory entry
Date: Fri, 1 May 2015 09:59:42 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.7.1505010923400.29119@trent.utfs.org>
References: <alpine.DEB.2.20.7.1504301634450.29119@trent.utfs.org> <20150501143147.GB9936@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:57529 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbbEAQ7w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2015 12:59:52 -0400
In-Reply-To: <20150501143147.GB9936@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 1 May 2015 at 10:31, Theodore Ts'o wrote:
> That's simply because shrinking directories while the file system is
> mounted is... tricky.  At some point we might try to get this
> supported, but until we do, there are two workarounds:
> 
> 1)  Recreate the directory, i.e.,

Yes, I did that and the copy is only 450 KB in size, so this works.

> 2) Run "e2fsck -fD /dev/sdXX" on the device containing /var while
> the file system is unmounted.

My /var is on the root disk and a normal fsck has been run during 
bootup just a few days ago, but without -D, of course.

> I'm not sure I would call this a bug; it's a long standing proper of
> ext2/3/4, the BSD FFS, etc., which is directories can't get shurnk by
> the file system.  At some point the directory had enough files in it
> that it grew to that size, and once having grown to that size, it
> won't shirnk on its own.

Yes, I noticed that with smaller sized directory, but somehow this 18 MB 
directory with "nothing" inside tipped me off.

> It would be possible to enhance ext4 to be able to shrink directories
> on-line, but it would require adding a new file system (to allow
> sparse directories), getting a new version of e2fsck, and then writing
> a bunch of new code, and it's just one of those things we've never
> gotten around to doing, mainly because for most use cases it rarely
> hits people, and the fix should be realtive well understood, as
> various Linux/Unix systems have suffered from this for decades.

Thanks for the explanation, Ted. I hope the next one asking this will find 
this in the archives, I somehow didn't :-\

Christian.
-- 
BOFH excuse #226:

A star wars satellite accidently blew up the WAN.
