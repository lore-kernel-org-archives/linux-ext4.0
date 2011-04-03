From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG 	at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Sat, 2 Apr 2011 22:02:27 -0400
Message-ID: <20110403020227.GA19963@thunk.org>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com>
 <BE4EC1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "615998@bugs.debian.org" <615998@bugs.debian.org>,
	"Livingston, John A" <john.a.livingston@boeing.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50513 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1DCCCg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Apr 2011 22:02:36 -0400
Content-Disposition: inline
In-Reply-To: <BE4EC1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Kyle,

Sorry for not following up sooner.  Are you still able to reproduce
this failure?  If I set up an identical Debian stable instance on
EC-2, am I likely to reproduce it myself?  Do you have a package list
or EC2 base image I can use as a starting point?

Thanks,

						- Ted
