From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] block: use discard if possible in
 blkdev_issue_discard()
Date: Mon, 17 Feb 2014 14:19:01 -0500
Message-ID: <20140217191901.GC16660@thunk.org>
References: <20140214043256.GA5145@thunk.org>
 <yq1ioshobul.fsf@sermon.lab.mkp.net>
 <20140215012901.GA28307@thunk.org>
 <yq161odofis.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59110 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbaBQTTG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Feb 2014 14:19:06 -0500
Content-Disposition: inline
In-Reply-To: <yq161odofis.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 17, 2014 at 11:44:27AM -0500, Martin K. Petersen wrote:
> Ted> Basically, who was practicing engineering malpractice?  The SSD
> Ted> vendors, or the T10/T13 spec authors?
> 
> I think it's important to emphasize that T10/T13 specs are mainly
> written by device vendors. And they have a very strong objection to
> complicating the device firmware, keeping internal state, etc. So the
> outcome is very rarely in the operating system's favor. I completely
> agree that these flags are broken by definition.

Sigh...

One of the reasons why this came up is if you are implementing a cloud
hosting service, where disk is emulated, and since you are trying to
do something cheap-cheap-cheap (for example, OpenShift from Red Hat
has a very generous free guests policy), it's likely that you're using
something like qcow2, or thinp, or something similar to emulate disks
to drive storage costs down.  So anything we can do to eliminate I/O
work at the Host OS layer is going to be really visible, and this
includes replacing zero-block writes with the equivalent of punch or
TRIM w/ ZRAT.

> The only discard approach that provides a guaranteed result is WRITE
> SAME with the UNMAP bit set (i.e. SCSI only).

So currently blkdev_issue_zeroout() will do the WRITE SAME, but it
doesn't set the UNMAP bit, correct?  I understand there will be
environments where performance is more important than cost, where it
may not be a good idea to set the UNMAP bit.  So it sounds like what
we should do is add a flags which controls whether or not to use TRIM
w/ ZRAT or WRITE SAME with the UNMAP bit is set.

We'll then also need to work with the KVM folks to make sure that
WRITE SAME w/ UNMAP gets plumbed through to the KVM userspace, which
can then do something like FL_PUNCH if it is using a raw sparse image,
or the equivalent in qcow2, etc.

(If the KVM folks want to be even more aggressive, if they know they
are using an underlying storage system where keeping the allocated
blocks isn't really going to help performance, even if the UNMAP bit
isn't set and the data block is all zero's, maybe they might want to
unmap the block(s) anyway.  Or we could leave this up to the Guest OS
userspace, and plumb a hint from the Host to the Guest that it should
really use WRITE SAME w/ UNMAP.  But I'm not convinced it's worth it.)

Does this sound like a reasonable way to go?

> The good news is that most devices that report DRAT/RZAT are doing the
> right thing due to server/RAID vendor pressure.   But SSD vendors are
> generally not willing to give such guarantees in the datasheets.

I imagine the reason why they aren't willing to give such guarantees
is that it would cost more to do the testing to assure this, and while
they know that a certain firmwar version shipped to $BIG_HDD_CUSTOMER
does the right thing, it might regress without their knowing about it
in some future firmware version.

On the other hand, if there was a white list kept somewhere, either in
the kernel, or in some more dynamically updated list (ala what
smartctl does to get the latest vendor-specific attributes), being on
the white list might be enough of a commercial advantage that drive
vendors would be incentivized to provide such a guarantee.  Especially
if, say, a major SSD vendor such as Intel could be induced make such a
public guarantee and we publicized this fact.

						- Ted
