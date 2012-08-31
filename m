From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Kernel panic from corrupt journal
Date: Fri, 31 Aug 2012 13:46:54 -0400
Message-ID: <20120831174654.GA6342@thunk.org>
References: <20120830092212.GB12981@nsrc.org>
 <20120831055349.GA18086@thunk.org>
 <20120831085307.GC17438@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48156 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2HaRrC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2012 13:47:02 -0400
Content-Disposition: inline
In-Reply-To: <20120831085307.GC17438@nsrc.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 31, 2012 at 09:53:07AM +0100, Brian Candler wrote:
> 
> You're quite right: yesterday I did see some I/O errors after I had mounted
> the filesystem using -o ro,noload.
> 
> So this morning I ran
> 
>   dd if=/dev/sda8 of=/dev/null bs=1024k
> 
> and it completed without a problem. And then I found I was able to mount the
> filesystem just fine!
> 
> So this is definitely a hardware problem; it's just I didn't realise I/O
> errors could cause kernel panics as well as EIO.

Well, it's not *supposed* to cause kernel panics.  If you can get a
stack trace in the future under similar circumstnaces, definitely
capture it (using a digital camera if you don't have a better way,
such as a network console or a serial console).  Even if it's not an
ext4 bug, but I'm happy to to try to route the bug report to the
appropriate kernel developer or mailing list.

> I am currently refreshing my most recent backup of this drive, and I'll
> replace it ASAP.

The drive *might* be OK at this point.  If you are willing to run a
full read/write test on the drive, and it shows no problem, it might
be worth trying to put it back in production (especially if you are
keeping regular backups); if it fails a second time, then it's
definitely time to replace it.  It's really a question of how much the
cost of a new drive is worth compared to your time and the value of
your data in case of a second failure.

Or maybe you could a buy a second 500G drive, and set up software RAID
1 using the md device.  This will give you protection if either of the
two drive fails, as well as giving you speed boost for reads.

Cheers!

						- Ted
