From: Theodore Tso <tytso@mit.edu>
Subject: Re: Revert  Fix-EXT_MAX_BLOCK.patch
Date: Thu, 10 Jul 2008 09:02:20 -0400
Message-ID: <20080710130220.GF8603@mit.edu>
References: <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu> <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de> <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de> <20080710092425.GA16451@skywalker> <20080710092517.GB16451@skywalker> <20080710122242.GB8603@mit.edu> <20080710123803.GC16451@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>,
	linux-ext4@vger.kernel.org, Gary Hawco <ghawco@cox.net>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47521 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754065AbYGJNC0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 09:02:26 -0400
Content-Disposition: inline
In-Reply-To: <20080710123803.GC16451@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 10, 2008 at 06:08:03PM +0530, Aneesh Kumar K.V wrote:
> On Thu, Jul 10, 2008 at 08:22:42AM -0400, Theodore Tso wrote:
> > Aneesh, for the record, how were you able to reproduce the problem?
> > 
> > Do you have Holger's afdbench setup, or did you use some other workload?
> > 
> 
> cp -ax /usr . 
> 
> that will cause the BUG

Hmm, I wasn't able to trigger it so easily, at least, while trying to
replicate Gary Hawco's, bug.  (Which also had Fix-EXT_MAX_BLOCK
applied.)  I wonder if he wasn't able to trigger it while doing the
partial rollback, and so ext4-fix-mb_find_next_bit-return.patch was
unfairly blamed for the BUG.

In any case, both patches have been pulled out of the patch series ,
and I'll release a new patchset until we can figure out what happened.

(Gary, this is why its important to get the kernel BUG/oops message;
it helps us correlate your bug reports with others.)

						- Ted
