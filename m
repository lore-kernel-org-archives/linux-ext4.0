From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: 	Repeatable "kernel
 BUG 	at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Thu, 23 Jun 2011 13:32:48 -0500
Message-ID: <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com><BE4E
 C1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com><20110403020227.GA19963@thunk.o
 rg><15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com><20110405001542.GE2832@
 thunk.org><8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com><20110405190738.
 GF2832@thunk.org><26AE8923-4DEA-43FF-8F79-1D5AA665A344@boeing.com>
 <20110405230538.GH2832@thunk.org>
 <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:53300 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab1FWTUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 15:20:09 -0400
In-Reply-To: <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello again everyone,

I'm in the middle of doing some software testing on a pre-production
clone of this system using some modified software configurations and a
testing-only data volume, and I've managed to trigger this panic again.

The trigger was exactly the same; I had a bunch of queued emails from
logcheck because my TLS configuration was wrong, then I fixed the TLS
configuration and typed "postqueue -f" to send the queued mail.

Ted, since this new iteration has no customer data, passwords, keys, or
any other private data, I'm going to try to get approval to release an
exact EC2 image of this system for you to test with, including the fake
data volume that I triggered the problem on.

If not I can certainly reproduce it now by stopping email delivery and
generating a lot of fake syslog spam; I can try applying kernel patches
and report what happens.

Hopefully you're still willing to help out tracking down the problem?

Thanks again!

Cheers,
Kyle Moffett
