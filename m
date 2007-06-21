From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 0/11] [take 2] e2fsprogs: add 64-bit support
Date: Thu, 21 Jun 2007 17:56:23 +0200
Message-ID: <467A9FA7.1070804@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36951 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbXFUPzK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 11:55:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I have updated my patchset taking into account comments received from
Andreas and Jose, except for the last patch concerning the ACLs/EAs for
which I did not do anything.
As the changes are rather significant, I send here a new version for re=
view.

Changes from the previous version:
- support of different group descriptor sizes for ext4 filesystems:
  -- Add new inline functions to get/set the block bitmap block, the
inode bitmap block and the inode table block of a group.
  -- Add a new inline function to get the descriptor of a group.
- remove some '_EXT4FS_' conditional compilation and use instead
INCOMPAT_64BIT tests.
- Fix errors found in the test suite "make check"


TODOs:
   - support of 48-bit in extents to complete,
   - support of 48-bit block number for EAs to do,
   - change the format string %u for a block number to %llu in case of
64 bits (many occurences in the code)
   - more testing


Current status:
the code was compiled with _EXT4FS_ option, booted and briefly tested o=
n
a 20TB device on an x86_64 system (mkfs, debugfs, e2fsck, dumpe2fs,
filefrag commands tested).
Some non-regression tests also done on ext3 filesystems when compiling
code without _EXT4FS_ option.

This patchset applies to the version e2fsprogs-1.39-tyt3 of e2fsprogs i=
n
the following order:

[PATCH 1/11] add new mkfs option to create ext4 filesystems
[PATCH 2/11] add new macro EXT2_DESC_PER_BLOCK in e2fsprogs
[PATCH 3/11] new badblocks interface in e2fsprogs
[PATCH 4/11] convert some block types in e2fsprogs
[PATCH 5/11] new bitmaps interface in e2fsprogs
[PATCH 6/11] handling of 64-bit block counts in e2fsprofs
[PATCH 7/11] handling of 64-bit block numbers in group desc in e2fsprog=
s
[PATCH 8/11] 48-bit extents in e2fsprogs
[PATCH 9/11] indirect block type conversion in e2fsprogs
[PATCH 10/11] convert blk_t to 64-bit for ext4 FS in e2fsprogs
[PATCH 11/11] 48-bit block number for ACL in e2fsprogs

Regards,
    Val=E9rie
