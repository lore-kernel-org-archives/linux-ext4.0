From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: Refreshed rootfs.img for kvm-xfstests
Date: Sat, 23 Jul 2016 19:06:34 -0400
Message-ID: <20160723230634.GA3414@localhost.localdomain>
References: <20160717140552.GA11276@thunk.org>
 <20160721202238.GA1514@localhost.localdomain>
 <20160723151026.GD26664@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:34000 "EHLO
	mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcGWXKj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Jul 2016 19:10:39 -0400
Received: by mail-qt0-f174.google.com with SMTP id u25so79933250qtb.1
        for <linux-ext4@vger.kernel.org>; Sat, 23 Jul 2016 16:10:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160723151026.GD26664@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu>:
> On Thu, Jul 21, 2016 at 04:22:39PM -0400, Eric Whitney wrote:
> > I've tested this version of the ARM test appliance using the 4k test config
> > on a Pandaboard with a 4.7-rc7 kernel, and have discovered a few problems with
> > the file system image as discussed in today's concall (the upshot was that the
> > build process might be failing somewhere along the way and producing an
> > incomplete image):
> > 
> > Several files needed to run the appliance are missing from /root - test-env,
> > test-conf, /conf (and its contents), and runtests.sh.  Copying them in
> > from xfstests-bld solved that.
> > 
> > /usr/bin/awk points to an executable in Ted's home directory.  Relinking to
> > /usr/bin/gawk fixed things up well enough.
> 
> The first was caused a bug in how a rsync'ed the source tree to the
> armhf build host.  Debian's build systems have a firewall that prevent
> git from working correctly, so I have to rsync the source tree up
> build host, and this broke the git tree so the automated generation of
> the *.ver files broke, which in turn aborted the installation of the
> quota tools.
> 
> The second problem had to do with how fakechroot (used because I don't
> have root on the arm build host) handles symlinks.  Fixed by using the
> "symlinks" program rewrite the absolute symlinks to relative symlinks.
> 
> I've uploaded an updated armmf_root_fs.tar.gz; please give it a try!
> 
> Cheers,
> 
> 							- Ted

I've tried the image - the awk and quota tools problems are fixed, but the
missing files in root noted above are still missing.  I was able to get a
successful 4k run after copying the missing files into the root directory
from the xfstests-bld tree.  There are a number of test failures that didn't
occur in my test baseline, much as before, but nothing yet obviously caused
by the test appliance itself.

Thanks,
Eric

