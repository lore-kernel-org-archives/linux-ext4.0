From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/19] e2fsprogs patchbomb 7/14, part 2.1
Date: Fri, 01 Aug 2014 11:11:40 -0700
Message-ID: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32803 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHASLp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:11:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here are revisions to the patchset that I sent last Friday, fixing
e2fsck failures with filesystems containing the metadata checksumming
features.  Like last week, e2fuzz helped me to find the failures.

The first patch fixes a Coverity complaint against e2fuzz.  Patch 2
ensures that e2fsck never clears a block in block_found_map if it's in
marked in the block_metadata_map.  Patch 3 suggests putting lost
inodes in the root directory if it's impossible to recreate the
lost+found directory.  Patch 4 fixes dumpe2fs to complain about
checksum errors without requiring command line options.

Patches 5-8 tear down the foundations of the strict_csum vs
no_strict_csum patchset in favor of checking any object that fails
checksum verification for some basic sanity.  If it finds sanity it'll
try to recover it, otherwise it'll declare it to be garbage and simply
zap it.  Users will not have to decide on a config option.

Patches 9-12 also fix errors when dealing with FS objects that fail
checksum tests.  Library flag handling, error reporting, and inode
re-checking (for regular mode) all receive some treatment.

Patches 13-19 are simple regression tests to check that e2fsck can
deal with various kinds of checksum failures -- errors that trigger
other corrective action; errors that don't make the FS inconsistent
(and would have gone unnoticed without metadata_csu); the checksum
itself being wrong; and total block destruction.

I've tested these e2fsprogs changes against the -next branch as of
7/29.  As I stated in the part 1 introduction, I use several VMs, each
with 32M-1G ramdisks to test with; the test process is "misc/e2fuzz.sh
-B <fuzz> -s <size>", where fuzz is anything from 2 bytes to "0.1%"
of metadata bytes.  I've been running five VMs for the past two days,
and the only new failures it found resulted in the patches 2-3.

Comments and questions are, as always, welcome.

--D
