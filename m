From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/18] e2fsprogs patchbomb 7/14, part 2
Date: Fri, 25 Jul 2014 17:33:39 -0700
Message-ID: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17108 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaGZAdu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:33:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Continuing the patchset that I sent last Friday, here are patches to
fix e2fsck failures with filesystems containing the bigalloc and/or
metadata checksumming features.  Like last week, e2fuzz helped me to
find the failures.

The first patch is the 'reserve & repair root' patch from last week,
unchanged from last week but included so it doesn't get lost in the
noise.  The second patch fixes a merge error in -next.

Patches 3 & 5 fix some fairly common errors when allocating or
deallocating blocks within a cluster.  Perhaps the most controversial
bigalloc patch is #4, which uses the duplicate block handler to
enforce that a logical cluster only maps to a single physical cluster,
and that within a cluster, each logical block maps to the same block
within the physical cluster.

Patches 6-10 are largely unchanged from patches 10-14 in the 5/14
patchbomb, though they include suggestions that Luk=C3=A1=C5=A1 had at =
that
time.  These patches largely alter e2fsck's behavior regarding
checksums -- allowing the user to specify strict mode (zap anything
with a bad checksum) or regular mode (fix checksum if it passes other
tests), and corrects some mis-handling by other parts of fsck.

Patches 11-18 also fix errors when dealing with FS objects that fail
checksum tests.  Library flag handling, error reporting, inode
re-checking (for regular mode), directory repair, and extent checksum
repair all required minor corrections.

I've tested these e2fsprogs changes against the -next branch as of
7/25.  As I stated in the part 1 introduction, I use several VMs, each
with 32M-1G ramdisks to test with; the test process is "misc/e2fuzz.sh
-B <fuzz> -s <size>", where fuzz is anything from 2 bytes to "0.1%"
of metadata bytes.  Since the bulk of changes to -next in the past 12
days are my own patches, I've only run the `make check' tests and run
e2fuzz a few thousand times to quick-check for errors.

Next week will be e2fsck fixes for extended attribute and inline data
problems.

Comments and questions are, as always, welcome.

--D
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
