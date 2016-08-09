From: Theodore Ts'o <tytso@mit.edu>
Subject: Refreshed test appliance image kvm-xfstests and gce-xfstests
Date: Tue, 9 Aug 2016 00:28:28 -0400
Message-ID: <20160809042828.GF9515@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
	gce-xfstests@googlegroups.com
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

There are updated rootfs.img files available at:

    https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

It includes the latest updates from the xfstests-dev upstream.  (For
ext4 developers, note that this includes a test for expanding the
i_extra_isize space that will cause non-patched kernels to hang unless
you have Jan Kara's patches to fix bugs in that code.  So you may want
to add -X ext4/022 to your gce-xfstests or kvm-xfstests command line.)
For information on how to use this images, please see:

https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md

Also new in this release is support for btrfs.  Internally, I've
removed most of the ext4 dependencies so that people interested in
using kvm-xfstests and gce-xfstests for testing other file systems
will have a much easier time to add new test configs.  Feel free to
send me patches or the fs configs you would most like to see for your
file system (basically, I need the mkfs and mount options that are
most interesting).  We currently have basic support for btrfs, ext2,
tmpfs, and xfs in this release, in addition to ext4.

Finally, I have started making public GCE images so you don't have to
build your own copy of xfstests and then create your own GCE image.
This should hopefully make life much easier for people who want to try
out gce-xfstests.  For more information, please see:

https://github.com/tytso/xfstests-bld/blob/master/Documentation/gce-xfstests.md

Cheers,

						- Ted
