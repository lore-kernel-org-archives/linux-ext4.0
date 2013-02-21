From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Filesystem corrupted by offline resize
Date: Thu, 21 Feb 2013 14:53:05 -0500
Message-ID: <20130221195305.GC17322@thunk.org>
References: <CACqGdtvfi9a9z4F7KpOQmcqNkptdfWXyTTwgxH66RHNqcTAPSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chris Naunton <chris@naunton.name>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49318 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab3BUTxI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2013 14:53:08 -0500
Content-Disposition: inline
In-Reply-To: <CACqGdtvfi9a9z4F7KpOQmcqNkptdfWXyTTwgxH66RHNqcTAPSQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2013 at 04:40:42PM +1100, Chris Naunton wrote:
> I think I'm the victim of a resize2fs bug that was addressed in
> 1.42.7: http://e2fsprogs.sourceforge.net/e2fsprogs-release.html#1.42.7
> 
> My senario:
> 
> * Running Ubuntu 12.10 with the latest x64 e2fsprogs package, which is 1.47.5
> 
> * I have a 3.6T ext4 filesystem that had been created with the "resize" option:
> 
>   mkfs -t ext4 -T ext4 -E stripe-width=64,resize=20T -i 1048576 -L
> data -m 0 /dev/raid5/data
> 
>   (This was three years ago. I think at the time I assumed if I didn't
> specify this option my ability to resize would be limited.)
>.....

Yup, I think you're correct.  You hit the bug which we only discovered
and fixed in time for the 1.42.7 release.  ;-(

Unfortunately, the corruption that happened included wiping out parts
of the inode table.  This means the data loss is going to be
non-trivial, and possibly extremely bad.   Sorry.  :-(

I don't know how big your RAID array is, and how recent was your last
backups, but basically, if you can afford to make a disk image copy of
the file system, I would recommend doing that first.  Then trying
running fsck -y on the copy, and see if that allows you to recover all
of the data that you really need.  If it doesn't, it may be possible
to get more data back by doing either (a) using tools that search for
critical keywords (i.e., if there is an extremely critical file, say
like a Ph.D. thesis for which ten years of work was un backed up), or
(b) by using tools that search for file signatures in the data blocks.

The tool I recommend for the latter is called PhotoRec:

    http://www.cgsecurity.org/wiki/PhotoRec

It was originally designed to extract digital photos from damaged SD
cards, but it now understands hundreds of file formats, including
OpenOffice/LibreOffice, zip files, MS Office files, etc.:

    http://www.cgsecurity.org/wiki/File_Formats_Recovered_By_PhotoRec

I'm sorry to have to tell you this, and I'm really sorry you ran
across this bug before we had a chance to get it fixed and pushed out
to the distributions.

Regards,

					- Ted
