From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: BLKZEROOUT + pread should return zeroes, right?
Date: Wed, 15 Oct 2014 06:02:57 -0400
Message-ID: <20141015100257.GB30308@thunk.org>
References: <yq1iojm6rti.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
	linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53037 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbaJOKDC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Oct 2014 06:03:02 -0400
Content-Disposition: inline
In-Reply-To: <yq1iojm6rti.fsf@sermon.lab.mkp.net>
 <20141015012534.GB12013@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2014 at 06:25:34PM -0700, Darrick J. Wong wrote:
> 
> > adding feature tests, etc., and is it worth the upside of being able
> > to use WRITE SAME for a few 4k or 8k writes?  (Which the vast majority
> > of storage devices don't support anyway....)
> 
> I've converted mke2fs and e2fsck to use BLKZEROOUT to zero the journal and the
> inode tables when they want something to really be zero, and ext2fs_fallocate
> uses it to zero the fallocated range.  I suspect those three will zero long
> runs of sectors each call.

Sure, I agree that BLKZEROOUT might make sense for zero'ing the
journal and the inode table.  But the journal isn't that large, and
the inode tables don't need to be zero'ed if lazy_itable_init is
enabled.  So the actual time saved in mke2fs isn't that great.

> As for WRITE_SAME support, if it's there, why ignore it?  The ioctl exists;
> someone else is bound to use it sooner or later.

For the special case of mke2fs, we can use BLKZEROOUT without too much
difficulty; we can call fsync() on the block device, and if we're
really paranoid, use posix_fadvise(..., POSIX_FADV_DONTNEED) to make
sure the buffer cache is emptied --- although for the case of mke2fs,
we don't really need to worry that much about cache aliasing issues
since the blocks that we would be interested in zero'ing out are not
blocks that would be first written, or later read, using buffered I/O.

But I really don't think it's worth the effort to make WRITE_SAME work
for e2fsck, where (a) the WRITE_SAME would only be for very small
regions, (b) the issues of cache aliasing are much more likely, and
(c) where switching over to O_DIRECT will often slow down e2fsck for
many types of storage devices.  (Unless you have a very, very large
number of disks for which you are trying to run e2fsck in parallel
across all of them at once, and comparatively very small amounts of
memory such that there isn't much room for the buffer cache.  In most
other cases, though, I've benchmarked O_DIRECT for e2fsck, and it is
not a win.)

> A further optimization to mke2fs would be to detect that we've run
> discard-with-zeroes and therefore can skip issuing subsequent zeroouts on the
> same ranges, but I'm wary that discard-zeroes-data does what it purports to do.
> If it /does/ work reliably, though, ext2fs_zero_blocks() could be rerouted to
> use discard instead.  Really my reason for wanting to use zeroout is that in
> guaranteeing the zero-read behavior afterwards it seems like it ought to be
> less problematic than discard has been.

So the main issue is with devices that advertise discard_zeros_data is
that technically, the SATA spec still specificies the discard as
"advisory", and so there have apparently been devices where under
heavy load (lots of other writebacks and GC activity happening in the
background), they will decide they are too busy, and will simply drop
the "advisotry" trim, and so the blocks never get zero'ed.

I've talked to some engineers at some HDD vendors, and they have
assured me _they_ would never allow that to happen, and this was only
something done by fly-by-night / startup SSD vendors that deserved to
go out of business.  Nevertheless, despite this, the SATA spec
currently seems to allow the interpretation that all discards can be
considered advisory by the SSD, even if it advertises
discard-zeroes-data.

I'm not sure if how much of an issue this is with eMMC devices or
PCI-attached flash, and of course, if you are a handset manufacturer
or are a large systems integrator purchasing a very large number of
devices, it becomes possible to negotitate guarantees beyond what is
guaranteed by the spec, and if you are buying a large number of
devices you can do testing to make sure such devices don't have such
anti-social behaviour.  Unfortunately, that's not something the
average consumer who is buying the cheapest possible SSD from Amazon
or buy.com can count on.

Despite all of this, we are actually depending on discard-zeroes-data
in mke2fs today, and this is mostly because (a) I haven't yet seen a
case in practice where it has been a problem for mke2fs --- in general
the write patterns for mke2fs tend to be less taxing for most SSD's,
as compared to a disk under heavy random write traffic with WRITE_SAME
being used to zero out short block ranges as in ext4_ext_zeroout(),
and (b) if the SSD does end up failing to zeroout portions of the
journal, it's not a complete disaster --- it's only problematic if we
have an unclean shutdown before the journal has been cycled through
completely, and if we are unlucky with the previous contents of the
journal blocks.

(And if journal checksums are enabled, this risk is reduced even more,
to the point where we shouldn't need to zero out the journal at all.)

So I've not been super concerned about this, even though I know we're
being a little bit risky here.  I would definitely never trust
discard-zeroes-data in ext4_ext_zeroout(), though.

On Tue, Oct 14, 2014 at 09:32:25PM -0400, Martin K. Petersen wrote:
> 
> It's dubious. I'm working on making sure we only set discard_zeroes_data
> when the device guarantees it for 3.19.

I'm curious how you were going to determine that the device guarantees
that discard_zeroes_data will be honored.  Is there some new bit in
some mode page that promises that discards won't be thrown away any
time the device feels like it?

Cheers,

							- Ted
