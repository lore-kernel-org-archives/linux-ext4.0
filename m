From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: found an error that e2fsck does not fix
Date: Sat, 28 Nov 2015 07:27:47 -0500
Message-ID: <20151128122747.GA2836@thunk.org>
References: <alpine.DEB.2.10.1511272003250.1707@suiko.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bo Branten <bosse@acc.umu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55364 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbbK1M1x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Nov 2015 07:27:53 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1511272003250.1707@suiko.acc.umu.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 27, 2015 at 08:11:34PM +0100, Bo Branten wrote:
> 
> I am debugging an Windows driver for ext4 and when creating an zero length
> file the error below shows up on Linux, while this ofcause is an bug in the
> Windows driver (looks like it forgets to flush some metadata) I wanted to
> report here that every time I run fsck on this test volume it will mark it
> as clean again but without fixing the error, so if I mount and unmount the
> filesystem again it is again in need of fsck wich in turn will mark it clean
> witout fixing the problem.
> 
> Test case, testa and testb is created from Windows and only testb gets one
> character written to with notepad:

This test case doesn't really help since I don't have access to your
potentially buggy Windows driver for ext4.

What would be helpful:

(a) the output of "e2fsck -fy /dev/sdXX" run twice.  If e2fsck isn't
fixing a problem, then a forced check should show it trying to fix the
problem again.  Also the exact output of what e2fsck prints would be
heplful.  It's possible that mounting and unmounting the file system
using the Windows driver is causing the problem, so running "e2fsck
-fy" twice in succeession will determine whether or not this is the
case.  In general, "e2fsck -fy" should fix all corruptions in a single
run.  So a second run of "e2fsck -fy", if it shows errors, is an
indication of either (a) a hardware problem (e.g., so an update of the
file system image is getting lost or the disk image is geting
changed/corrupted between runs of e2fsck), or (b) a bug in e2fsck.

(b) See the REPORTING BUGS section of the e2fsck man page; in
particular, note its suggestion to use e2image.  The e2image man page
will have more details, but the short version is to send me the output
of "e2image -r /dev/sdXX - | bzip2 > sdXX.e2i.bz2".

If you can reproduce the problem on an arbitrary file system, create a
small test file system "mke2fs -b 4096 /dev/sdXX 1M" and then either
use the e2image directions described above to send me a minimal test
case.

Thanks,

					- Ted

