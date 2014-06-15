From: Killian De Volder <killian.de.volder@scarlet.be>
Subject: Re: Recovery after mkfs.ext4 on a ext4
Date: Sun, 15 Jun 2014 22:27:08 +0200
Message-ID: <539E019C.6060600@scarlet.be>
References: <539D555E.3050707@scarlet.be> <20140615132026.GC2180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:32853 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaFOU1O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jun 2014 16:27:14 -0400
In-Reply-To: <20140615132026.GC2180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 15-06-14 15:20, Theodore Ts'o wrote:
> On Sun, Jun 15, 2014 at 10:12:14AM +0200, Killian De Volder wrote:
>
> It could be perhaps argued that qemu should
> add this safety check, and at least warn before you exported a block
> device already in use as a file system.  It's probably worth taking
> that up with the qemu folks.
It was Xen, but same issue.
> If it's any consolation the very latest version of e2fsprogs has a
> safety check that might have caught the problem:
>
> # mke2fs -t ext4 /dev/heap/scratch
> mke2fs 1.42.10 (18-May-2014)
> /dev/heap/scratch contains a ext4 file system labelled 'Important Stuff'
> 		  last mounted on Tue Jun  3 16:12:01 2014
> Proceed anyway? (y,n) n
Very good !
>> Can e2fsck recover the directory structure and/or files in this scenario?
> Well, maybe.  The problem is what got destroyed....  given some of the
> errors you have described, it looks like more than the inode table got
> wiped.  It's quite possible that version of mke2fs used to create the
> original file system is older than the one used in the guest OS.  For
> example, we changed where we placed the journal at one point.  That
> would explain some of the file system errors.
I assume this includes changing the journal size manually? (For the wiki.)
>> Can I use debugfs to start at a directory inode and then use rdump ?
> Again, maybe.  The problem is that if a particular subdirectory is
> destroyed, then you won't find it via rdump.  E2fsck can relocate
> files and subdirectories contained in damaged directories to
> lost+found, which rdump obviously can't cope with.
If you mount it read-only all  I  see is ./ ../ and ./lost+found/, so rdump is out the question.
I'm hoping on e2fsck.
>> Is there a way to reduce the memory usage during e2fsck in this scenario ?
> Sorry, not really.
Sometimes I think it's certain inodes causing the excessive memory usage cause.
20GiB sounds a lot when the normal -f fschk took less then 3GiB. (It's a 16TiB file system).
But suppose it needs more binary maps when the filesystem is this corrupt ?

Actually there might be one thing I could do, I should have a look at zram and zswap.
(Well after this e2fsck -nf check is done, which could be a day or 2...)

I've also been pondering about taking a lvm snapshot and running an actual repair.
(Instead of a testrun.) But I have no idea howbig the snapshot should be. Any indicators ?
> Good luck,
Thank you for the info and luck, I'll need it :)
> 						- Ted

