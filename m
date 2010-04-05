From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Mon, 05 Apr 2010 16:41:48 -0400
Message-ID: <x49vdc5iqcz.fsf@segfault.boston.devel.redhat.com>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
	<20100405175205.GA4681@thunk.org>
	<x49hbnpkaqw.fsf@segfault.boston.devel.redhat.com>
	<20100405194803.GC23670@thunk.org>
	<x49zl1hiqoz.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, esandeen@redhat.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219Ab0DEUlz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Apr 2010 16:41:55 -0400
In-Reply-To: <x49zl1hiqoz.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Mon, 05 Apr 2010 16:34:36 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeff Moyer <jmoyer@redhat.com> writes:

> tytso@mit.edu writes:
>
>> On Mon, Apr 05, 2010 at 02:36:07PM -0400, Jeff Moyer wrote:
>>> >
>>> > What benchmark were you using to test small file writes?  This looks
>>> > good to me as well, but we might want to do some extra benchmarking
>>> > just to be sure we're not accidentally introducing a performance
>>> > regression.
>>> 
>>> iozone showed regressions for write and re-write in runs that include
>>> fsync timings for small files (<8MB).  Here's the command line used for
>>> testing:
>>> 
>>> iozone -az -n 4k -g 2048m -y 1k -q 1m -e
>>
>> iozone is showing performance regressions or performance improvements?
>> I thought the point of this patch was to improve iozone benchmarks?
>
> Sorry, Ted, what I meant to say was that iozone showed differences
> between deadline and cfq, where cfq's performance was much worse than
> deadline's.

And to be 100% clear, with the patch, the performance differences
between deadline and cfq were in the noise.

Cheers,
Jeff
