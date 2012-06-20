From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Ext4 slow on links
Date: Tue, 19 Jun 2012 22:19:12 -0400
Message-ID: <20120620021912.GA26323@thunk.org>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51439 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab2FTCTR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 22:19:17 -0400
Content-Disposition: inline
In-Reply-To: <20120620002014.GA25471@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 20, 2012 at 09:20:14AM +0900, Norbert Preining wrote:
> Dear all
> 
> (please Cc)
> 
> I recently had to track down a big delay in one of my Debian packages,
> and it turned out that it seems to be due to ext4 being *horribly*
> slow on dealing with symlinks.
> 
> On my system, if I create a directory with 8000 symlinks (that is
> a real case of a font package shipping special encoded files) and
> the symlink targets are "far away" (long names), then, after 
> a reboot a simply
> 	ls -l
> in this directory took 1m20sec. While on second run it is down to 2secs
> (nice caching).
> 
> I read in the ext4 design document that if the symlink target is
> less then 66 (?) chars long, then it is saved right in the inode,
> otherwise some other action has to be taken.

The inode has room for 60 characters; after that, the symlink target
gets stored in an external block.  The seek to read in the symlink
target could be one of the causes of the delay.  The other is
potentially reading in the inode which is the target of the symlink
target.  Both of these will take disk time in a cold cache situation.

> Now my questions are:
> - is this to be expected and not to be avoided?
> - do you have a way around it?
> - do other file systems, esp ext2/ext3 behave differently in this respect?

Nothing has changed here between ext2/ext3 and ext4 here, so ext2/ext3
will behave exactly the same.  There are changes in the block and
inode allocation algorithms which might make a minor difference, but
the same is potentially true of a very fragmented file system.

There is a relatively new feature, which is not yet merged into ext4
mainline, called the inline data patch set, which could potentially
allow you to store more than 60 characters in a symlink in large
inodes.  This could potentially help, but as a feature it will be a
while before it's ready (it definitely won't make the upcoming Debian
stable freeze) --- and so most of your Debian users won't be able to
take advantage of it for quite a while.

Otherwise, there's not much we can do about this, unfortunately.  The
cold cache case is always a hard one, and the simplest ways of
optimizing it would involve changing how the application is storing
its files.  In general, trying to use a file system as a poor man's
database is a bad idea, and will only end in tears, and it sounds like
this is what you're running into in terms of very long file names to
symlinks in a font directory.

Regards,

						- Ted
