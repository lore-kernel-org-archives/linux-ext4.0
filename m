From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC v3] ext4: Combine barrier requests coming from fsync
Date: Mon, 16 Aug 2010 09:14:33 -0700
Message-ID: <20100816161433.GK2109@tux1.beaverton.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <20100809210723.GA28171@infradead.org>
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
Received: from e36.co.us.ibm.com ([32.97.110.154]:43423 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab0HPQPE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Aug 2010 12:15:04 -0400
Content-Disposition: inline
In-Reply-To: <20100809210723.GA28171@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 09, 2010 at 05:07:23PM -0400, Christoph Hellwig wrote:
> Can you try with the new barrier implementation in the
> 
> 	[PATCH, RFC] relaxed barriers
> 
> by making cache flushes just that and not complicated drain barrier
> it should speed this case up a lot.

Indeed it does!  The barrier count increases to about 21000, but I also see
much higher throughput, about 830 transactions per second (versus 12000 and 760
respectively before Tejun's patch).

--D
