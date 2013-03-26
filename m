From: Theodore Ts'o <tytso@mit.edu>
Subject: Updated version of xfstests-bld pushed to git.kernel.org
Date: Mon, 25 Mar 2013 23:17:59 -0400
Message-ID: <nsxk3ouzw60.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akshaylal@google.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55874 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759336Ab3CZDSE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Mar 2013 23:18:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've pushed an updated version of my xfstests-bld framework to:

     git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git
     http://git.kernel.org/cgit/fs/ext2/xfstests-bld.git

Notable new features include:

*) Build quota-tools and fio in the hermetic environment and install
   them in the xfstest/bin directory, so that running the tests is not
   dependent on the system versions of fio and the quota userspace
   utilities

*) Update the runtests.sh script to fix a compatibility problem with the
   latest version of xfstests

*) Make it possible to build the installed executables to use the system
   C libraries in order to save disk space

Short version on how to use:

1.  "make tarball" to generate the xfstests.tar.gz file.  This should be
    unpacked in the directory /root of your KVM guest OS image
2.  Copy the files in kvm-autorun to the /root directory on the guest OS
    image
3.  Move /root/rc.local to /etc/rc.local
4.  Move /root/S06mkvdevs.sh to /etc/init.d and create a symlink from
    /etc/init.d/S06mkvdevs.sh to /etc/rc.d/rcS.d
5.  Add entries to /etc/fstab for /dev/vdb, /dev/vdc, and /dev/vdb as
    ext4 file systems mounted on /vdb, /vdc, /vdd respectively.  Make
    sure empty direcotires exist for the /vdb, /vdc, vdd mount points.
6.  The host OS scripts are in kvm-xfststs directory.  You'll need to
    edit the DIR= line in kvm-xfstests, and adjust some of the
    parameters in the kvm-xfstests/config file

                                                - Ted
