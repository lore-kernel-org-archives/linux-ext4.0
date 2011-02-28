From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: [PATCH] ext3: skip orphan cleanup on rocompat fs
Date: Mon, 28 Feb 2011 11:14:55 +0100
Message-ID: <20110228101454.GE4834@bitwizard.nl>
References: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:34094 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752915Ab1B1KO4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Feb 2011 05:14:56 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimLAL7hPL+Yb392hyVAWEfHtObv7WwjzKt2awur@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Sat, Feb 26, 2011 at 10:40:19PM +0200, Amir Goldstein wrote:
> This patch skips the orphan cleanup if readonly compatible features
> would prevent the fs from being mounted (or remounted) readwrite.

I use the "mount readonly" option to, for instance, view/check the
filesystem to determine wether or not I need to fsck first. I use the
"readonly" feature to prevent the mounting to be a mistake-prone
situation. It prevents e.g. applications from dropping temporary files
in my current directory.

Every time fsck or such a cleanup does something, there is the option
of the cleanup or fixup being wrong. When you honour the "readonly"
request from the user, the careful user can go back to the situation
where he/she started.

If the cleanup/fixup is really neccesary, do so in in-core buffers of
the filesystem. Write the infrastructure that allows us to have dirty
buffers that MAY NOT (yet?!?) be written to the device. This will also
solve the problem of journal recovery on readonly mount of a root
filesystem. when it has been fscked, and it's remounted rw, we can
remove the ban on the writeback of the dirty buffers.

So I stronly disagree with your patch: It should not only prevent the
cleanup when writing is not allows due to ro-compat situation, but
also when requested by the user.


	Roger.

------------------ 

Back in the old days I was still using minix. Linux didn't exist or
wasn't usable enough. I had something that needed removing, so I typed
rm -rf *, thinking I was in the directory that needed removing. I
wasn't! There went my (modified) kernel tree! It took me some three
seconds to find, verify and execute the solution: Powerswitch.

In such an incident, cleaning up inodes that you think were deleted
anyway removes information about files that may need recovery. Imagine
that accidentally my big database file was unlinked. Ooops. But the
database server is still keeping the file open. Phew. We can continue
to run until we find a solution.... So the inode is now orphaned. But
we can recover it with some filesystem magic. Maybe not by answering
yes to fsck questions, but it is recoverable without dataloss, right?

Then the power goes out... Ooops. Instead of two more days to get
everything ready for the recovery we have to do it NOW.  There goes.
Boot from CD, let's just mount the partition readonly to get access to
our tools and binaries that may facilitate the recovery of our
database. BAM! Away goes the nicely allocated inode. (ext2 used to
just mark the inode as not in use, ext3 cleans it up so that we lose
the pointers to the 7 datablocks, the indirect block and double
indirect block!) Now we will have to guess where the file started etc
etc. 

The principle is: Do as I say. That keeps things predictable. If you
try to outguess the user, it will be horribly wrong every once in a
while. You're right. In 99% of the cases, the system just
crashed/rebooted while some temporary files were still open, but
already deleted. And in 99% of the cases, the system will boot,
perform an automatic fsck and eventually remount rw. So writing those
orphaned inodes back early doesn't make a real difference.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
