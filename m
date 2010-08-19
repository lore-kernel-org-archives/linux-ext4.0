From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC v3] ext4: Combine barrier requests coming from fsync
Date: Wed, 18 Aug 2010 19:07:34 -0700
Message-ID: <20100819020734.GL2109@tux1.beaverton.ibm.com>
References: <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <20100809210723.GA28171@infradead.org> <20100816161433.GK2109@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:38899 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0HSCHh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Aug 2010 22:07:37 -0400
Content-Disposition: inline
In-Reply-To: <20100816161433.GK2109@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 16, 2010 at 09:14:33AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 09, 2010 at 05:07:23PM -0400, Christoph Hellwig wrote:
> > Can you try with the new barrier implementation in the
> > 
> > 	[PATCH, RFC] relaxed barriers
> > 
> > by making cache flushes just that and not complicated drain barrier
> > it should speed this case up a lot.
> 
> Indeed it does!  The barrier count increases to about 21000, but I also see
> much higher throughput, about 830 transactions per second (versus 12000 and 760
> respectively before Tejun's patch).

Oddly, I ran the entire suite of tests against a larger set of machines, and
with Tejun's RFC patchset I didn't see nearly as much of an improvement.  I
have been trying to put together a new tree based on "replace barrier with
sequenced flush" and Christoph's "explicitly flush/FUA" patch sets, though I've
gotten lost in the weeds. :(

I also experienced some sort of crash with Tejun's relaxed barrier patch on one
of my systems.  I was hitting the BUG_ON in drivers/scsi/scsi_lib.c, line 1115.

Rather than hold on to (aging) test results any further, I'll be posting a new
fsync coordination patch shortly that includes Andreas' suggestion to use the
average barrier time instead of a static 500us, and a spreadsheet that shows
what happens with various patches, and on a wider range of hardware.

--D
