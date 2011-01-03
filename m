From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: ext4: Fix 32bit overflow in ext4_ext_find_goal()
Date: Mon, 3 Jan 2011 16:36:17 +0100
Message-ID: <20110103153617.GA21618@bitwizard.nl>
References: <4D05B132.3060402@sx.jp.nec.com> <20110102214031.GA10889@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, ext4 <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:46983 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755343Ab1ACPgU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jan 2011 10:36:20 -0500
Content-Disposition: inline
In-Reply-To: <20110102214031.GA10889@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 02, 2011 at 04:40:31PM -0500, Ted Ts'o wrote:
> On Sun, Dec 12, 2010 at 07:37:54PM -0000, Kazuya Mio wrote:
> > Hi,
> > 
> > ext4_ext_find_goal() returns an ideal physical block number that the block
> > allocator tries to allocate first. However, if a required file offset is
> > smaller than the existing extent's one, ext4_ext_find_goal() returns
> > a wrong block number because it may overflow at
> > "block - le32_to_cpu(ex->ee_block)". This patch fixes the problem.
> 
> Thanks, applied.  One comment which I've added to the code:
> 
> The block placement algorithm in this section of code assumes that we
> are filling in a file which will eventually be non-sparse --- i.e., in
> the case of libbfd writing an ELF object sections out-of-order but in
> a way the eventually results in a contiguous object or executable
> file, or the old BSD dbm library writing dbm files.  However, this is
> actually somewhat non-ideal if we are writing a sparse file such as
> qemu or KVM writing a raw image file, as it will result in the free
> space getting unnecessarily fragmented.  Maybe we should have some
> heuristics to determine whether we are in the first or second case?

Heuristics are good, if they can be made to work. 

Otherwise adding an attribute to a file that can be set using an IOCTL
can be used. Now of course you don't want to be changing all your
posix apps to start calling that filesystem specific ioctl..... 

But how about: it's a little flag on a directory. So you can tag a
directory as "files will be sparse" or "files will fill in
eventually". All files created below a directory will inherit the
flag.

> I don't currently think using raw image files is that common in most
> virtualization application, but if someone can think of some common

I do datarecovery. Instead of writing one big 500Gb file, we still use
500 files of 1Gb each, dating from the time when Linux didn't really
support files > 2Gb that well.

Anyway, sometimes we read the disk "out of order", so we'll write the
image files out-of-order. 

The difficult part is that the drives we're mirroring will contain
patches of zeroes. Those won't get written anytime.

Sometimes we don't manage to recover a lot of the patient drive. So
then the images will remain mostly empty. Other times we first recover
all the sectors that contain files, and only then recover the
remaining sectors.

So I'm not sure which strategy would benefit us most....

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
