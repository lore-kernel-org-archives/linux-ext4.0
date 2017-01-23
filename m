From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_iget:4740: inode #%ld: block 48: comm find: invalid block
Date: Sun, 22 Jan 2017 19:08:27 -0500
Message-ID: <20170123000827.nzcikt6rvxfykktg@thunk.org>
References: <20170121133049.bsrp55gi4x5x5wcv@thunk.org>
 <20170121164512.11458.qmail@ns.sciencehorizons.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: George Spelvin <linux@sciencehorizons.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42170 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbdAWAIn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 22 Jan 2017 19:08:43 -0500
Content-Disposition: inline
In-Reply-To: <20170121164512.11458.qmail@ns.sciencehorizons.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 21, 2017 at 11:45:12AM -0500, George Spelvin wrote:
> Er, huh?  I was referring to the following error, which is one of a
> dozen inodes I have with this problem (sorry all the Subject: lines have
> gotten tangled):

Yes, there are a bunch of different inodes, and I was referring to a
different inode dump you've sent out.

> I just want to get it to a state where I can mv the contents into a
> replacement directly and then rmdir this one, rather than having to
> make a note of the name & inode number of each of the contained files
> and then recreate it from the contents of lost+found (which is already
> a bit of a swamp I'm wading through).

My one recommendation would be try it out on a copy of the file
system, or try recreating the corruption on a small file system and
then experiment before you go ahead try to recover things.  I tend to
be *very* caution when live data is concerned, especially when I'm not
in front of the system myself and I'm asked to give advice to a user.

Or if it's too hard to make a copy of the file system, you might make
one change to one inode, then run fsck, and then mount the file
system, and make sure the kernel doesn't do something untoward, etc.,
before you try making that same class of change on two or three
inodes, then fsck and mount the file system, and try accessing those
files, before you make all of the changes for that class of
corruption.

Good luck,

						- Ted
