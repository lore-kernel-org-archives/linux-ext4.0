From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Refreshed rootfs.img for kvm-xfstests
Date: Fri, 1 Jul 2016 11:54:16 -0400
Message-ID: <20160701155416.GB11237@thunk.org>
References: <20160630152816.GA2784@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36482 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbcGAPyR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jul 2016 11:54:17 -0400
Content-Disposition: inline
In-Reply-To: <20160630152816.GA2784@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 30, 2016 at 11:28:16AM -0400, Theodore Ts'o wrote:
> 
> Finally, it is now possible to build tar.gz file with all of the
> xfstests-bld test runner infrastructure using "./gen-image
> --out-tar=rootfs.tar.gz".  This can be used for those people who want
> to run xfstests on bare hardware without using KVM.  This also allows
> xfstests-bld to be built on a Debian armhf build server, and then
> create a tar.gz file that can be used to run a chroot environment on
> an Android device.

As I promised on the weekly ext4 conference call, I've made an
alpha-test release of these bits, which are available here:

https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/testing/

See the README.android for more details....

						- Ted
