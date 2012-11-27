From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Filesystem corruption on Fedora 17
Date: Tue, 27 Nov 2012 12:31:15 -0500
Message-ID: <20121127173115.GC7107@thunk.org>
References: <CAP5prOgjNXnvXr1HELuez7+Be+TW4N8t9P_AeQw8pBVYDnFHTg@mail.gmail.com>
 <20121127164745.GB7107@thunk.org>
 <CAP5prOh1VvLtCvY_iE2om2dXmgwHoD5JkkfVqu=MUtMiv9L9vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Adam Huffman <adam.huffman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35157 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab2K0RbX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Nov 2012 12:31:23 -0500
Content-Disposition: inline
In-Reply-To: <CAP5prOh1VvLtCvY_iE2om2dXmgwHoD5JkkfVqu=MUtMiv9L9vg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2012 at 04:59:05PM +0000, Adam Huffman wrote:
> 
> I took a copy using dd_rescue yesterday, and that's what I've been
> running fsck against.
> (After that I tried mkfs.ext4 -S on the disk itself, which wasn't successful...)

On the disk itself?  Instead of another copy of the disk?  That was
unfortunate.... mke2fs -S is very destructive when it doesn't work
out.... and what happened after you tried that, BTW?  What were the
e2fsck failures that you were seeing?  If you're seeing the same
repeated journal failures, you might as well go for broke and see if
zapping the journal helps:

	debugfs -w /dev/XXXX -R "clri <8>"

Again, I always recommend issuing these sorts of commands on copies,
and to never tamper with the initial image backup of the file
system....

> The images comprises an LVM PV and VG, so I've used kpartx to make it
> available, if that makes a difference.
> 
> There is one person claiming that it does:
> 
> http://j-b.livejournal.com/334065.html

Hmm... I don't see why that would make a difference.  At this point
what I'd really need is an e2image dump of the file system.  Please
read the e2image man page, especially the sections regarding a raw
e2image dump and a qcow e2image dump.  If you are willing to send me a
copy of your metadata blocks, please send me a qcow e2image dump and
I'll take a look at it.

> Do you have any ideas about this error, with a different LV from the same disk?:
> 
> Pass 1: Checking inodes, blocks, and sizes
> Inode 4122234 has illegal block(s).  Clear? yes
> 
> Illegal block #256918621 (1313286244) in inode 4122234.  CLEARED.
> Error storing directory block information (inode=4122234, block=0,
> num=78646612): Memory allocation failed

That's the sign of a very badly corrupted inode data structure.  We
should do a better job of handling this case automatically.

Can you send me a copy of the output of:

debugfs -w /dev/XXXX
debugfs: stat <4122234>

Then what I'd recommend doing is to use the debugfs command "clri
<4122234>" to zap the the corrupted inode, and then rerunning e2fsck.
This is relatively safe thing to try as these things go, so I won't
strongly recommend that you take an image backup of the file system
image in question before proceeding --- but in general, it's still a
good idea if you are paranoid.  :-)

The fact that you are seeing multiple errors like this really makes me
wonder.... what kind of storage device is this?  An external USB
drive?  A SATA drive?  A software raid device?  Something else?

Thanks,

						- Ted
