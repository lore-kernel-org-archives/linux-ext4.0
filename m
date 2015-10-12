From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/8] ext4/jbd2: misc fixes and cleanups; save checksum seeds
Date: Mon, 12 Oct 2015 14:54:16 -0700
Message-ID: <20151012215416.28872.8160.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38976 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbJLVyU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:54:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here's a short patch series that rolls up all my pending fixes for
assorted minor problems with ext2, ext4, and jbd2.  It then introduces
the "metdata_csum_seed" feature which decouples the metadata block
checksums from the FS UUID so that said UUID can be changed while the
FS is mounted; finally, it replaces all the open coded feature flag
functions with a series of helper functions.

The first patch fixes a crash in the journal checksumming code where
if the journal checksum feature flag gets turned on after the journal
loads, a missing checksum function context results in a crash.
Generally this only happens if you have bad memory or something
overwrites the mounted filesystem.  This fixes a bug reported by
Nikolay Borisov.

Patches 2-3 move ext4 ahead of ext2 in the default probing order and
teaches ext2 not to rw mount a filesystem with a journal if ext4 is
available.  Anyone wishing to force usage of ext2.ko for an ext2
filesystem when ext4 is present must use "mount -t ext2" or
"rootfstype=ext2".  This fixes a bug reported by Dave Chinner.

Patch 4 introduces the metadata_csum_seed feature, which saves the
first component of metadata block checksums (specifically, the value
of crc32c(~0, FS_UUID)) in the superblock.  This enables the
administrator to change the UUID on a mounted metadata_csum
filesystem.

Patches 5-6 change ext4 to return error codes of EFSBADCRC for failed
CRC verification and EFSCORRUPTED for data structures that look
incorrect.  This mimics the behavior of XFS.

Patches 7-8 replace open-coded feature flag manipulation code with
helper functions.  I've hand-checked all the changes to ensure that
they are correct.

The patchset should apply cleanly against 4.3-rc5.  Comments and
questions are, as always, welcome.

--D
