From: tytso@mit.edu
Subject: Re: [PATCH] ext4: reduce scheduling latency with delayed allocation
Date: Mon, 1 Mar 2010 22:06:19 -0500
Message-ID: <20100302030619.GB6077@thunk.org>
References: <20100301133435.141c4bc5@leela>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Michal Schmidt <mschmidt@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49440 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab0CBDGY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Mar 2010 22:06:24 -0500
Content-Disposition: inline
In-Reply-To: <20100301133435.141c4bc5@leela>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 01, 2010 at 01:34:35PM +0100, Michal Schmidt wrote:
> mpage_da_submit_io() may process tens of thousands of pages at a time.
> Unless full preemption is enabled, it causes scheduling latencies in the order
> of tens of milliseconds.
> 
> It can be reproduced simply by writing a big file on ext4 repeatedly with
> dd if=/dev/zero of=/tmp/dummy bs=10M count=50
> 
> The patch fixes it by allowing to reschedule in the loop.
> 
> cyclictest can be used to measure the latency. I tested with:
> $ cyclictest -t1 -p 80 -n -i 5000 -m -l 20000
> 
> The results from an UP AMD Turion 2GHz with voluntary preemption:
> 
> Without the patch:
> T: 0 ( 2535) P:80 I:5000 C:  20000 Min:   12 Act:  23 Avg: 3166 Max:  70524
> (i.e. Average latency was more than 3 ms. Max observed latency was 71 ms.)
> 
> With the patch:
> T: 0 ( 2588) P:80 I:5000 C:  20000 Min:   13 Act:  33 Avg:   49 Max:  11009
> (i.e. Average latency was only 49 us. Max observed latency was 11 ms.)

Have you tested for any performance regressions as a result of this
patch, using some file system benchmarks?

I don't think this is the best way to fix this problem, though.  The
real right answer is to change how the code is structued.  All of the
callsites that call mpage_da_submit_io() are immediately preceeded by
mpage_da_map_blocks().  These two functions should be combined and
instead of calling ext4_writepage() for each page,
mpage_da_map_and_write_blocks() should make a single call to
submit_bio() for each extent.  That should far more CPU efficient,
solving both your scheduling latency issue as well as helping out for
benchmarks that strive to stress both the disk and CPU simultaneously
(such as for example the TPC benchmarks).

This will also make our blktrace results much more compact, and Chris
Mason will be very happy about that!

					- Ted

