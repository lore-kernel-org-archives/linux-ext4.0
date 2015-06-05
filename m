From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: generic question: user-only directory w/o root access
Date: Fri, 5 Jun 2015 10:14:29 -0400
Message-ID: <20150605141429.GA26550@thunk.org>
References: <mkfbkb$fo1$1@ger.gmane.org>
 <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org>
 <20150604014452.GA5759@thunk.org>
 <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
 <mkpjhm$7i5$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49527 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422697AbbFEOOf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2015 10:14:35 -0400
Content-Disposition: inline
In-Reply-To: <mkpjhm$7i5$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 04, 2015 at 03:24:06PM +0200, U.Mutlu wrote:
> I use a truecrypt container with ext2 on it and now use the mentioned
> private namespace-mount, because only that single application (running
> under its own user account) shall have access to the mountpoint,
> root by default has no access to it, and yes as you both pointed out
> root can overcome this, but then he would need to restart the machine.
> But then he cannot mount the encrypted volume :-) [not using any automount],
> so, imo that solution looks to me rock solid, and that was what I was
> looking for when I started the thread here.

I wouldn't count out a sufficiently clever root user.  At the very
minimum, root could replace the kernel and wait for the system to
reboot under normal circumstances.  The root user could load a kernel
module (or replace an existing kernel module) that gives him access to
*any* namespace, or extract *any* key, or read from *any* userspace
process.

If there are any shared files used by both the container and rest of
the system (i.e., if the container only contains the data files and
uses /usr/bin and /bin and /lib from the rest of the system), then
root could replace one of these executables or shared libaries which
would then used by the container.  If you are using kvm in the
"secure" container, root could insert mailware into the kvm binary.

If you are using a secure boot system (i.e., using UEFI bios with your
own firmware public/private key pair), and then use a kernel signed by
your BIOS key, and then use signed modules, and then use SELinux to
try to add more fences to prevent unauthorized changes to binaries,
you can make things more secure.

But your original statement talked about trying to protect against all
root users, and that's what was so concerning.  Listing all of the
authorized users may very well be a very large list.  Consider that on
a Debian system, this includes all of the people authorized to upload
packages to the debian-security repository (or the equivalent for
Fedora, SuSE, etc.)

This is why a lot of people who hear words like "rock solid" will
start assuming that the speaker either doesn't know what he or she is
talking about, and/or is a snake oil salesperson.  :-)

Regards,

						- Ted
