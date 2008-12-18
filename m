From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Thu, 18 Dec 2008 19:00:04 +0100
Message-ID: <20081218180004.GB6797@atrey.karlin.mff.cuni.cz>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52180 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYLRSAF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 13:00:05 -0500
Content-Disposition: inline
In-Reply-To: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> A few weeks ago I posted a patch for discussion that allowed ext4 to run
> without a journal.  Since that time I've integrated the excellent
> comments from Andreas and fixed several serious bugs.  We're currently
> running with this patch and generating some performance numbers against
> both ext2 (with backported reservations code) and ext4 with and without
> a journal.  It just so happens that running without a journal is
> slightly faster for most everything.
> 
> We did
> 	iozone -T -t 4 s 2g -r 256k -T -I -i0 -i1 -i2
> 
> which creates 4 threads, each of which create and do reads and writes on
> a 2G file, with a buffer size of 256K, using O_DIRECT for all file opens
> to bypass the page cache.  Results:
> 
>                      ext2        ext4, default   ext4, no journal
>   initial writes   13.0 MB/s        15.4 MB/s          15.7 MB/s
>   rewrites         13.1 MB/s        15.6 MB/s          15.9 MB/s
>   reads            15.2 MB/s        16.9 MB/s          17.2 MB/s
>   re-reads         15.3 MB/s        16.9 MB/s          17.2 MB/s
>   random readers    5.6 MB/s         5.6 MB/s           5.7 MB/s
>   random writers    5.1 MB/s         5.3 MB/s           5.4 MB/s 
> 
> So it seems that, so far, this was a useful exercise.
  Interesting although I'm not that surprised because those tests seem
to do a lot of data changes (which are never journaled in fact) and tiny
amount of metadata changes. If you run some benchmark doing lots of
directory operations, I guess the numbers would be considerably
different. Maybe trying dbench (I know it's kind of stupid ;) or
postmark will show the differences better.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
