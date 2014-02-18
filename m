From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] block: use discard if possible in
 blkdev_issue_discard()
Date: Mon, 17 Feb 2014 21:17:47 -0500
Message-ID: <20140218021747.GG26580@thunk.org>
References: <20140214043256.GA5145@thunk.org>
 <yq1ioshobul.fsf@sermon.lab.mkp.net>
 <20140215012901.GA28307@thunk.org>
 <yq161odofis.fsf@sermon.lab.mkp.net>
 <20140217191901.GC16660@thunk.org>
 <yq11tz1p5o9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59253 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaBRCRx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Feb 2014 21:17:53 -0500
Content-Disposition: inline
In-Reply-To: <yq11tz1p5o9.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 17, 2014 at 08:31:50PM -0500, Martin K. Petersen wrote:
> 
> Your variant seems to land somewhere in-between. You want a
> blkdev_issue_clear() that zeroes a block range and it's then up to the
> storage device to decide whether to provision or deprovision the space
> as long as you are guaranteed to get zeroes back for each block in the
> range on a subsequent read. Is that a correct interpretation?

Ultimately the storage device (or host OS) can always decide to
deprovision the space if it is given a write of all zeroes; there's
nothing in the specs that say anything at all about performance
considerations, or what the back-end storage decides to do in order to
handle a particular write command, so long as a subsequent read
returns the correct data.

So what I want is a way in which the guest (kernel, file system, etc)
should be able to request that the space be deprovisioned.  So it's a
hint insofar ultimately, the host can always decide whether or not
whether or not to honor the deprovision request (or the host could
decide to deprovision a block even if it's not explicitly requested).

However, I don't want it to be a hint insofar that a subsequent read
is *guaranteed* to return all zeros after this "blkdev_issue_clear()"
command has been successfully sent to the device.

Does that make sense?

> I'm trying to pin down your exact use case because it can get very murky
> between the SCSI and ATA variants. And the fact that the same knobs are
> used for both over and under-provisioned devices. SCSI also has an
> additional state: Blocks can be either mapped, anchored or deallocated.

What does "anchored" mean?  Does is it the equivalent of using
fallocate() to allocate the block, but it's marked uninitialized so
any attempt to read it returns zeroes?  If so, that certainly sounds
like useful functionality that would be great if KVM exposed via
virt-scsi.

						- Ted

