From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Fix incorrect interior node logical start values
Date: Thu, 29 Nov 2012 08:31:29 -0500
Message-ID: <20121129133129.GC20413@thunk.org>
References: <50A546D8.3020500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35738 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab2K2Nbc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2012 08:31:32 -0500
Content-Disposition: inline
In-Reply-To: <50A546D8.3020500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm, it looks like you didn't run the regression test script before
submitting this patch?

It looks like it's not a bug which your patch introduced, but rather,
it uncovered a bug.  This was a failure in the second run of
f_extent_bad_node, because in the fix we didn't make sure we updated
the starting block of parent node when we cleared a node in the extent
tree.  (see below)

This brings up another question.  Did you test file systems after
running punch on a number of different files to make sure the e2fsck
is happy withe file systems which current kernels might generate?

In this particular test case, even though the logical start didn't
match, it doesn't cause any problems because it's at the left-most
branch of the tree.  I want to make sure we aren't triggering failures
for file systems where the kernel is creating which is technically
incorrect, but which isn't causing problems in practice...

	       	     	   	   - Ted

% ./test_script f_extent_bad_node
f_extent_bad_node: bad interior node in extent tree: failed
--- ../../tests/f_extent_bad_node/expect.2     2012-07-06 13:37:27.316253023 +0000
+++ f_extent_bad_node.2.log		       2012-11-29 13:24:11.119306973 +0000
@@ -1,7 +1,23 @@
 Pass 1: Checking inodes, blocks, and sizes
+Interior extent node level 0 of inode 12:
+Logical start 0 does not match logical start 3 at next level.  Fix? yes
+
+Inode 12, i_blocks is 8, should be 6.  Fix? yes
+
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/16 files (0.0% non-contiguous), 25/100 blocks
-Exit status is 0
+Block bitmap differences:  -24
+Fix? yes
+
+Free blocks count wrong for group #0 (75, counted=76).
+Fix? yes
+
+Free blocks count wrong (75, counted=76).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/16 files (0.0% non-contiguous), 24/100 blocks
+Exit status is 1
125 tests succeeded	1 tests failed
Tests failed: f_extent_bad_node 


