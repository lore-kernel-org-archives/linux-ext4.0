From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 08 Mar 2012 11:36:30 -0500
Message-ID: <yq1pqcnf3sh.fsf@sermon.lab.mkp.net>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
	<4F57FC14.5090207@panasas.com> <yq1zkbrhi2l.fsf@sermon.lab.mkp.net>
	<4F5837A2.8000306@panasas.com>
	<Pine.LNX.4.64.1203072207050.24564@cobra.newdream.net>
	<20120308154326.GA6777@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Sage Weil <sage@newdream.net>, Boaz Harrosh <bharrosh@panasas.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:38610 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025Ab2CHQgi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2012 11:36:38 -0500
In-Reply-To: <20120308154326.GA6777@thunk.org> (Ted Ts'o's message of "Thu, 8
	Mar 2012 10:43:26 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ted" == Ted Ts'o <tytso@mit.edu> writes:

Ted> Martin, would you be willing to try to get your patch submitted for
Ted> the upcoming merge window?  Or I'd be willing to carry your patch
Ted> and then rework Darrick's to use the exported flag, and carry it in
Ted> my tree, maybe that would be better.

There's probably going to be some conflicts due to both topology updates
and the write same changes I have pending. So it's probably best that I
submit this patch as part of my kits for Jens and James. Should go out
today.


Ted> why should we be inflicting pretty severe performance regressions
Ted> for the common case, just to improve things for obscure high-end
Ted> hardware?

I'm perfectly ok with that now that we have established that there are
real world workloads that do suffer with the wait in place.

-- 
Martin K. Petersen	Oracle Linux Engineering
