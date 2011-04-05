From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG 	at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 5 Apr 2011 15:07:38 -0400
Message-ID: <20110405190738.GF2832@thunk.org>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com>
 <BE4EC1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com>
 <20110403020227.GA19963@thunk.org>
 <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
 <20110405001542.GE2832@thunk.org>
 <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56375 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab1DETHr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Apr 2011 15:07:47 -0400
Content-Disposition: inline
In-Reply-To: <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 05, 2011 at 10:30:11AM -0500, Moffett, Kyle D wrote:
> > Couple of questions which might give me some clues:
> >   (a) was this a natively formatted ext4 file system, or a ext3 file
> >       system which was later converted to ext4?
> 
> All the filesystems were formatted like this using Debian e2fstools
> as of 9 months ago:

Rats.  OK, so the indirect block journal credit bug fix won't help
this bug.

>   mke2fs -t ext4 -E lazy_itable_init=1 -L db:mail /dev/mapper/db-mail
>   tune2fs -i 0 -c 1 -e remount-ro -o acl,user_xattr,journal_data /dev/mapper/db-mail
> 
> Ooooh.... could the lazy_itable_init have anything to do with it?

Shouldn't be, since 2.6.32 doesn't have the lazy inode init support.
That support didn't show up until 2.6.37.

> I've switched the relevant filesystems back to data=journal mode,
> so if you want to send me a patch for 2.6.32 that I can apply to a
> Debian kernel I will keep that kernel around and if I see it happen
> again I'll check if the patch fixes it.

Given that this was a freshly created file system with mke2fs -t ext4,
I doubt the patch would help.

> Well, the base image is essentially a somewhat basic Debian "squeeze"
> for EC2 with our SSH public keys and a couple generic customizations
> applied.  It does not have Postfix installed or configured, so there
> would be some work involved.

Well, if you can share that image in AWS with the ssh keys stripped
out it would save me a bunch of time.  I assume it's not setup to
automatically set ssh keys and pass them back to AWS like the generic
images can?

> I also didn't see any problems with the system at all until the
> queue got backed up with ~100-120 stuck emails.  After Postfix tried
> and failed to deliver a bunch of emails I would get the OOPS.

Yeah, what I'd probably try to do is install postfix and then send a
few hundred messages to foobar@example.com and see if I can repro the OOPS.

Thanks for investigating!

						- Ted
