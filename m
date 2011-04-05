From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG 	at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Mon, 4 Apr 2011 20:15:42 -0400
Message-ID: <20110405001542.GE2832@thunk.org>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com>
 <BE4EC1DF-4DFC-4B94-923D-0197B16BD7B4@boeing.com>
 <20110403020227.GA19963@thunk.org>
 <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "615998@bugs.debian.org" <615998@bugs.debian.org>,
	"Livingston, John A" <john.a.livingston@boeing.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43383 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab1DEAPs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Apr 2011 20:15:48 -0400
Content-Disposition: inline
In-Reply-To: <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 04, 2011 at 09:24:28AM -0500, Moffett, Kyle D wrote:
> 
> Unfortunately it was not a trivial process to install Debian
> "squeeze" onto an EC2 instance; it took a couple ugly Perl scripts,
> a patched Debian-Installer, and several manual
> post-install-but-before-reboot steps (like fixing up GRUB 0.99).
> One of these days I may get time to update all that to the official
> "wheezy" release and submit bug reports.

Sigh, I was whoping someone was maintaining semi-official EC2 images
for Debian, much like alestic has been maintaining for Ubuntu.  (Hmm,
actually, he has EC2 images for Lenny and Etch, but unfortunately not
for squeeze.  Sigh....)

> It's probably easier for me to halt email delivery and clone the
> working instance and try to reproduce from there.  If I recall, the
> (easily undone) workaround was to remount from "data=journal" to
> "data=ordered" on a couple filesystems.  It may take a day or two to
> get this done, though.

Couple of questions which might give me some clues: (a) was this a
natively formatted ext4 file system, or a ext3 file system which was
later converted to ext4?  (b) How big are the files/directories
involved?  In particular, how big is the Postfix mail queue directory,
and it is an extent-based directory?  (what does lsattr on the mail
queue directory report) As far as file sizes, does it matter how big
the e-mail messages are, and are there any other database files that
postgress might be touching at the time that you get the OOPS?

I have found a bug in ext4 where we were underestimating how many
journal credits were needed when modifying direct/indirect-mapped
files (which would be seen on ext4 if you had a ext3 file system that
was converted to start using extents; but old, pre-existing
directories wouldn't be converted), which is why I'm asking the
question about whether this was an ext2/ext3 file system which was
converted to use ext4.

I have a patch to fix it, but backporting it into a kernel which will
work with EC2 is not something I've done before.  Can anyone point me
at a web page that gives me the quick cheat sheet?

> If it comes down to it I also have a base image (from "squeeze" as of 9 months ago) that could be made public after updating with new SSH keys. 

If we can reproduce the problem on that base image it would be really
great!  I have an Amazon AWS account; contact me when you have an
image you want to share, if you want to share it just with my AWS
account id, instead of sharing it publically...

      	  	    		   	   	 - Ted
