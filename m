From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to query ext2/3/4 total fs size while mounted?
Date: Fri, 7 Sep 2012 20:39:27 -0400
Message-ID: <20120908003927.GE2542@thunk.org>
References: <CAMU1PDg-WrH9TS-U9SfeMfV2FTBz7Md+7PR1k55aMTFVq=7NiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49405 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab2IHAjb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Sep 2012 20:39:31 -0400
Content-Disposition: inline
In-Reply-To: <CAMU1PDg-WrH9TS-U9SfeMfV2FTBz7Md+7PR1k55aMTFVq=7NiA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 07, 2012 at 09:12:49PM +0100, Mike Fleetwood wrote:
> 
> Is it safe to read the super block off disk using ext2fs_open() or by
> running dumpe2fs for a mounted file system?  What if the file system has
> just been resized?  Are there any other methods for querying the total
> file system size?

Yes, it would be safe to read the superblock off a mounted disk.
There is always going to be a race if someone is resizing the file
system as you read the file system, but that's true for the statfs
system call as well.

There's no way that parted can stop someone else from kicking off a
online resize between the time you display information about the
partition table and their contents and the user types in another
command.

Well, you could freeze the file system, but if another process is
writing huge amounts of data at the time, freezing the file system for
long periods of time could cause the system to run into significant
memory problems (since it can't clean memory pages so they can be
dropped to make room for more modified pages, leading to OOM kills).

Probably the best thing you can do, if this is really important to
you, is to snapshot the state of the file systems, then when the user
enters a command, in quick succession, freeze the file system, double
check to make sure nothing has changed, and if it hasn't, update the
partition table (this is most important if you are shrinking the
partition), and then unfreeze the file system.

Cheers,

						- Ted
