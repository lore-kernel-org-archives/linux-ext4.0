From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [Resubmit][Patch 0/2] Persistent preallocation in ext4
Date: Wed, 17 Jan 2007 15:16:58 +0530
Message-ID: <20070117094658.GA17390@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:47087 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbXAQJrI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jan 2007 04:47:08 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0H9l6bj011361
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 04:47:06 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0H9l654550502
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 02:47:06 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0H9l5ME001845
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 02:47:06 -0700
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Please Note (especially <c> below):
----------------------------------
<a> This is being resubmitted as part of the recall for ext4 patches.
<b> The patches are based on 2.6.20-rc5 kernel version.
<c> These patches require the "EXTENT OVERLAP BUGFIX" patch submitted by
me earlier (on Jan 16th).

Description:
-----------
Persistent preallocation is a proposed new feature in ext4, which will
allow user applications to preallocate blocks for a file. It is
similar to posix_fallocate call, but does not initialize (write to)
the blocks allocated (unlike fallocate). 
This patch uses ioctl interface and returns "0" if the call succeeds,
else returns the error number. Other approaches are discussed under
"Outstanding Issues" section below.

There are two patches being submitted as part of this:

(1) The first patch implements the ioctl interface, which does the
preallocation. The preallocated blocks are part of a new extent,
which is marked "uninitialized". The MSB in ee_len (of ext4_extent
datastructure) is used to mark an extent "uninitialized". It also takes
care of preallocating through a hole and updating the file size
accordingly.

(2) The second patch implements the support for writing to the
uninitialized extent(s). This write may result in breaking down the
uninitialized extent into one initialized extent and upto two
uninitialized extents, depending on which part of the uninitialized
extent is being written to. If all the blocks in the uninitialized
extent are being written on, the extent is marked initialized and no
split is required. This patch also takes care of merging the initialized
extent with neighbouring ones, if possible.

Outstanding Issues:
------------------
(1) The final interface is yet to be decided. We have the option of
chosing from one of these:
	a> modifying posix_fallocate() in glibc
	b> using fcntl
	c> using ftruncate, or
	d> using the ioctl interface.

  If we go with ioctl interface, we need to chose the return
value from the ioctl. We should either return "0" for success and
errno for failure, or we should be returning number of bytes
preallocated.

(2) Also, we need to decide on what should happen in case of a
partial success scenario. i.e. after few blocks get preallocated, we hit
some error - say ENOSPC. Should the call just return the number of bytes
preallocated, or should it "undo" the partial preallocation and then
exit with error code ?

(3) Currently we only allow persistent preallocation on files that have
extents enabled. It was considered a rare case where user may want
preallocation on non-extent based file(s). And even if someone really
wants to do this, it will be recommended to convert the file to the
extent-based format first, and then do persistent preallocation on it.

Testing done:
------------
(1) Unit testing included preallocating blocks and writing to it.
Preallocation through holes were also tested. Creation, splitting and
merging of extents was observed through a modified (patched) version of
debugfs (part of e2fsprogs). This modified version recognises and
flags uninitialized extent(s) in the output/display.
(2) For stress testing, fsx-linux (from LTP) was patched and used. It was
modified to call preallocation ioctl instead of ftuncate operations. It
uncovered couple of bugs (extent overlap being one of them). These bugs
have already been fixed here.

The patches for e2fsprogs and fsx-linux are available with me. I can
post them if anyone is interested to try/test the preallocation patches.
Also, I have a small test program/tool written which can be used for
unit testing.

Thanks!
--
Regards,
Amit Arora
