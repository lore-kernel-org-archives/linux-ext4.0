From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5] ext4: RFC: Encryption
Date: Thu, 24 Jul 2014 08:26:59 -0400
Message-ID: <20140724122659.GI6673@thunk.org>
References: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
 <7C8F8758-DE9E-46D3-AB30-236EB20F8A4B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Halcrow <mhalcrow@google.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, zohar@linux.vnet.ibm.com,
	herbert@gondor.apana.org.au, pavel@ucw.cz, hch@infradead.org,
	lczerner@redhat.com, tyhicks@canonical.com,
	serge.hallyn@canonical.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54362 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbaGXM1V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jul 2014 08:27:21 -0400
Content-Disposition: inline
In-Reply-To: <7C8F8758-DE9E-46D3-AB30-236EB20F8A4B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 23, 2014 at 04:39:43PM -0600, Andreas Dilger wrote:
> 
> Maybe it is worthwhile to take a step back and explain what your overall
> goal is?  What is the benefit of implementing crypto at the filesystem
> level over at the block device level?  Are you targeting per-user crypto
> keys?  Fast secure deletion of files by having per-inode keys that are
> encrypted by the filesystem/user key and then clobbered at deletion time?

One particular use case would involve per-user crypto keys, and where
space for things like (for example), browser cache files, can be
efficiently shared across multiple users, and where a root or some
privileged user can selectively delete cache files belonging to
another user in order to free up space, although without access to the
keys, root wouldn't be able to gain access to the data files.

The thinking was that each file would be encrypted using a per-file
key, and then the per-file key could be encrypted by one or more user
keys, and stored in the extended attributes.

(Hence, it's important for this design that the file metadata remains
unencrypted; that way it's possible to delete an encrypted file
without having access to the keys, and so e2fsck can check a file
system without having access to the keys.  The flip side to this is
that we are potentially leaking more information due to the metadata
being encrypted.  So for many use cases, using a block device dm-crypt
is going to be the better choice.  But in this particular case, we do
need some of the attributes of ecryptfs, but we want something which
is more efficient and more stable/less bug-prone that ecryptfs.
Michael acknowledged all of this in his presentation at the ext4
workshop in February, and apologized for inflicting ecryptfs on the
world; you can think of this as atonement, by coming up with something
better as a replacement.  :-)

Anyway, the question of the how to drive the policy of deciding which
key or keys should be used to encrypt the per-file key is something
for which we can add additional flexibility and power later; none of
this is in the patch series.

So the main thing that's up for review is the changes to the read and
write paths.  One of the things that I'm especially looking for input
is the changes to fs/buffer.c.  We've tried to keep the changes
minimal, and general, but something that I've considered is to simply
stop using fs/mpage.c and fs/buffer.c for the read path, and extending
fs/ext4/page_io.c so it is used for ext4's read and write path.

There are some advantages to doing this, in that it would reduce CPU
overhead on the read path (since right now we end up calling
ext4_get_block, and hence ext4_map_blocks for every single block), and
would allow us to avoid needing to attach buffer heads to pages except
for the data=journal mode.  So this is something I'll want to do at
some point.

But, it would be simpler for review purposes to keep the modification
of ext4 to use page_io.c for reads separate from the encryption
changes, and other file systems that are still using fs/buffer.c and
fs/mpage.c might find these changes to be useful.  So there are
arguments both ways.

> We've also previously discussed storing file-data checksums in some form.
> One of the leading candidates being either a per-block table of checksums
> that are statically mapped either for every block in the filesystem, or
> only to the "data" blocks of the filesystem (i.e. those that don't contain
> fixed metadata that already has its own checksums such as inode tables,
> bitmaps, and backup group descriptors/superblocks).  The other possibility
> is storing checksums with each extent, with the option to make the extents
> as small or large as needed.  See thread starting at:
> http://www.spinics.net/lists/linux-ext4/msg42620.html

Yes, this was discussed at the ext4 workshop in February, when Michael
presented his initial plans.  The hope was that we could reuse the
infrastructure file-data checksums for the data integrity checksums.
The other potential thoguht was that some of infrastructure Ming ming
has been thinking about for reflink support could also be used for
both normal checksums and data integrity checksums.  We'll have to see
what Lukas and Mingming come up with....

Cheers,

						- Ted
