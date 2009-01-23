From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: 64-bit e2fsprogs tree for testing
Date: Thu, 22 Jan 2009 19:28:15 -0500
Message-ID: <20090123002815.GJ12643@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759820AbZAWA2R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jan 2009 19:28:17 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0N0SGp4015763
	for <linux-ext4@vger.kernel.org>; Thu, 22 Jan 2009 19:28:16 -0500
Received: from shell.devel.redhat.com (shell.devel.redhat.com [10.10.36.195])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0N0SHlB010809
	for <linux-ext4@vger.kernel.org>; Thu, 22 Jan 2009 19:28:17 -0500
Received: from shell.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by shell.devel.redhat.com (8.13.8/8.13.8) with ESMTP id n0N0SFio028081
	for <linux-ext4@vger.kernel.org>; Thu, 22 Jan 2009 19:28:16 -0500
Received: (from vaurora@localhost)
	by shell.devel.redhat.com (8.13.8/8.13.8/Submit) id n0N0SF2k028080
	for linux-ext4@vger.kernel.org; Thu, 22 Jan 2009 19:28:15 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

The e2fsprogs 64-bit branch is available for public testing.  This
branch adds support for creating, checking, etc. ext4 file systems
with more than 2^32 blocks - i.e., more than 16TB on most systems.
This is for TESTING ONLY - don't put any data you care about on it!

The public git repository is available here:

git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git

The branch is "64bit".

Known bugs:

* compilation of programs using certain libe2p routines may fail 
  (chattr, lsattr)
* fsck will fail if directories contain blocks above the 32-bit
  boundary

In general, this is very lightly tested.

Please only test against the latest ext4 kernel bits from:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

Please report bugs to this mailing list and cc'd to me if possible.

I am personally testing this using a sparse backing file on XFS, e.g.:

 # dd if=/dev/zero of=/xfs/testfile bs=4096 seek=5G count=1
 # ./misc/mke2fs /xfs/testfile
 # mount -o loop /xfs/testfile /mnt
 # dmesg | tail # to make sure it actually mounted as ext4, etc.

Unfortunately, you can't use ext4 itself to host the backing file,
since it has a limit of 2^32 blocks per file.

Thank you in advance!

-VAL
