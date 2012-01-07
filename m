From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC 0/2] e2fsprogs: Add FUSE server
Date: Sat, 07 Jan 2012 00:55:23 -0800
Message-ID: <20120107085523.4325.42183.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42389 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab2AGIz1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:55:27 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:55:26 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078tOf5247222
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:55:24 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078tO69013566
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 06:55:24 -0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This patchset creates a FUSE server for the ext4 filesystem.  This enables ext4
to be run (albeit slowly) in environments which lack a native ext4 driver, such
as Solaris, BSD, and Mac OS X.  It uses the functionality in libext2fs to
manipulate the filesystem.

Currently, the filesystem can be mounted for both reading and writing.  I
wouldn't mount a production filesystem rw, though in my nail-biting tests so
far it hasn't destroyed anything.  Journalling is not supported, though I'm
working on at least enabling journal replay on mount.  I suspect that full
journalling (such as what you get with kernel ext4 on Linux) is a long way off.

The performance of fuse2fs (as opposed to kernel ext4) is noticeably slow.

This patchset has been tested on 3.1 on x64 and i386, and Mac OS X.  On Linux
you'll need a libfuse that supports the v28 API; on Mac you'll need osxfuse
2.3.8.  The patchset is based atop the 1.42 release and requires three patches:

1. libext2fs: Read and write full size inodes
2. libext2fs: When truncating file, punch out blocks at end
3. libext2fs: Only link an inode into a directory once

The first patch is in the metadata checksumming set, and the other two are
general bugfixes that I posted earlier.

Let me know what you think!

--D

