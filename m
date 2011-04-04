From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable 	"kernel
 BUG 	at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Mon, 4 Apr 2011 09:24:28 -0500
Message-ID: <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com><BE4EC1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com>
 <20110403020227.GA19963@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "615998@bugs.debian.org" <615998@bugs.debian.org>,
	"Livingston, John A" <john.a.livingston@boeing.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:55237 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab1DDPEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Apr 2011 11:04:12 -0400
In-Reply-To: <20110403020227.GA19963@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 02, 2011, at 22:02, Ted Ts'o wrote:
> Sorry for not following up sooner.  Are you still able to reproduce
> this failure?  If I set up an identical Debian stable instance on
> EC-2, am I likely to reproduce it myself?  Do you have a package list
> or EC2 base image I can use as a starting point?

I'll need to check on this.

Unfortunately it was not a trivial process to install Debian "squeeze" onto an EC2 instance; it took a couple ugly Perl scripts, a patched Debian-Installer, and several manual post-install-but-before-reboot steps (like fixing up GRUB 0.99).  One of these days I may get time to update all that to the official "wheezy" release and submit bug reports.

I have an exact image of the failing instance, but it has proprietary data on it and if I stand up an old copy I need to be careful not to actually let it send all the queued emails :-D.

It's probably easier for me to halt email delivery and clone the working instance and try to reproduce from there.  If I recall, the (easily undone) workaround was to remount from "data=journal" to "data=ordered" on a couple filesystems.  It may take a day or two to get this done, though.

If it comes down to it I also have a base image (from "squeeze" as of 9 months ago) that could be made public after updating with new SSH keys.

Thanks again!

Cheers,
Kyle Moffett