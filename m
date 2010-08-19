From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v3] ext4: Combine barrier requests coming from fsync
Date: Thu, 19 Aug 2010 11:17:48 +0200
Message-ID: <4C6CF6BC.3030804@kernel.org>
References: <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <20100809210723.GA28171@infradead.org> <20100816161433.GK2109@tux1.beaverton.ibm.com> <20100819020734.GL2109@tux1.beaverton.ibm.com> <20100819085349.GA8782@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, "Ted Ts'o" <tytso@mit.edu>,
	Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:41567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab0HSJVp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Aug 2010 05:21:45 -0400
In-Reply-To: <20100819085349.GA8782@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On 08/19/2010 10:53 AM, Christoph Hellwig wrote:
> On Wed, Aug 18, 2010 at 07:07:34PM -0700, Darrick J. Wong wrote:
>> Oddly, I ran the entire suite of tests against a larger set of machines, and
>> with Tejun's RFC patchset I didn't see nearly as much of an improvement.  I
>> have been trying to put together a new tree based on "replace barrier with
>> sequenced flush" and Christoph's "explicitly flush/FUA" patch sets, though I've
>> gotten lost in the weeds. :(
> 
> Tejun's patches don't allow concurrent cache flushes to happen, while
> my patch did.  Tejun said there are drivers that can't handly empty
> flushes with a bio attached, making this nessecary.   
> 
> Tejun, any idea what drivers that would be?

What was the configuration?  If dm was involved, both md and dm can
only process single flush request at a time.  Supporing multiple
flushes in flight wouldn't be too difficult.  It's just the way things
are implemented with the previous barrier implementation.  It can
definitely be improved.

>> I also experienced some sort of crash with Tejun's relaxed barrier
>> patch on one of my systems.  I was hitting the BUG_ON in
>> drivers/scsi/scsi_lib.c, line 1115.
> 
> My kernel source doesn't have a BUG_ON line there, but only one two
> lines above.  A req->nr_phys_segments that's zero sounds a bit like
> empty flush requests, I'll need to look into it again.

Yeah, definitely sounds like REQ_FS|REQ_FLUSH request causing problem.
Can you post the kernel log?

Thanks.

-- 
tejun
