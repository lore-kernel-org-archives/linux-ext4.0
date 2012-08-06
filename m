From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: Mon, 6 Aug 2012 19:25:12 -0400
Message-ID: <20120806232512.GE30677@thunk.org>
References: <20120806221207.GA30677@thunk.org>
 <20120806225937.17241.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43355 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab2HFXZV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Aug 2012 19:25:21 -0400
Content-Disposition: inline
In-Reply-To: <20120806225937.17241.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 06, 2012 at 06:59:37PM -0400, George Spelvin wrote:
> dpkg-buildpackage: error: debian/rules build gave error exit status 2
> debuild: fatal error at line 1350:
> dpkg-buildpackage -rfakeroot -d -us -uc -b -ai386 failed

I don't think -ai386 will work for e2fsprogs since we need external
libraries; specifically, libblkid-dev and libuuid-dev and the dev
packages aren't multiarch compatible.  (In fact, I'm not sure -ai386
to build 32-bit packages in an x86 environment will work in general.
It's certainly not the standard way 32-bit packages are built.)

The failures you're seeing is because "pkg-config --libs blkid" is
returning a null string when run in the dpkg-buildpackage -ai386
environment --- which is not surprising, since we don't have a -32/-64
bit link libraries in libblkid-dev.

So if you want to build a 32-bit set of packages of e2fsprogs, you'll
need to make a 32-bit build environment as a chroot, using debootstrap
and build e2fsprogs in the 32-bit chroot.

That's actually how I build my packages for Debian, BTW --- I have a
32-bit chroot, and I build the binary packages for i386 and upload
them from there.  I let the autobuilders build the 64-bit binary
packages from the source upload.  That way, the most commonly used
binary packages are built in a standard autobuilder environment, and
are not subject to the vagracies of my build environment.  It also
means that I don't have to worry about the build scripts bitrot for
the 32-bit packages.  (I also build 64-bit debs for my own use --- but
I don't upload them.)

Regards,

	   	      	     	      	 - Ted
