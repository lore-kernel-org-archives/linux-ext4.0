From: Greg KH <greg@kroah.com>
Subject: Re: Open bugs found by fuzzing as of 2016-07-30
Date: Wed, 3 Aug 2016 07:43:59 +0200
Message-ID: <20160803054359.GB6711@kroah.com>
References: <579CA5EB.1070707@oracle.com>
 <09df1f58-ed4c-6887-e112-bbc68d9ec1d6@gmail.com>
 <579CFF1B.40201@oracle.com>
 <20160731043727.GB12853@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
	nborisov <n.borisov.lkml@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51158 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932068AbcHCGVh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2016 02:21:37 -0400
Content-Disposition: inline
In-Reply-To: <20160731043727.GB12853@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 31, 2016 at 12:37:27AM -0400, Theodore Ts'o wrote:
> On Sat, Jul 30, 2016 at 09:25:15PM +0200, Vegard Nossum wrote:
> > 
> > It seems that most of them are indeed tagged for stable; for the patches
> > I submitted or reported for, it looks like the only one without a stable
> > tag is a warning about large memory allocations -- commit
> > 7bc9491645118c9461bd21099c31755ff6783593.
> 
> ... and that's an oversight.  Commit 7bc949164511 ("ext4: verify
> extent header depth") should have been marked for stable.  I've added
> stable@vger.kernel.org to the cc.  Could you please it to the stable
> kernels?  Many thanks!!

Now queued up, thanks.

greg k-h
