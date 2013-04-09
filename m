From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fwd: block level cow operation
Date: Tue, 9 Apr 2013 17:02:04 -0400
Message-ID: <20130409210204.GB430@thunk.org>
References: <CAD6i1f+GsVZJwaz1R3NDjP_m8nOCUsmqHTQS3R=M+d+hq8f5vw@mail.gmail.com>
 <CAD6i1f+NLF6Vj8D84FFWAbDttqbBvcg-kWswf7Hez2o0-cXpMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32949 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936281Ab3DIVCN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 17:02:13 -0400
Content-Disposition: inline
In-Reply-To: <CAD6i1f+NLF6Vj8D84FFWAbDttqbBvcg-kWswf7Hez2o0-cXpMw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 09, 2013 at 02:35:56PM +0530, Prashant Shah wrote:
> I am trying to implement copy on write operation by reading the
> original disk block and writing it to some other location....

Lukas asked the correct first question, which is why are you trying to
do this?  If the goal is to make COW snapshots, then there's a lot of
accounting information that you'll need to keep track of, and it is
very doubtful ext4 will be the right place to do things.

If the goal is to do efficient writes into cheap eMMC flash for random
write workloads (i.e., which is the same problem f2fs is trying to
solve), it's not totally insane to try to adapt ext4 to handle this
problem.

#1 You'd need to add support into mballoc to understand how to align
its block writes on eMMC erase block boundaries, and to have a mode
where it gives you sequentially increasing physical blocks ignoring
the logical block numbers.

#2 You'd need to intercept the write requests at the writepages() and
writepage() calls, and that's where the decision would have to be made
to allocate a new set of block numbers, based on some flag setting
that would either be on a per-filesystem or per open file basis.  As
part of the I/O completion callback, where today we have code paths to
convert an uninitialized extent to initialized extents, we could teach
that code path to update the logical block mapping.

#3 You'd have to come up with some approach to deal with direct I/O
(including potentially not supporting COW writes for DIO).  

#4 You'd probably only want to do this for indirect block mapped
files, since for a random write workload, the extent tree would
become very inefficient very quickly.


So it's not _insane_ but it's a huge amount of work, and it would be
very trickly, and it's not something that I would recommend, say, if a
student was looking for a term project.  It would also not be faster
on SSD or HDD's.  The only reason to do something like this would be
to deal with the extremely low-cost FTL of cheap eMMC flash devices
(where the BOM cost of eMMC is approximately two orders of magnitude
cheaper than SSD's).  So if you are benchmarking this on a HDD or SSD,
don't be surprised if it's much slower.  And if you are benchmarking
on eMMC, you have to make sure that you have the writes appropriately
erase block aligned, or any performance gains would be hopeless.

Regards,

					- Ted
