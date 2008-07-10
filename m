From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Revert  Fix-EXT_MAX_BLOCK.patch
Date: Thu, 10 Jul 2008 14:56:35 +0530
Message-ID: <20080710092517.GB16451@skywalker>
References: <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de> <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de> <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu> <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de> <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de> <20080710092425.GA16451@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:32912 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752315AbYGJJ1M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 05:27:12 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6A9QhT2027725
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 14:56:43 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6A9QLlo835616
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 14:56:21 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6A9QgAm011751
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 14:56:43 +0530
Content-Disposition: inline
In-Reply-To: <20080710092425.GA16451@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sending again with different subject.

On Thu, Jul 10, 2008 at 02:54:25PM +0530, Aneesh Kumar K.V wrote:
> On Thu, Jul 10, 2008 at 08:11:15AM +0000, Holger Kiehl wrote:
> > On Mon, 7 Jul 2008, Holger Kiehl wrote:
> >
> >
> > I did try newer patch queue (ext4-patch-queue-a5d48915447f44c3af6ce8e1c91d45b452977fcf)
> > from today, but I immediatly hit an oops as soon as I untar a file, see below.
> >
> 
> I am able to reproduce this.  Revert the patch Fix-EXT_MAX_BLOCK.patch. 
> 
> -aneesh
