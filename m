From: Theodore Tso <tytso@mit.edu>
Subject: Re: Reoccurring ext3 errors: attempt to access beyond end of
	device, freeing blocks not in datazone
Date: Tue, 20 May 2008 08:35:05 -0400
Message-ID: <20080520123505.GP15035@mit.edu>
References: <4832941A.70806@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55436 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763473AbYETMf3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 08:35:29 -0400
Content-Disposition: inline
In-Reply-To: <4832941A.70806@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> After running e2fsck everything is fine again for a week or a little
> longer...

Did e2fsck report any errors?  You didn't say; but if this kind of
corruption were really on the hard drive itself, it would cause e2fsck
to scream bloody murder.  

If e2fsck didn't report any problems, then the problem is certainly on
the read path, and your system is sometimes returning corrupted data
--- probably because in some cases when the system asked for a disk
block #1234, it somehow got disk block #1257, or something like that.
In any case, you should have gotten some errors that inodes were
referring to invalid block numbers; that's what the Linux kernel was
complaining about.

> What I would like to know: what are the possible underlying causes for
> the "attempt to access beyond en of device" error? Does anyone see any
> meaning in the block (?) numbers mentioned in my syslog?

The errors you have here indicate a corrupt indirect block.  So when
trying to read from an inode with the corrupted indirect block, it
asked the block I/O layer to read from a block far larger than the
size of the block device.  

The errors from the block I/O error are in units of sectors, so you
need to divide them by 8 to get 4k block numbers:

> > May 20 09:13:14 infinity kernel: attempt to access beyond end of device
> > May 20 09:13:14 infinity kernel: loop0: rw=0, want=15629775440, limit=4404019200

So for these, you had

15629775440 / 8 = 0x74736E4A   (or in ascii 'Jnst')
13075964688 / 8 = 0x616C6C62   (or in ascii 'blla')
15354014352 / 8 = 0x72657552   (or in ascii 'Ruer')

These errors errors happen when deleting a file with a bogus indirect
block (or garbage in the inode, but that's much less likely and
probably would have triggered additional complaints).

> > May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1953721929, count = 1

Converting these numbers to hex:

1953721929 = 0x74736E49  (or in ascii 'Jnst')
1634495585 = 0x616C6C61  (or in ascii 'alla'
 543517044 = 0x20656974  (or in ascii 'tie ')
1919251793 = 0x72657551  (or in ascii 'Quer')

Given that it's all ascii, it looks like the indirect block somehow
was overwritten, or was substituted by text.

					- Ted
