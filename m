From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recovering from a damaged root inode
Date: Thu, 28 Aug 2014 08:16:37 -0400
Message-ID: <20140828121637.GA3043@thunk.org>
References: <CAPE0SYxva9AkaynNDofObS-U5VW7RYW8io+N9Pz+6jVsCody8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Liwei <xieliwei@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53732 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaH1MQm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2014 08:16:42 -0400
Content-Disposition: inline
In-Reply-To: <CAPE0SYxva9AkaynNDofObS-U5VW7RYW8io+N9Pz+6jVsCody8A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2014 at 07:32:59PM +0800, Liwei wrote:
> 
>     I thought a second fsck run would help, but running it with -n
> gave me the following:

I take it you don't have the transcript from the first fsck run?

Also, you didn't tell us what version of e2fsprogs you are using.

Finally, this error is one was caused by your using fsck -n:

> Illegal triple indirect block (3637063325) in inode 1065.  IGNORED.
> Error while iterating over blocks in inode 1065: Illegal triply
> indirect block found

There was an illegal indirect bock in inode 1065, which wasn't fixed
because of e2fsck -n.  Unfortunately, this caused the scan to get
aborted, because the unfixed error caused the inode iterator to fail.
We could try to fix things up to make e2fsck -n recover more cleanly
in the face of errors caused by not fixing previously found errors,
but that hasn't been something that's been high priority.  (If someone
would like to improve e2fsck in this regard, please send patches.)

More generally, it looks like part of your inode table got smashed.
How, it's hard to say.  There have historically been some bugs with
resizing, but online resizing has been much more safe than off-line
resizing with big file systems, and the problems tend to with file
systems larger than 16TB.  (Although for file systems larger than 8TB,
I do strongly recommend that people update to the latest kernel and
e2fsprogs; and there have been a lot of bug fixes to e2fsprogs in the
past year and a half.  If you are using an enterprise distribution,
hopefully you're using one which has been good about backporting fixes
--- but 3.9.x hasn't been used by a distro kernel as far as I know,
and 3.9.x isn't even a long-term stable maintenace kernel.  So I'm
guessing this is a roll-your-own sort of system?)

	      	   		      	 - Ted
