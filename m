From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Mon, 05 Apr 2010 14:36:07 -0400
Message-ID: <x49hbnpkaqw.fsf@segfault.boston.devel.redhat.com>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
	<20100405175205.GA4681@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, esandeen@redhat.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab0DESgO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Apr 2010 14:36:14 -0400
In-Reply-To: <20100405175205.GA4681@thunk.org> (tytso@mit.edu's message of
	"Mon, 5 Apr 2010 13:52:05 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Thu, Apr 01, 2010 at 03:04:54PM -0400, Jeff Moyer wrote:
>> 
>> So, I'm submitting this patch for comments and testing.  I have a
>> similar patch for jbd that I will submit if folks agree that this is a
>> good idea.
>
> Added to the ext4 patch queue.
>
> What benchmark were you using to test small file writes?  This looks
> good to me as well, but we might want to do some extra benchmarking
> just to be sure we're not accidentally introducing a performance
> regression.

iozone showed regressions for write and re-write in runs that include
fsync timings for small files (<8MB).  Here's the command line used for
testing:

iozone -az -n 4k -g 2048m -y 1k -q 1m -e

I also ran fs_mark using the following command line:

fs_mark -S 1 -D 100 -N 1000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096

I'll let you know if there are any regressions caused by this patch in
any of our other testing.

Cheers,
Jeff
