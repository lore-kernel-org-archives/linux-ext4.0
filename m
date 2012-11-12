From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How full should the inode table be?
Date: Mon, 12 Nov 2012 11:30:03 -0500
Message-ID: <20121112163003.GG4895@thunk.org>
References: <20121111095512.6396.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60675 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab2KLQaG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Nov 2012 11:30:06 -0500
Content-Disposition: inline
In-Reply-To: <20121111095512.6396.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 11, 2012 at 04:55:12AM -0500, George Spelvin wrote:
> Now, it turns out that I have to rebuild it with 64-bit block numbers
> in order to grow it past 16 TB (wow, was *that* a nasty surprise),
> and I intend to use a somewhat saner bytes/inode ratio.
> 
> (Ignoring the slight space gain, fewer inodes means faster e2fsck.)

Actually, with ext4, we keep track of the last used inode in each
block group, so there isn't a speed gain for using a smaller number of
inodes.  It did make a difference for ext3, but not for ext4.

> I could just use that, so the FS will run out of data blocks at about
> the same time as it runs out of inodes, but I wonder: does the FS benefit
> from more slack in inode allocation?

The file system doesn't actually gain anything one way or another in
terms of slack space in the inode table.  The major downside is that
if you guess wrong, and you have many more smaller files than you had
estimated, there's no way to change the inode ratio afterwards, sort
of backing up and reformatting.  So that's why historically we've
tended to massively overprivision the number of inodes available to
the file system.

Regards,

						- Ted
