From: Ted Ts'o <tytso@mit.edu>
Subject: Re: What is e2initrd_helper?
Date: Wed, 11 Apr 2012 14:27:36 -0400
Message-ID: <20120411182736.GH12044@thunk.org>
References: <4F85A740.9080906@ubuntu.com>
 <4F85A965.3040008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45921 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab2DKS1l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 14:27:41 -0400
Content-Disposition: inline
In-Reply-To: <4F85A965.3040008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 11, 2012 at 10:55:17AM -0500, Eric Sandeen wrote:
> On 4/11/12 10:46 AM, Phillip Susi wrote:
> > I came across this program in e2fsprogs and it doesn't seem to have a
> > man page.  What is its purpose?  Looking at the code, it appears to
> > extract the fs type listed in the /etc/fstab of the root fs before it
> > is mounted, but why?
> 
> +2004-09-18  Theodore Ts'o  <tytso@mit.edu>
> +
> +       * e2initrd_helper.c: New program which allows initrd scripts to
> +               check on the contents of /etc/fstab without (a) needing to
> +               mount the root filesystem, and (b) needing /bin/awk in the
> +               initrd environment.  (Addresses Debian Bug #247775)
> +

Debian used to have a system where we could transparently update the
root file system to use ext4 file system features as part of the
initrd.

At one point I had hopes that we could fix up the boot scripts so that
if an initrd was present, we could run e2fsck out of the initrd, so we
wouldn't have to play games with mounting the file system read-only.
So at one point the plan was this program would also extract all of
/etc/fstab for the initrd, and other things that might be useful
before the root file system was mounted.

I've since decided that this would involve getting fsck all-too-bound
up in distribution-specific init systems, and might actually aid and
abet the further dominance of GNOME-OS (or plymouth/upstart; I dispise
all of the modern init/initscripts systems equally), so I've since
stopped trying to implement things in that particular design
direction.

It's why I'll be abandoning Ubuntu when the new Ivy Bridge laptops
become available, and switching not to Fedora, but to Debian Testing
--- but I'm sure Mark Shuttleworth really doesn't care what distro
people like me choose to use....   :-)

						- Ted
