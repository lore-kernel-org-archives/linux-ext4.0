From: Theodore Tso <tytso@mit.edu>
Subject: Re: Revert  Fix-EXT_MAX_BLOCK.patch
Date: Mon, 14 Jul 2008 16:28:13 -0400
Message-ID: <20080714202813.GC3382@mit.edu>
References: <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu> <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de> <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de> <20080710092425.GA16451@skywalker> <20080710092517.GB16451@skywalker> <Pine.LNX.4.64.0807110947290.31436@diagnostix.dwd.de> <20080711124304.GB8154@mit.edu> <Pine.LNX.4.64.0807141938250.28835@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>,
	linux-ext4@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:36459 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755402AbYGNU2e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 16:28:34 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807141938250.28835@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2008 at 07:55:10PM +0000, Holger Kiehl wrote:
> You are right. I did compare the .config of both and noticed that
> CONFIG_FAIR_GROUP_SCHED was set in the rc9 test but not in rc8 test.
> Doing the test without CONFIG_FAIR_GROUP_SCHED gave me back 6%.
> Sorry.

You may have told us already, but can you tell me the full
configuration of your benchmark machine?  (i.e., how many CPU's, how
much memory, etc.)  Also, what are the current mount options you are
currently using?  And have you redone the ext3 benchmark number with
barriers enabled?  Or was that the original number done with default
mount options that leave barriers disabled?

Thanks!!

						- Ted
