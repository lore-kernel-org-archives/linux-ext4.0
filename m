From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Refreshed rootfs.img for kvm-xfstests
Date: Sat, 23 Jul 2016 11:10:26 -0400
Message-ID: <20160723151026.GD26664@thunk.org>
References: <20160717140552.GA11276@thunk.org>
 <20160721202238.GA1514@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48552 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbcGWPKa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Jul 2016 11:10:30 -0400
Content-Disposition: inline
In-Reply-To: <20160721202238.GA1514@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2016 at 04:22:39PM -0400, Eric Whitney wrote:
> I've tested this version of the ARM test appliance using the 4k test config
> on a Pandaboard with a 4.7-rc7 kernel, and have discovered a few problems with
> the file system image as discussed in today's concall (the upshot was that the
> build process might be failing somewhere along the way and producing an
> incomplete image):
> 
> Several files needed to run the appliance are missing from /root - test-env,
> test-conf, /conf (and its contents), and runtests.sh.  Copying them in
> from xfstests-bld solved that.
> 
> /usr/bin/awk points to an executable in Ted's home directory.  Relinking to
> /usr/bin/gawk fixed things up well enough.

The first was caused a bug in how a rsync'ed the source tree to the
armhf build host.  Debian's build systems have a firewall that prevent
git from working correctly, so I have to rsync the source tree up
build host, and this broke the git tree so the automated generation of
the *.ver files broke, which in turn aborted the installation of the
quota tools.

The second problem had to do with how fakechroot (used because I don't
have root on the arm build host) handles symlinks.  Fixed by using the
"symlinks" program rewrite the absolute symlinks to relative symlinks.

I've uploaded an updated armmf_root_fs.tar.gz; please give it a try!

Cheers,

							- Ted
