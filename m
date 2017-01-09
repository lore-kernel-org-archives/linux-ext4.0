From: Theodore Ts'o <tytso@mit.edu>
Subject: Refreshed rootfs.img for kvm-xfstests
Date: Mon, 9 Jan 2017 18:14:50 -0500
Message-ID: <20170109231450.objek3yirxbtbgzn@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

There is an updated rootfs.img file available at:

    https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

It includes the latest updates from the xfstests-dev upstream, as well
as updated file system utilities from debian-backports.  It also adds
support for the new encryption teests from Eric Biggers (for this
reason the xfsprogs in this image includes an out-of-tree patch to
allow xfs_io to set the encryption policy).

We also now skip all of the reflink/dedupe tests when running tests
for ext4, to speed up our testing.

This release of kvm-xfstests now supports f2fs (as well as btrfs,
ext2, ext4, overlay, tmpfs, and xfs).

The gce-xfstests driver has been updated to support the latest gcloud
SDK and Debian releases as well as the above changes.  For more
information about this test framework, please see:

    http://thunk.org/gce-xfstests

						- Ted

e2fsprogs	v1.43.3-30-g8df85fb (Sun, 4 Sep 2016 21:32:35 -0400)
fio		fio-2.16 (Mon, 19 Dec 2016 23:12:56 -0700)
quota		2b37958 (Tue, 9 Aug 2016 19:17:56 +0200)
xfsprogs	v4.9.0-1-g07d66eb (Sat, 7 Jan 2017 23:27:26 -0500)
xfstests-bld	39124a6 (Mon, 9 Jan 2017 11:09:14 -0500)
xfstests	linux-v3.8-1306-gbeffdf1 (Sun, 8 Jan 2017 20:30:22 -0500)
						
