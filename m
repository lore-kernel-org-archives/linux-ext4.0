From: Theodore Ts'o <tytso@mit.edu>
Subject: Refreshed rootfs.img for kvm-xfstests
Date: Sun, 17 Jul 2016 10:05:52 -0400
Message-ID: <20160717140552.GA11276@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35640 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbcGQOF4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2016 10:05:56 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is an updated rootfs.img file available at:

    https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

It includes the latest updates from the xfstests-dev upstream.

There is a new set of more nicely formatted, but more importantly,
better organized and expanded documentation for xfstests-bld,
kvm-xfstests, and gce-xfstests.  The new documentation is formatted in
Markdown, and can be browsed starting at:

https://github.com/tytso/xfstests-bld/blob/master/README.md

This release also includes an updated armhf chroot distribution,
armhf_root_fs.tar.gz.  This was previously released in the testing
subdirectory, but it is now built as an synchrnoized part of the
kvm-xfstests root_fs.img release process.  Very rough instructions for
using this tarball can be found here:

https://github.com/tytso/xfstests-bld/blob/master/Documentation/android-xfstests.md

If there is anyone who is interested and has time to look into
creating an automated test runner for armhf_root_fs.tar.gz, ala
kvm-xfstests and gce-xfstests, but using the Android adb and fastboot
utilities to control the Android device, please let me know.  I'd love
to find a volunteer interested in working on this project!

   	  	    	       	  	     	  - Ted



