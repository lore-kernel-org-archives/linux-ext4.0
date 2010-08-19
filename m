From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v3] ext4: Combine barrier requests coming from fsync
Date: Thu, 19 Aug 2010 17:48:39 +0200
Message-ID: <4C6D5257.9040305@kernel.org>
References: <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <20100809210723.GA28171@infradead.org> <20100816161433.GK2109@tux1.beaverton.ibm.com> <20100819020734.GL2109@tux1.beaverton.ibm.com> <20100819085349.GA8782@infradead.org> <4C6CF6BC.3030804@kernel.org>
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
Received: from hera.kernel.org ([140.211.167.34]:50613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0HSPwj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Aug 2010 11:52:39 -0400
In-Reply-To: <4C6CF6BC.3030804@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello, again.

On 08/19/2010 11:17 AM, Tejun Heo wrote:
> What was the configuration?  If dm was involved, both md and dm can
> only process single flush request at a time.  Supporing multiple
> flushes in flight wouldn't be too difficult.  It's just the way things
> are implemented with the previous barrier implementation.  It can
> definitely be improved.

Oh, I just realized that the current bio-based dm implementation
doesn't allow other bio's to be processed if a flush is in progress.
So, it's not about not being able to handle multiple flushes.  The
queue just stalls while flush is in progress and because it also waits
for flush completion by waiting for all commands in progress to
finish.  It basically ends up draining and stalling everything.
Shouldn't be too hard to make it better.

Thanks.

-- 
tejun
