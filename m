From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/21] e2fsprogs Summer 2014 patchbomb, part 3
Date: Mon, 04 Aug 2014 18:04:57 -0700
Message-ID: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39988 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaHEBFC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:05:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is part 3 of the July e2fsprogs patchset (even though it is
August) that fixes e2fsck failures with filesystems containing the
inline data feature.  e2fuzz helped me to find the failures.

The first patch fixes build problems with e2fuzz on i386 Linux and
Mac OSX, and the second patch fixes an error message introduced in
the previous patchbomb.

Patches 3-8 fix library functions such that we won't read off the end
of the EA buffer when parsing keys; some places where we neglect to
handle byte-swapping on big-endian systems correctly; remove the EA
part of inline data if it's not necessary; and fix a memory leak.

Patches 9-11 fix problems I found in libext2fs: there's a patch to add
to e2fsck the ability to find overlapping blobs in the inode EA area;
to truncate inline data files if the EA cannot be found; and to check
inline data symlinks.

Patches 12-13 fix a few bugs where e2fsck would abort unnecessarily
due to finding an inode with the inline data flag set.

Patches 14-15 try to fix inodes that shouldn't have inline_data set,
and to resolve conflicts if both extents and inline_data are set on an
inode.

Patches 16-20 deal with repair of inline data directories, since
containing directory data adds extra constraints on what constitutes a
valid inode that e2fsck should be able to fix.

Patch 21 adds test cases for the bugs I found in the inline data
repair code, and exercises the sanity tests in e2fsck.

I've tested these e2fsprogs changes against the -next branch as of
8/4.  That's not much testing, but most of the changes between 7/29
and today on that branch have been to add the patches that were in the
previous patch bomb.  As I stated in the part 1 introduction, I use
several VMs, each with 32M-1G ramdisks to test with; the test process
is "misc/e2fuzz.sh -B <fuzz> -s <size>", where fuzz is anything from 2
bytes to "0.1%" of metadata bytes.

Comments and questions are, as always, welcome.

--D
