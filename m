From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Date: Thu, 20 Jan 2011 20:13:41 +0100
Message-ID: <20110120191341.GB4701@htj.dyndns.org>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
 <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
 <20110113074603.GC27381@tux1.beaverton.ibm.com>
 <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
 <20110115173211.GC27123@htj.dyndns.org>
 <AANLkTi=MiY+GMXRwfOMhEzGQC3=F89FOKAJ4y1hvyDG0@mail.gmail.com>
 <20110120185057.GA4701@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, Jens Axboe <axboe@kernel.dk>,
	Theodore Ts'o <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Shaohua Li <shli@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65343 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1ATTO2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Jan 2011 14:14:28 -0500
Content-Disposition: inline
In-Reply-To: <20110120185057.GA4701@htj.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 20, 2011 at 07:50:57PM +0100, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 18, 2011 at 09:12:55AM +0800, Shaohua Li wrote:
> > This makes sense. would it possible N flush data payloads delay the
> > first request?
> 
> I ended up with a different design.  Still buggy.  It triggers a weird
> oops under stress test but other than that things generally seem to
> work as expected.  Please read the comment at the top of blk-flush.c
> for more info.  I'll post properly after more testing and debugging.

The oops was caused by debugging code I put in (not posted together).
It runs fine without it, so if you have some time, please give it a
spin.

Thanks.

-- 
tejun
