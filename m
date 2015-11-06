From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 encryption backporting
Date: Fri, 6 Nov 2015 11:50:41 -0500
Message-ID: <20151106165041.GD6160@thunk.org>
References: <CACE9dm_y-z_xvMr5ub1rho819sE2NbzcLDMi7Cwbf+hHgVj84A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46145 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391AbbKFQun (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2015 11:50:43 -0500
Content-Disposition: inline
In-Reply-To: <CACE9dm_y-z_xvMr5ub1rho819sE2NbzcLDMi7Cwbf+hHgVj84A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 06, 2015 at 09:40:18AM +0200, Dmitry Kasatkin wrote:
> 
> Can anyone roughly to tell is it a big effort to backport Ext4
> encryption to 3.10 kernel?

Well, it takes me about a full day of work time per device kernel that
I need to backport to.  But then again, I've done this a number of
times and I know the code fairly well.  And running the tests take a
couple of hours, so "a day" is work time, not calendar time.  For
someone who is doing it for the first time, I'd estimate roughly
calendar week or so, plus or minus.


The general technique is to transplant the ext4 code from 3.18 to
3.10.  An example for doing this can be found on the backport-3.10
branch, which does this using a stock 3.10 tree:

https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/log/?h=backport-to-3.10

If you are doing this on a 3.10 SOC or device kernel, some of these
patches may not apply --- especially if you are using a device kernel
such as the one for the Nexus 9 that had f2fs backported into it,
since some of the vfs changes for the f2fs backport were already done.
What I tend to do is to copy fs/ext4/*, fs/jbd2/*,
include/linux/jbd_common.h, and include/trace/events/{ext4,jbd2}.h.
See the first commit on the backport-to-3.10 tree for an example of
how to do this.

If you are doing this on a pre-existing Android device kernel, there
may be one or two Android-specific commits that will get overwritten
that you will need to preserve and bring forward.  So take a quick
look and see if you see any such patches before you do the
copy-and-overwrite.  Once you've done that, the rest of the commits on
the backport-to-3.10 are needed to get the tree building and working
again.  I keep them broken out because it's easier when dealing with
random device kernels that might have things like f2fs backports.

Once you have done this, my advice is to build on x86 (and if you are
using a msm or nvidia kernel, Qualcomm and AMD thoughtly broke the
kernel to build on x86, so you may need to do some more work to fix up
the kernel so it builds and compiles on x86).  Use the kernel config
from arch/x86/configs/i386_qemu_defconfig from the 3.10 android-common
kernel.  (If that doesn't exist on the latest 3.10 android-common
branch, use the i386_defconfig file instead.)  Then use kvm-xfstests
to do a regression test to make sure you have a working 3.18-ish ext4
transplanted on your 3.10 kernel.


Now you can apply the ext4 crypto commits on top of 3.18-ish ext4
code.  The upstream ext4 crypto patches were applied on top of 4.0,
but there is a version of the base crypto patches available on top of
3.18 here which will be a little easier for you to use:

https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/log/?h=crypto

Finally, you will need to apply the ext4 crypto bug fixes up to the
4.4-rcX kernel.  This includes the patches that I just sent to Linus
this morning, which is on the ext4_for_linus tag on the ext4.git tree.

Once you have all of this, you can try running "kvm-xfstests -c
encrypt -g auto".  There are a few failures that I haven't marked as
known failures, and there will be some failures because you are using
a 3.10 kernel and not all of the ext4 bug fixes was backported to
3.10.  (Especially the SOC or device kernels which tend not to have
all of the 3.10.y LTS patches merged into them.)  But the key is that
it should not crash, and if you see any reports that the file system
has been corrupted --- that shouldn't happen.  If it does, drop me a
note and send me the full log and the results directory in the VM
image, and I'll take a quick look at it.

    	    	     	     	 - Ted

P.S.  For more information about kvm-xfstests, please see:

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/plain/quick-start?h=META

P.P.S.  If you aren't in a super hurry, eventually I'll try to get the
crypto branch on the ext4.git tree updated to include all of the bug
fixes.  But I have a lot of other work on my plate at the moment.
