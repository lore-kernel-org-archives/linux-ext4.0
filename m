From: Christoph Hellwig <hch@lst.de>
Subject: Re: Performance testing of various barrier reduction patches [was: Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Tue, 19 Oct 2010 20:28:18 +0200
Message-ID: <20101019182817.GA11810@lst.de>
References: <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com> <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca> <20100927230111.GV25555@tux1.beaverton.ibm.com> <20101008212606.GE25624@tux1.beaverton.ibm.com> <20101018224936.GI25624@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	hch@lst.de
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43903 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab0JSS2w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Oct 2010 14:28:52 -0400
Content-Disposition: inline
In-Reply-To: <20101018224936.GI25624@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 18, 2010 at 03:49:36PM -0700, Darrick J. Wong wrote:
> Through this table, I'm looking for a performance characteristic that typifies
> storage with a battery-backed write cache (BBWC).  As we can see from
> lldd_flush_rtt_avg, the BBWC storage features a very low flush time, about 1ms
> or less.  Everything else, including SSDs, are over that amount.  The other odd
> result I see is that it takes a significant amount of time to get a flush
> command from the top of the block layer to the LLDD, though I suspect some of
> that might be waiting for the device to process earlier writes.  Christoph has
> a patch that looks like it streamlines that, but it triggered various BUG_ONs
> when I booted with it, so I took the patch out.

We currently synchronize flush requests.  There's no real reason to do
it except that we'll either need to make drivers accept flush requests
with a bio attached to them or find a workaround in the block layer to
submit it without bio without synchronizing them.

I thin kthat should be the first angle of attack before adding
complexity to filesystems.

