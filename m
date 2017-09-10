From: Theodore Ts'o <tytso@mit.edu>
Subject: New release of kvm-xfstests / gce-xfstests images
Date: Sun, 10 Sep 2017 01:39:19 -0400
Message-ID: <20170910053919.bqkwuniz5galo2yd@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47530 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbdIJFjV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Sep 2017 01:39:21 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released a new version of kvm-xfstests images at:

https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

This has the latest updates from xfstests, xfsprogs, fio, quota,
e2fsprogs, et. al.  See the README file on www.kernel.org for the
details.  In addition, the images are now based on new Debian Stable
release (Stretch).

Also of interest is in this release in the associated xfstests-bld
tree[1] is two new features.  The first is android-xfstests[2], for
which Eric Biggers and I will be giving a presentation[3] at the Open
Source Summit 2017 in Los Angelos this coming Monday[4].

[1] https://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git/
[2] https://github.com/tytso/xfstests-bld/blob/master/Documentation/android-xfstests.md
[3] https://thunk.org/android-xfstests
[4] https://ossna2017.sched.com/event/242a6d0fe1d669366446fe518e9717f6

In addition, the xfstests-bld tree has a new feature (in Beta status),
a lightweight test manager (LTM).  The LTM is a great piece of work
implemented by Jason Liu, an intern at Google this past summer.

(I originally proposed calling it the "Lightweight Gce-xfstests Test
Manager", but Jason thought the acronym was too cute by half.  :-)

The way LTM works is instead running the command "gce-xfstests -c
ext4/all -g auto", you first launch the LTM VM using the command
"gce-xfstests launch-ltm".  Then you ask the LTM server to launch
multiple VM's for you using a command such as:

	gce-xfstests ltm -c ext4/all,xfs/all -g auto

The LTM server will then launch separate VM's for each file system
config (in this case, it will launch 11 ext4 test VM's, and 2 xfs test
VM's), spreading them out across multiple GCE zones and regions based
on the project's GCE quotas.  The LTM server will monitor the VM's,
and if one of the test kernel crashes or deadlocks, the LTM server
will take care of killing the VM and saving the serial console output
so the kernel developer can analyze crash/deadlock.  Once all of the
test VM's are finished, the LTM server will collate the results and
send a single e-mail report to the kernel developer.

This reduces the time it takes for me to run a complete regression
test of all of the ext4 test configs from 23 hours down to about 3.

Finally, at the moment, I have two XFS test configurations (4k and
1k), and only one (default) test config for btrfs, f2fs, overlayfs,
etc.  If you are a file system developer and you have your favorite fs
test configs, I invite you to contribute them to me, and I would be
happy to add it to kvm/gce/android-xfstests.  The config file for a
configuration are pretty simple.  For example, please see [5] and [6].

[5] https://github.com/tytso/xfstests-bld/blob/master/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt
[6] https://github.com/tytso/xfstests-bld/blob/master/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/1k

If you haven't tried gce-xfstests yet, please give it a try!
Information can be found here[7].  And if you are looking for a
quickstart on kvm-xfstests, that can be found here[8].

[7] https://github.com/tytso/xfstests-bld/blob/master/Documentation/gce-xfstests.md
[8] https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md

Cheers,

					- Ted
					
