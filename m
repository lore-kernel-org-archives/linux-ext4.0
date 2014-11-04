From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Some thoughts about providing data block checksumming for ext4
Date: Tue, 4 Nov 2014 18:58:04 -0500
Message-ID: <20141104235804.GJ30614@thunk.org>
References: <20141103233308.GA27842@thunk.org>
 <40B6067C-099E-4665-834C-4EF98F4D5618@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dm-devel@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39020 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaKDX6K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 18:58:10 -0500
Content-Disposition: inline
In-Reply-To: <40B6067C-099E-4665-834C-4EF98F4D5618@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 04, 2014 at 02:20:44PM -0700, Andreas Dilger wrote:
> 
> My main concern here would be the potential performance impact.  This
> wouldn't ever reduce the amount of data actually written to any block
> (presumably the end of the block would be zero-filled to avoid leaking
> data), so the compress + checksum would mean every data block must have
> every byte processed by the filesystem.

Sure, if you are enabling data block checksuming, every byte of every
data block has to be processed by the file system anyway. That's kind
of inherent in checksumming the data block, after all!  And we can use
a very fast compression algorithm since we only need to compress the
block slightly, and of course, it certainly makes sense to combine the
compression ahd checksumming operation.

> I think it is easier to determine at the filesystem level if the data
> blocks are overwriting existing blocks or not, without the overhead
> of having to send per-unlink/truncate trim commands down to a DM device.

As I discussed later, we simply need to pass a hint to indicate a
block write is overwriting pre-existing data or not.

> Having this implemented in ext4 allows a lot more flexibility in how
> and when to store the checksum (e.g. per-file checksum flags that are
> inherited, store the checksum for small incompressible files in the inode
> or in extent blocks, etc).

This is a tradeoff between complexity and flexibility, yes.  If we
think users will want to checksum all of the files in the file system,
then using a dm plugin approach will be much simpler, since we won't
need all sorts of file-system level complexity (i.e., a per-inode data
data structure, using some kind of b-tree or indirect block scheme).
I don't think there are enough small incompressible files that it's
worth the complexity to try to store the checksum in the inode or
extent block.

> "dm-checksum" would be better, since "protected" falsely implies that
> the data is somehow protected against loss or corruption, when it only
> really allows detecting the corruption and not fixing it.

I like dm-checksum better, thanks!!  I'll update this in my next rev of
this design doc.

> Something like "write-once" or "idempotent" or similar, since that
> makes it clear how this is used.  I think anyone who is checksumming
> their data would consider that it is "critical".

It's not really write-once, though.   It's more like "first write".

> > For redundancy purposes we calculate the metadata checksum of the
> > checksum block assuming that low nibble of the first byte in each
> > entry is entry, and we use the low nibbles of first byte in each entry
> 
> s/each entry is entry/each entry is zero/ ?

Yes, thanks.

> The good news is that (IMHO) these two uses are largely exclusive.
> Files that are incompressible (e.g. media) are typically write-once,
> while databases and other apps that overwrite files in place do not
> typically compress the data blocks.

Yes, agreed.  That's one of the reasons why I think this design is
promising....

> Why introduce a new mechanism when this could be done using data=journal
> writes for incompressible data?  This is essentially just implementing
> jbd2 journaling with a bunch of small journals (AAs), and we could save
> a lot of code complexity by re-using the existing jbd2 code to do it.

Three reasons; first, it may not be so simple to integrate jbd2 into a
device-mapper plugin.  And secondly, I think the design I've outlined
is far more efficient than jbd2.

> Using data=journal, if there is a crash after the commit to the journal,
> the data blocks and checksums will be checkpointed to the filesystem
> again if needed, or be discarded without modifying the original data
> blocks if the transaction didn't commit.

Third, there are some real headaches if we use data=journal because we
need to keep track if a block has been previously written to the
journal, since we will need to write a revoke block if a subsequent
update to the block can use the compression+checksum format.  This is
some extra complexity which is going to be more annoying to track, and
the extra revoke blocks add additional performance overhead.

Cheers,

						- Ted
