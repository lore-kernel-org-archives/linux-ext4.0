From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Running XFS tests on qemu
Date: Fri, 23 Oct 2015 05:34:28 -0400
Message-ID: <20151023093428.GA7917@thunk.org>
References: <55F8A71A.3030001@codeaurora.org>
 <20150920034248.GB2909@thunk.org>
 <5629D4CE.2070400@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39825 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbbJWJeb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Oct 2015 05:34:31 -0400
Content-Disposition: inline
In-Reply-To: <5629D4CE.2070400@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 22, 2015 at 11:33:50PM -0700, Nikhilesh Reddy wrote:
> Hi Ted
> 
> Can you please help point me to instructions to setup and run xfs tests for
> ext4 to run on a local qemu installation from scratch?

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/quick-start?h=META

I haven't tried to make this work for qemu for arm (which I assume
you'd be more interested in), but if you do, please let me know.  Also
note that I *do* have changes to build xfstests for android / bionic.
The build infrastructure is in the xfstests-bld git tree; however,
some of the changes to xfstests and xfsprogs haven't been accepted
upstream yet, but let me know if you are interested and I'll get you
the patches that haven't yet been accepted.

What's missing is the automation to talk to an Android device; I
ultimately fixed the bug I was chasing via other means.
(Unfortunately the USB-C device that was supposedly able to power a
Macbook Pro as well as connecting to a USB-attached SSD didn't work
against a Nexus 5X, and so I never finished getting xfstests running
on Android, although 95% of the work should be done.).

The two other missing pieces was getting upstream fio working on
Android/bionic (although there is a fio is the AOSP tree which should
work), and IIRC there were one or two fixup patches that I needed
against the bleeding-edge tip of coreutils so it would work with the
latest Android NDK.  They were pretty obvious, but if you want I can
dig up the changes from my tree.

Finally, if you are doing x86-based development, you might be
interested in using Google Compute Engine to run your tests.  I do
must of my testinng on GCE these days, beacuse it's much faster and I
can run multiple tests in parallel.

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/README.GCE

Cheers,

						- Ted
