From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable
 	"kernelBUG 	at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 5 Apr 2011 14:44:04 -0500
Message-ID: <26AE8923-4DEA-43FF-8F79-1D5AA665A344@boeing.com>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com><BE4E
 C1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com><20110403020227.GA19963@thunk.o
 rg><15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com><20110405001542.GE2832@
 thunk.org><8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
 <20110405190738.GF2832@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:60744 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1DETod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 15:44:33 -0400
In-Reply-To: <20110405190738.GF2832@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 05, 2011, at 15:07, Ted Ts'o wrote:
> On Tue, Apr 05, 2011 at 10:30:11AM -0500, Moffett, Kyle D wrote:
>> Well, the base image is essentially a somewhat basic Debian "squeeze"
>> for EC2 with our SSH public keys and a couple generic customizations
>> applied.  It does not have Postfix installed or configured, so there
>> would be some work involved.
> 
> Well, if you can share that image in AWS with the ssh keys stripped
> out it would save me a bunch of time.  I assume it's not setup to
> automatically set ssh keys and pass them back to AWS like the generic
> images can?

Well, the generic images just download to ~root/.ssh/authorized_keys
from http://169.254.169.254/meta-data/public-keys/0/openssh-key

They don't really "generate" a keypair themselves, that's just what
AWS does and provides the pubkey via that URL.  The 169.254.169.254 is
just the link-local address for some virtualization infrastructure
software.  These days they even let you upload your own pubkey.

Unfortunately our images don't do that download, although the patched
D-I image does do that when initially setting up the network console.

If you send me an SSH key and AWS account number in private email then
I will cook an updated image and share it out to you.


>> I also didn't see any problems with the system at all until the
>> queue got backed up with ~100-120 stuck emails.  After Postfix tried
>> and failed to deliver a bunch of emails I would get the OOPS.
> 
> Yeah, what I'd probably try to do is install postfix and then send a
> few hundred messages to foobar@example.com and see if I can repro the OOPS.

Not sure if it's related, but the particular SMTP error that was
causing things to back up in the first place was by the remote server
rejecting emails via SMTP errors after a *successful* connection.


> Thanks for investigating!

Thanks for debugging!

Cheers,
Kyle Moffett
