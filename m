From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Wed, 24 Nov 2010 21:48:00 -0500
Message-ID: <4CEDCE60.9050109@teksavvy.com>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com> <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com> <20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com> <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com> <20101119163013.GJ10039@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:53635 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754332Ab0KYCsC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Nov 2010 21:48:02 -0500
In-Reply-To: <20101119163013.GJ10039@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-19 11:30 AM, Ted Ts'o wrote:
> On Fri, Nov 19, 2010 at 04:44:33PM +0100, Lukas Czerner wrote:
>>>
>>> But, oddly, it _is_ the default for mke2fs -t ext4,
>>> which really threw me for a loop recently.
>>>
>>> I though my system had locked up when suddenly everything
>>> went dead for a very long time (many minutes) while installing a
>>> new system.
>
> Yeah, the assumption was doing a single big discard (which is all
> mke2fs is doing) should be fast.  At least on sanely implemented SSD's
> (i.e., like the Intel X25-M) it should be, since all that should
> require is a flash write to the global mapping table, declaring all of
> the blocks as free.

But mke2fs probably is NOT doing a "single big discard", because for SATA the
TRIM command is limited to 64K sectors per range.. and the in-kernel TRIM
code only ever does single ranges..

So doing a discard over an entire drive-encompassing partition, say.. 100GB,
will require 3000+ individual TRIM commands.  At (say) 200msecs each, that
adds up to about ten minutes of execution time.  Or less if the drive is
faster than that.

Whereas.. grouping them into 64-ranges per trim, could reduce the execution
time down to perhaps 1/50th of that, or in the range of 10-20 seconds instead.

Cheers
