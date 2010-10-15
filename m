From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Performance testing of various barrier reduction patches [was:
	Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Fri, 15 Oct 2010 16:39:04 -0700
Message-ID: <20101015233904.GG25624@tux1.beaverton.ibm.com>
References: <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com> <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca> <20100927230111.GV25555@tux1.beaverton.ibm.com> <20101008212606.GE25624@tux1.beaverton.ibm.com> <4CAF937C.4020500@redhat.com> <20101011202020.GF25624@tux1.beaverton.ibm.com> <20101012141455.GA27572@lst.de>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:51816 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0JOXjF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Oct 2010 19:39:05 -0400
Content-Disposition: inline
In-Reply-To: <20101012141455.GA27572@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 12, 2010 at 04:14:55PM +0200, Christoph Hellwig wrote:
> I still think adding code to every filesystem to optimize for a rather
> stupid use case is not a good idea.  I dropped out a bit from the
> thread in the middle, but what was the real use case for lots of
> concurrent fsyncs on the same inode again?

The use case I'm looking at is concurrent fsyncs on /different/ inodes,
actually.  We have _n_ different processes, each writing (and fsyncing) its own
separate file on the same filesystem.

iirc, ext4_sync_file is called with the inode mutex held, which prevents
concurrent fsyncs on the same inode.

> And what is the amount of performance you need?  If we go back to the
> direct submission of REQ_FLUSH request from the earlier flush+fua
> setups that were faster or high end storage, would that be enough for
> you?
> 
> Below is a patch brining the optimization back.
> 
> 	WARNING: completely untested!

So I hacked up a patch to the block layer that collects measurements of the
time delay between blk_start_request and blk_finish_request when a flush
command is encountered, and what I noticed was that there's a rather large
discrepancy between the delay as observed by the block layer and the delay as
observed by ext4.  In general, the discrepancy is a nearly 2x increase between
what the block layer sees and what ext4 sees, so I'll give Christoph's
direct-flush patch (below) a try over the weekend.

--D
