From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Using Cache barriers in lieu of REQ_FLUSH | REQ_FUA for emmc 5.1
 (jdec spec JESD84-B51)
Date: Sat, 19 Sep 2015 23:42:48 -0400
Message-ID: <20150920034248.GB2909@thunk.org>
References: <55F8A71A.3030001@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60681 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbbITDmw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Sep 2015 23:42:52 -0400
Content-Disposition: inline
In-Reply-To: <55F8A71A.3030001@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 15, 2015 at 04:17:46PM -0700, Nikhilesh Reddy wrote:
> 
> The eMMC 5.1 spec defines cache "barrier" capability of the eMMC device as
> defined in JESD84-B51
> 
> I was wondering if there were any downsides to replacing the
> WRITE_FLUSH_FUA	 with the cache barrier?
> 
> I understand that REQ_FLUSH is used to ensure that the current cache be
> flushed to prevent any reordering but I dont seem to be clear on why
> REQ_FUA is used.
> Can someone please help me understand this part?
>
> I know there there was a big decision in 2010
> https://lwn.net/Articles/400541/
> and http://lwn.net/Articles/399148/
> to remove the software based barrier support... but with the hardware
> supporting "barriers" is there a downside to using them to replace the
> flushes?

OK, so a couple of things here.

There is queuing happening at two different layers in the system;
once at the block device layer, and one at the storage device layer.
(Possibly more if you have a hardware RAID card, etc., but for this
discussion, what's important is the queuing which is happening inside
the kernel, and that which is happening below the kernel.

The transition in 2010 is referring to how we handle barriers at the
block device layer, and was inspired by the fact that at that time,
the vast majority of the storage devices only supported "cache flush"
at the storage layer, and a few devices would support FUA (Force Unit
Attention) requests.  But it can support devices which have a true
cache barrier function.

So when we say REQ_FLUSH, what we mean is that the writes are flushed
from the block layer command queues to the storage device, and that
subsequent writes will not be reordered before the flush.  Since most
devices don't support a cache barrier command, this is implemented in
practice as a FLUSH CACHE, but if the device supports cache barrier
command, that would be sufficient.

The FUA write command is the command that actually has temporal
meaning; the device is not supported to signal completion until that
particular write has been committed to stable store.  And if you
combine that with a flush command, as in WRITE_FLUSH_FUA, then that
implies a cache barrier, followed by a write that should not return
until write (FUA), and all preceeding writes, have been committed to
stable store (implied by the cache barrier).

For devices that support a cache barrier, a REQ_FLUSH can be
implemented using a cache barrier.  If the storage device does not
support a cache barrier, the much stronger FLUSH CACHE command will
also work, and in practice, that's what gets used in for most storage
devices today.

For devices that don't support a FUA write, this can be simulated
using the (overly strong) combination of a write followed by a FLUSH
CACHE command.  (Note, due to regressions caused by buggy hardware,
the libata driver does not enable FUA by default.  Interestingly,
apparently Windows 2012 and newer no longer tries to use FUA either;
maybe Microsoft has run into consumer-grade storage devices with
crappy firmware?  That being said, if you are using SATA drives which
in a JBOD which is has a SAS expander, you *are* using FUA --- but
presumably people who are doing this are at bigger shops who can do
proper HDD validation and can lean on their storage vendors to make
sure any firmware bugs they find get fixed.)

So for ext4, when we do a journal commit, first we write the journal
blocks, then a REQ_FLUSH, and then we FUA write the commit block ---
which for commodity SATA drives, gets translated to write the journal
blocks, FLUSH CACHE, write the commit block, FLUSH CACHE.

If your storage device has support for a barrier command and FUA, then
this could also be translated to write the journal blocks, CACHE
BARRIER, FUA WRITE the commit block.

And of course if you don't have FUA support, but you do have the
barrier command, then this could also get translated to write the
journal blocks, CACHE BARRIER, write the commit block, FLUSH CACHE.

All of these scenarios should work just fine.

Hope this helps,

				- Ted
