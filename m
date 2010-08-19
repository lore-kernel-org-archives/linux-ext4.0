From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC v3] ext4: Combine barrier requests coming from fsync
Date: Thu, 19 Aug 2010 04:53:49 -0400
Message-ID: <20100819085349.GA8782@infradead.org>
References: <4BE02C45.6010608@redhat.com>
 <1273002566.3755.10.camel@mingming-laptop>
 <20100629205102.GM15515@tux1.beaverton.ibm.com>
 <20100805164008.GH2901@thunk.org>
 <20100805164504.GI2901@thunk.org>
 <20100806070424.GD2109@tux1.beaverton.ibm.com>
 <20100809195324.GG2109@tux1.beaverton.ibm.com>
 <20100809210723.GA28171@infradead.org>
 <20100816161433.GK2109@tux1.beaverton.ibm.com>
 <20100819020734.GL2109@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, Ted Ts'o <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0HSIxw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Aug 2010 04:53:52 -0400
Content-Disposition: inline
In-Reply-To: <20100819020734.GL2109@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 18, 2010 at 07:07:34PM -0700, Darrick J. Wong wrote:
> Oddly, I ran the entire suite of tests against a larger set of machines, and
> with Tejun's RFC patchset I didn't see nearly as much of an improvement.  I
> have been trying to put together a new tree based on "replace barrier with
> sequenced flush" and Christoph's "explicitly flush/FUA" patch sets, though I've
> gotten lost in the weeds. :(

Tejun's patches don't allow concurrent cache flushes to happen, while
my patch did.  Tejun said there are drivers that can't handly empty
flushes with a bio attached, making this nessecary.   

Tejun, any idea what drivers that would be?

> I also experienced some sort of crash with Tejun's relaxed barrier patch on one
> of my systems.  I was hitting the BUG_ON in drivers/scsi/scsi_lib.c, line 1115.

My kernel source doesn't have a BUG_ON line there, but only one two
lines above.  A req->nr_phys_segments that's zero sounds a bit like
empty flush requests, I'll need to look into it again.

