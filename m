From: Theodore Ts'o <tytso@mit.edu>
Subject: ea_inode gce-xfstests results
Date: Wed, 5 Jul 2017 11:28:48 -0400
Message-ID: <20170705152847.owkgnqgrb25drqby@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tahsin@google.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49528 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbdGEP2u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 5 Jul 2017 11:28:50 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the results using what I currently have in the ext4 and
e2fsprogs git tree for ea_inode.  On the whole things look really
good, with only a handful of failures!

				- Ted

CMDLINE: -c ea_inode -g auto
FSTESTIMG: gce-xfstests/xfstests-201707050037
FSTESTPRJ: gce-xfstests
FSTESTVER: e2fsprogs	v1.43.4-119-g10118e470 (Wed, 5 Jul 2017 00:08:07 -0400)
FSTESTVER: fio		fio-2.19 (Tue, 4 Apr 2017 08:30:59 -0600)
FSTESTVER: quota		e0b6335 (Thu, 9 Feb 2017 11:55:45 +0100)
FSTESTVER: stress-ng	4ad62e1 (Mon, 27 Feb 2017 14:28:36 -0500)
FSTESTVER: xfsprogs	v4.11.0 (Fri, 5 May 2017 13:24:46 -0500)
FSTESTVER: xfstests-bld	584c15c (Wed, 5 Jul 2017 00:02:57 -0400)
FSTESTVER: xfstests	linux-v3.8-1538-g2abb61c (Wed, 5 Jul 2017 00:33:47 -0400)
FSTESTVER: kernel	4.12.0-rc2-ext4-00044-ge4121843ec6d-dirty #454 SMP Tue Jul 4 21:23:31 EDT 2017 x86_64
FSTESTCFG: "ea_inode"
FSTESTSET: "-g auto"
FSTESTEXC: ""
FSTESTOPT: "aex"
MNTOPTS: ""
CPUS: "2"
MEM: "6489.31"
MEM: 7680 MB (Max capacity)
BEGIN TEST ea_inode: xattr values in inodes with deduplication Wed Jul  5 00:56:35 EDT 2017
Failures: ext4/004 generic/319 generic/388 generic/397 generic/422

_check_generic_filesystem: filesystem on /dev/mapper/xt-vdc is inconsistent
(see /results/ext4/results-ea_inode/generic/388.full for details)

Test failure initial analysis

ext4/004
========

dump/restore doesn't support the ea_inode (will exclude in the future)

generic/319
===========

Looks like some kind of ENOSPC error when inheriting the acl
(this may be a journal credits issue?):

--- tests/generic/319.out	2016-09-30 00:04:41.719461931 -0400
+++ /tmp/results-201707050054/ext4/results-ea_inode/generic/319.out.bad	2017-07-05 02:31:23.000000000 -0400
@@ -9,13 +9,5 @@
 default:group::rwx
 default:other::---
 
-# file: SCRATCH_MNT/testdir/testsubdir
-# owner: root
-# group: root
-user::rwx
-group::rwx
-other::---
-default:user::rwx
-default:group::rwx
-default:other::---
-
+mkdir: cannot create directory '/xt-vdc/testdir/testsubdir': No space left on device
+getfacl: /xt-vdc/testdir/testsubdir: No such file or directory


generic/388
===========

Shutting down a file system while it is busy can lead to the file
system getting corrupted.  This failure exists on other configs, and
is an known issue that needs to be looked into.

generic/397
===========

Another ENOSPC issue, this time with the ext4 encryption feature
enabled.  I suspect again that it's a journal credits issue because
the file system size is not constrained and the test isn't initially
trying to fill the free space to test for ENOSPC allocation bugs.

--- tests/generic/397.out	2017-01-07 11:19:15.516350149 -0500
+++ /tmp/results-201707050054/ext4/results-ea_inode/generic/397.out.bad	2017-07-05 02:47:21.000000000 -0400
@@ -1,7 +1,10 @@
 QA output created by 397
+ln: failed to create symbolic link '/xt-vdc/edir/symlink3': No space left on device
+Only in /xt-vdc/ref_dir: symlink3
+Only in /xt-vdc/ref_dir: symlink3
 stat: cannot stat 'SCRATCH_MNT/edir/empty': No such file or directory
 stat: cannot stat 'SCRATCH_MNT/edir/symlink': No such file or directory
-8
+7
 1
 Required key not available
 SCRATCH_MNT/edir/newfile: Required key not available

generic/422
===========

This one is weird because we're not trying to test for xattrs and I
don't belive xattrs are being created at all.  So I'm not sure where
the file size change is coming from:

--- tests/generic/422.out	2017-04-30 21:56:40.053842447 -0400
+++ /tmp/results-201707050054/ext4/results-ea_inode/generic/422.out.bad	2017-07-05 03:03:01.000000000 -0400
@@ -27,7 +27,7 @@
 Space used by file foo3:
 128K	SCRATCH_MNT/foo3
 Space used by file foo4:
-64K	SCRATCH_MNT/foo4
+68K	SCRATCH_MNT/foo4
 
 After writeback
 
@@ -38,4 +38,4 @@
 Space used by file foo3:
 128K	SCRATCH_MNT/foo3
 Space used by file foo4:
-64K	SCRATCH_MNT/foo4
+68K	SCRATCH_MNT/foo4
