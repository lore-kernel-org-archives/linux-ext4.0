From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Revert  Fix-EXT_MAX_BLOCK.patch
Date: Thu, 10 Jul 2008 18:08:03 +0530
Message-ID: <20080710123803.GC16451@skywalker>
References: <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu> <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de> <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de> <20080710092425.GA16451@skywalker> <20080710092517.GB16451@skywalker> <20080710122242.GB8603@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:33789 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbYGJMiP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 08:38:15 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6ACbV7d000760
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 22:37:31 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6ACcDLQ150902
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 22:38:13 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6ACcCvd019411
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 22:38:13 +1000
Content-Disposition: inline
In-Reply-To: <20080710122242.GB8603@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 10, 2008 at 08:22:42AM -0400, Theodore Tso wrote:
> Aneesh, for the record, how were you able to reproduce the problem?
> 
> Do you have Holger's afdbench setup, or did you use some other workload?
> 

cp -ax /usr . 

that will cause the BUG

-aneesh
