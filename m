From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs: Should never happen: resize inode corrupt! - lost key
 inodes
Date: Tue, 11 Aug 2015 18:47:18 -0400
Message-ID: <20150811224718.GD20658@thunk.org>
References: <55CA3BDE.7020401@harvyl.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Johan Harvyl <johan@harvyl.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53557 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbbHKWrV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2015 18:47:21 -0400
Content-Disposition: inline
In-Reply-To: <55CA3BDE.7020401@harvyl.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2015 at 08:15:58PM +0200, Johan Harvyl wrote:
> 
> I recently attempted an operation I have done many many times before, add a
> drive to a raid array followed by offline resize2fs to expand the ext4fs on
> it.

If you've read the old threads, you'll note that online resize is
actually safer (has proven to have had less bugs) than offline
resize, at least with respect to big ext4 file systems.  :-/

I'm not aware of any offline resize with 1.42.13, but it sounds like
you were originally using mke2fs and resize2fs 1.42.10, which did have
some bugs, and so the question is what sort of might it might have
left things.

It looks like you were resizing the file system from 18TB to 22TB.
There shouldn't have been a resize inode if the file system was larger
than 16TB, and so it sounds like is that was what tickled this error message:

> # resize2fs /dev/md0
> Should never happen: resize inode corrupt!

This was after most of the resize work has been done, so the question
is what we need to do to get your file system up and running again.

What does "e2fsck -fn /dev/md0" report?

Hopefully "e2fsck -fy /dev/md0" will fix things for you, but if you
haven't made backups, we should be careful before we move forward.

							- Ted

