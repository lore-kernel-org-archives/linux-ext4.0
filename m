From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 filesystem corruption across partitions
Date: Tue, 6 May 2014 15:40:06 -0400
Message-ID: <20140506194006.GC5012@thunk.org>
References: <1397747123.6833.24.camel@luigi>
 <20140417161249.GH18591@thunk.org>
 <20140505220130.1a256f9d@luigi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Devrin Talen <dct23@cornell.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52783 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbaEFTkJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 15:40:09 -0400
Content-Disposition: inline
In-Reply-To: <20140505220130.1a256f9d@luigi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 10:01:30PM -0400, Devrin Talen wrote:
> 
> 1. Run `ls -R *` in a loop from the root directory.  The root is
> mounted from partition 11 (system) on the eMMC and the ls will read
> the /cache (partition 12) and /data (partition 13) filesystems as well.

Try mounting /data read-only.  That should pretty much guarantee that
nothing should be able to write to it.  You can also use blktrace to
capture block I/O traces to the device, and use that to make sure
nothing was actually writing to it.

> 2. Write data to partition 12 via ADB (using `adb push ... /cache/`)

Instead of using ADB, I would suggest writing a test program which
writes a series of 512 byte sectors to a single large file in /cache.
At the beginning of each 512 byte sector include a 4 byte serial
number (which is incremented by one for each sector), a 4 byte testID
which is different for each run of your test program, a time stamp, a
CRC of these fields, and then fill the rest of the sector with some
text string to make it easy to recognize this pattern.  It can be
anything from 0xDEADBEEF, to a string such as "DEBUGGING RANDOM HW
BUGS REALLY SUCKS".  :-)

Now try to reproduce the problem with this write load.  If you can
reproduce the problem, check and see if the corrupted file system
block in the shows evidence of the string that was supposed to be
written into /cache, showing up in /data.  You can also check the
large file being written in the /cache has the expended serial number
and checksum.

This will allow you to see if a the block writes are just going to the
wrong place on the SSD, or something else more strange might be going
on.  Depending on the pattern of what blocks are ending up where they
shouldn't, it might point towards different possible causes (i.e., a
flaky solder joint, a buggy flash translation layer in the eMMC chip,
etc.)

Cheers,

					- Ted
