From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: What is e2initrd_helper?
Date: Wed, 11 Apr 2012 18:19:05 -0400
Message-ID: <4F860359.8000603@ubuntu.com>
References: <4F85A740.9080906@ubuntu.com> <4F85A965.3040008@redhat.com> <20120411182736.GH12044@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:10932 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478Ab2DKWTH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Apr 2012 18:19:07 -0400
In-Reply-To: <20120411182736.GH12044@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/11/2012 02:27 PM, Ted Ts'o wrote:
> Debian used to have a system where we could transparently update the
> root file system to use ext4 file system features as part of the
> initrd.
> 
> At one point I had hopes that we could fix up the boot scripts so that
> if an initrd was present, we could run e2fsck out of the initrd, so we
> wouldn't have to play games with mounting the file system read-only.
> So at one point the plan was this program would also extract all of
> /etc/fstab for the initrd, and other things that might be useful
> before the root file system was mounted.
> 
> I've since decided that this would involve getting fsck all-too-bound
> up in distribution-specific init systems, and might actually aid and
> abet the further dominance of GNOME-OS (or plymouth/upstart; I dispise
> all of the modern init/initscripts systems equally), so I've since
> stopped trying to implement things in that particular design
> direction.

So does this mean it is now cruft and should be removed at some point?

> It's why I'll be abandoning Ubuntu when the new Ivy Bridge laptops
> become available, and switching not to Fedora, but to Debian Testing
> --- but I'm sure Mark Shuttleworth really doesn't care what distro
> people like me choose to use....   :-)

AFAIK, Ubuntu uses Debian's initramfs system... are you saying this is not the case?  If so, what's the difference?  When I attended the last UDS there was actually a push coming from the arm folks to do away with the initrd on systems that do not require it ( no LVM ) to accelerate boot time by not wasting time loading another file, which apparently is rather slow on the arm boot loader.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPhgNZAAoJEJrBOlT6nu75bGkIALYdwv2542miponYdnt6bX3x
D/rc0oersb7VNe12DV6++Xp2/PWFQRZCdDWDMWUw6gVyE9PYElK6a39MMoKQtBod
RkbWFpI20hG0lkIxNGt55w16+xPMUSD9KRY7MT2R3qXoLd1sKkbummVOdrNJnrT/
WHeK1BpVrXbE6qqlD8DdJtHbBAkCDTz08IKjkEXBMsovmAeIq8PVvG2L9foUCX7o
HDzttaLXdBcQ42/ytWm3xRNJET0Bh/Cmg7TBGBHwkxpylIRgEg5ZgvLNPaWTA5eJ
l6eQsaL18r9Yn8lvDTq5fpxukbAh229NhhzzrcPl82E3P+cBC4AuSUX/W2hQqPc=
=P8AI
-----END PGP SIGNATURE-----
