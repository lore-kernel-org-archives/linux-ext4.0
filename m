From: Theodore Tso <tytso@mit.edu>
Subject: Re: Revert  Fix-EXT_MAX_BLOCK.patch
Date: Thu, 10 Jul 2008 08:22:42 -0400
Message-ID: <20080710122242.GB8603@mit.edu>
References: <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de> <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu> <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de> <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de> <20080710092425.GA16451@skywalker> <20080710092517.GB16451@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34918 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652AbYGJMX3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 08:23:29 -0400
Content-Disposition: inline
In-Reply-To: <20080710092517.GB16451@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh, for the record, how were you able to reproduce the problem?

Do you have Holger's afdbench setup, or did you use some other workload?

Thanks, regards,

						- Ted

On Thu, Jul 10, 2008 at 02:56:35PM +0530, Aneesh Kumar K.V wrote:
> Sending again with different subject.
> 
> On Thu, Jul 10, 2008 at 02:54:25PM +0530, Aneesh Kumar K.V wrote:
> > On Thu, Jul 10, 2008 at 08:11:15AM +0000, Holger Kiehl wrote:
> > > On Mon, 7 Jul 2008, Holger Kiehl wrote:
> > >
> > >
> > > I did try newer patch queue (ext4-patch-queue-a5d48915447f44c3af6ce8e1c91d45b452977fcf)
> > > from today, but I immediatly hit an oops as soon as I untar a file, see below.
> > >
> > 
> > I am able to reproduce this.  Revert the patch Fix-EXT_MAX_BLOCK.patch. 
> > 
> > -aneesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
