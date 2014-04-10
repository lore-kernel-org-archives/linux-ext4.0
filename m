From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Thu, 10 Apr 2014 18:17:02 -0400
Message-ID: <20140410221702.GD31614@thunk.org>
References: <20140409223820.GU10985@gradx.cs.jhu.edu>
 <CAGagf4eEzY4+3cfNWSEENTo1PKe40nq1Ne6ZzOLGm-O78W7RcA@mail.gmail.com>
 <20140410050428.GV10985@gradx.cs.jhu.edu>
 <20140410140316.GD15925@thunk.org>
 <20140410163350.GW10985@gradx.cs.jhu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Rubin <mrubin@google.com>, Frank Mayhar <fmayhar@google.com>,
	admins@acm.jhu.edu, linux-ext4@vger.kernel.org
To: Nathaniel W Filardo <nwf@cs.jhu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52669 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbaDJWRH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 18:17:07 -0400
Content-Disposition: inline
In-Reply-To: <20140410163350.GW10985@gradx.cs.jhu.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 12:33:51PM -0400, Nathaniel W Filardo wrote:
> 
> Shouldn't cache reordering or fail to flush correctly only matter if the
> machine is crashing or otherwise losing power?  I suppose it's possible
> there's a bug that would cause the cache to fail to write a block at all,
> rather than simply "too late".  But as I said before, we've not had any
> crashes or otherwise lost uptime anywhere: host, guest, storage providers,
> etc.

If it's a cache flush problem, yes, it would only matter if there had
been a crash.  Knowing that what you are doing is a AFS mirror, this
seems even stranger, since writes would be very rare, and it's not
like you there would be a whole lot of opportunities for races ---
when you mirror an FTP site, you write a new file sequentially, and
it's not like there multiple CPU's trying to modify the file at the
same time, etc.

And if you are just seeing the results of random bit flips, one would
expect other types of corruption getting reported.  So I don't know.
This is a mystery so far...

> That said, we do occasionally, though much less often than we get reports of
> corrupted metadata, get messages that I don't know how to decode from the
> ATA stack (though naively they all seemed to be successfully resolved
> transients)?  One of our VMs, nearly identically configured, though not the
> one that's been reporting corruption on its filesystem, spat this out the
> other day, for example:
> 
> [532625.888251] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [532625.888762] ata1.00: failed command: FLUSH CACHE
> [532625.889128] ata1.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> [532625.889128]          res 40/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x4 (time out)
> [532625.889945] ata1.00: status: { DRDY }
> [532630.928064] ata1: link is slow to respond, please be patient (ready=0)
> [532635.912178] ata1: device not ready (errno=-16), forcing hardreset
> [532635.912220] ata1: soft resetting link
> [532636.070087] ata1.00: configured for MWDMA2
> [532636.070701] ata1.01: configured for MWDMA2
> [532636.070705] ata1.00: retrying FLUSH 0xe7 Emask 0x4
> [532651.068208] ata1.00: qc timeout (cmd 0xe7)
> [532651.068216] ata1.00: FLUSH failed Emask 0x4
> [532651.236146] ata1: soft resetting link
> [532651.393918] ata1.00: configured for MWDMA2
> [532651.394533] ata1.01: configured for MWDMA2
> [532651.394537] ata1.00: retrying FLUSH 0xe7 Emask 0x4
> [532651.395550] ata1.00: device reported invalid CHS sector 0
> [532651.395564] ata1: EH complete

Yeah, that doesn't look good, but you're using some kind of remote
block device here, right?  I'm not sure how qemu is translating that
into pseudo ATA commands.  Maybe that corresponds with a broken
network connection which required creating a new TCP connection or
some such?  I'm not really that familiar with the remote block device
code.  So I also can't really give you any advice about whhether it
would be better to use virtio versus achi.  I would expect that virtio
will probably be faster, but it might not matter for your application.

Cheers,

						- Ted
