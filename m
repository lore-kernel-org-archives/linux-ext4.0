From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/2] ext3 HACKs
Date: Tue, 14 Jul 2009 11:51:18 -0400
Message-ID: <20090714155118.GB10131@mit.edu>
References: <20090714140253.25993.64525.sendpatchset@ahunter-tower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew.Morton.akpm@linux-foundation.org,
	Andreas.Dilger.adilger@sun.com, Stephen.Tweedie.sct@redhat.com,
	Artem Bityutskiy <artem.bityutskiy@nokia.com>,
	linux-ext4@vger.kernel.org
To: Adrian Hunter <adrian.hunter@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57359 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbZGNPvk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jul 2009 11:51:40 -0400
Content-Disposition: inline
In-Reply-To: <20090714140253.25993.64525.sendpatchset@ahunter-tower>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 14, 2009 at 05:02:53PM +0300, Adrian Hunter wrote:
> Hi
> 
> We are using linux 2.6.28 and we have a situation where ext3
> can take 30-60 seconds to mount.
> 
> The cause is the underlying device has extremely poor random
> write speed (several orders of magnitude slower than sequential
> write speed), and journal recovery can involve many small random
> writes.
> 
> To alleviate this situation somewhat, I have two moderately ugly
> hacks:
> 	HACK 1: ext3: mount fast even when recovering
> 	HACK 2: do I/O read requests while ext3 journal recovers
> 
> HACK 1 uses a I/O barrier in place of waiting for recovery I/O to be
> flushed.
> 
> HACK 2 crudely throws I/O read requests to the front of the dispatch
> queue until the I/O barrier from HACK 1 is reached.

Have you actually benchmarked these patches, ideally with a fixed
filesystem image so the two runs are done requiring exactly the same
number of blocks to recover?  We implement ordered I/O in terms of
doing a flush, so it would be surprising to see that a significant
difference in times.  Also, it would be useful to do a blktrace before
and after your patches, again with a fixed filesystem image so the
experiment can be carefully controlled.

Regards,

						- Ted
