From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] block: use discard if possible in
 blkdev_issue_discard()
Date: Tue, 18 Feb 2014 00:47:07 -0500
Message-ID: <20140218054707.GI26580@thunk.org>
References: <20140214043256.GA5145@thunk.org>
 <yq1ioshobul.fsf@sermon.lab.mkp.net>
 <20140215012901.GA28307@thunk.org>
 <yq161odofis.fsf@sermon.lab.mkp.net>
 <20140217191901.GC16660@thunk.org>
 <yq11tz1p5o9.fsf@sermon.lab.mkp.net>
 <20140218021747.GG26580@thunk.org>
 <yq1ob25nky8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59305 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaBRFrO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Feb 2014 00:47:14 -0500
Content-Disposition: inline
In-Reply-To: <yq1ob25nky8.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 17, 2014 at 10:44:47PM -0500, Martin K. Petersen wrote:
> 
> Well, that has changed a bit with the logical block provisioning bits in
> SCSI. That's why I brought up the allocation/deallocation assumptions in
> the existing two blkdev_issue_foo() calls.

Is it a fair assumption that the reason why T10 added these bits is
mainly so that clients of thin-provisioned storage devices can
guarantee that a subseq uent write won't fail?  Since historically the
spec writers have washed their hands of anything that might vaguely
smell of performance considerations....

> Yeah. So deprovision with guaranteed zero on read is what you're
> after. I'll chew on that a bit tomorrow.

Yes.  And also some way for the host OS (or some other underlying
storage device, more generally) to send hints to the guest OS about
the best way to tune filesystems at mkfs and/or mount time for best
performance, so we don't have to require the system administrator to
have to manually set mount options, mkfs options, and/or magic "echo"
commands to /proc or /sys files.

It would be great if we could get SATA and SCSI devices to also
deliver these hints to kernel, or to have our kernels make some
hueristics based on various SCSI mode pages, and then deliver it to
the file system or via some defined /sys files so that userspace
programs like mkfs can automatically DTRT.  I'm not sure if this is
going to require spec changes and hardware changes, or whether there
are some existing hints form the device drivers that we might be able
to leverage.

For example, right now I'm just manually using the discard mount
options on certain PCIe-attached flash where I know it's beneficial,
but it's a manual tuning based on knowledge of the underlying storage
device.  Figuring out when it's better to use fstrim, or doing it at
unlink time, etc., is something that's better done automatically
instead of manually, but this is I fear answering questions like this
in a reliable fashion is going to be a very hard problem --- and as
storage devices get more complex, such as hybrid drives with even more
varied and interesting performance characteristics, it's only going to
get harder!

						- Ted
