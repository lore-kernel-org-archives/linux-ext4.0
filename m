From: Theodore Ts'o <tytso@mit.edu>
Subject: Refreshed rootfs.img for kvm-xfstests
Date: Thu, 30 Jun 2016 11:28:16 -0400
Message-ID: <20160630152816.GA2784@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39924 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbcF3P2V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2016 11:28:21 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is an updated rootfs.img file available at:

    https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

It includes the latest updates from the xfstests-dev upstream.  This
image also includes the dbench binary which enables generic/241.
There is also support for testing the virtio-rng kernel driver (not
for file system testing).

The gce-xfstests driver has been updated to support the latest gcloud
SDK and Debian releases.  For more information about this test
framework, please see:

    http://thunk.org/gce-xfstests

Finally, it is now possible to build tar.gz file with all of the
xfstests-bld test runner infrastructure using "./gen-image
--out-tar=rootfs.tar.gz".  This can be used for those people who want
to run xfstests on bare hardware without using KVM.  This also allows
xfstests-bld to be built on a Debian armhf build server, and then
create a tar.gz file that can be used to run a chroot environment on
an Android device.  (This requires using an external drive attached to
a USB C hub, with a special kernel which forces SELinux in Permissive
mode.  More documentation and automation will hopefully follow.)

Cheers,

						- Ted


