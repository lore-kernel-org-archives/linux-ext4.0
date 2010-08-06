From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Raid FFSB Benchmark results for 2.6.35-rc5
Date: Fri, 6 Aug 2010 15:14:39 -0400
Message-ID: <20100806191439.GD24583@thunk.org>
References: <1281121633.7357.26.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Keith Mannthey <kmannth@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37937 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965032Ab0HFTOp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 15:14:45 -0400
Content-Disposition: inline
In-Reply-To: <1281121633.7357.26.camel@keith-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 06, 2010 at 12:07:13PM -0700, Keith Mannthey wrote:
> This is a collection of benchmark runs with the FFSB test suite. The
> results are comparable to other raid results on the boxacle server. 
> 
> The latest results can be found at: 
> http://btrfs.boxacle.net/repository/raid/2.6.35-rc5/2.6.35-rc5/2.6.35-rc5.html
> 
> I added XFS without barriers and EXT3 with barriers into the mix since
> my last data set. 

Thanks, it's good to know there haven't been any major regression on
the ext4 side.

If you could have a chance to run a set of benchmark runs with the
jbd2 scalability patches, I'd be hugely interested to see how much
difference they make.

Thanks again!

						- Ted
