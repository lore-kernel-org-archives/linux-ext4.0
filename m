From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4: Slow performance on first write after mount
Date: Mon, 20 May 2013 07:46:47 -0400
Message-ID: <20130520114647.GC8404@thunk.org>
References: <1679869241.585607.1368809483337.JavaMail.ngmail@webmail12.arcor-online.net>
 <20130519140023.GB7183@thunk.org>
 <FB0094B8-15F8-4190-ABC6-2C06C6BC2521@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49913 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab3ETLqx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 07:46:53 -0400
Content-Disposition: inline
In-Reply-To: <FB0094B8-15F8-4190-ABC6-2C06C6BC2521@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 20, 2013 at 12:39:50AM -0600, Andreas Dilger wrote:
> 
> Since we already have a thread starting at mount time to check the
> inode table zeroing, it would also be possible to co-opt this thread
> for preloading the group metadata from the bitmaps. 

True.  Since I wrote my earlier post, I've also been considering the
possibility that e2fsck or the kernel should just simply issue
readahead requests for all of the bitmap blocks.  The advantage of
doing it in e2fsck is that it happens earlier.

In fact, since in e2fsck the prereads can be done in parallel, I was
even thinking about a scheme where e2fsck would synchronously force
all of the allocation blocks into the buffer cache, and then in the
kernel, we could have a loop which checks to see if the bitmap blocks
were already in cache, and if they were, to initialize the buddy
bitmaps pages.  That way, even if subsequent memory pressure were to
push the buddy bitmap pages and allocation bitmaps out of the cache,
it would mean that all of the ext4_group_info structures would be
initialized, and just having the bb_largest_free_order information
will very much help things.

On Sun, 19 May 2013 21:36:02 +0200 (CEST) Frank C Moeller wrote:
>From my point (end user) I would prefer a builtin solution. I'm also a
>programmer and I can therefore understand why you don't want to change
>anything.

It's not that I don't want to change anything, it's that I'm very
hesitant to add new mount options or new code paths that now need more
testing unless there's no other way of addressing a particular use
case.  Another consideration is how to do it in such a way that it
doesn't degrade other users' performance.

Issuing readahead requests for the bitmap blocks might be good
compromise; since they are readahead requests, as low priority
requests they won't interfere with anything else going on, and in
practice, unless you are starting your video recording **immediately**
after the reboot, it should address your concern.  (Also note that for
most people willing to hack a DVR, adding a line to /etc/rc.local is
usually considered easier than building a new kernel from sources and
then after making file system format changes, requiring a reformat of
their data disk!)

So it's not that I'm against solutions that involve kernel changes or
file system format changes.  It's just that I want to make sure we
explore the entire solution space, since there are costs in terms of
testing costs, the need to do a backup-reformat-restore pass, etc,
etc., to some of the solutions that have been suggested so far.

Regards,

						- Ted
