From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: Refreshed rootfs.img for kvm-xfstests
Date: Thu, 21 Jul 2016 16:22:39 -0400
Message-ID: <20160721202238.GA1514@localhost.localdomain>
References: <20160717140552.GA11276@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:32882 "EHLO
	mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbcGUUTc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jul 2016 16:19:32 -0400
Received: by mail-qt0-f196.google.com with SMTP id j37so4290593qta.0
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2016 13:19:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160717140552.GA11276@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu>:
> There is an updated rootfs.img file available at:
> 
>     https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests
> 
> It includes the latest updates from the xfstests-dev upstream.
> 
> There is a new set of more nicely formatted, but more importantly,
> better organized and expanded documentation for xfstests-bld,
> kvm-xfstests, and gce-xfstests.  The new documentation is formatted in
> Markdown, and can be browsed starting at:
> 
> https://github.com/tytso/xfstests-bld/blob/master/README.md
> 
> This release also includes an updated armhf chroot distribution,
> armhf_root_fs.tar.gz.  This was previously released in the testing
> subdirectory, but it is now built as an synchrnoized part of the
> kvm-xfstests root_fs.img release process.  Very rough instructions for
> using this tarball can be found here:
> 
> https://github.com/tytso/xfstests-bld/blob/master/Documentation/android-xfstests.md

I've tested this version of the ARM test appliance using the 4k test config
on a Pandaboard with a 4.7-rc7 kernel, and have discovered a few problems with
the file system image as discussed in today's concall (the upshot was that the
build process might be failing somewhere along the way and producing an
incomplete image):

Several files needed to run the appliance are missing from /root - test-env,
test-conf, /conf (and its contents), and runtests.sh.  Copying them in
from xfstests-bld solved that.

/usr/bin/awk points to an executable in Ted's home directory.  Relinking to
/usr/bin/gawk fixed things up well enough.

With these changes, I was able to get a complete 4k run with some
discrepancies relative to my ARM baseline:

As reported in the output log produced by runtests.sh, it appears that the
quota user tools are not installed; quota-related xfstests were not run,
and the tools are missing from /root/xfstests/bin where they are found on the
x86_64 image.

Several tests using dm failed involving the error and flakey targets.  Some
succeeded in my baseline, and some are new since the baseline.  They need
a closer look to see what's going on - there's no immediate evidence the
root fs image is responsible.

Otherwise, this is an easy and convenient way to run the test appliance on
ARM.  Thanks!

Eric

> 
> If there is anyone who is interested and has time to look into
> creating an automated test runner for armhf_root_fs.tar.gz, ala
> kvm-xfstests and gce-xfstests, but using the Android adb and fastboot
> utilities to control the Android device, please let me know.  I'd love
> to find a volunteer interested in working on this project!
> 
>    	  	    	       	  	     	  - Ted
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
