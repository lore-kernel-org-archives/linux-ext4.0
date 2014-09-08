From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/25] e2fsprogs Summer 2014 patchbomb, part 5.2
Date: Mon, 08 Sep 2014 16:11:35 -0700
Message-ID: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48815 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaIHXLm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:11:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is the third release of part 5^H4 of the Summer 2014 e2fsprogs
patchset.  Whereas all the patches I've sent previously were to fix
problems in the library and e2fsck uncovered by the e2fuzz metadata
fuzzer, we're now to the part of the patch set that includes new
features.  I'm only posting things that have been discussed recently;
the other "new" features (most of which have been out for review for
quite some time) haven't changed since May.  They'll be in part 6,
which I'm holding until we get through this pile of patches.

Patch 1 introduces journal_csum v3 to fix numerous journal block tag
size handling bugs when metadata_csum+journal_checksum are turned on.
The test of 64bitness should not rely on guessing the tag size when it
could simply query the feature flags, since it was guessing
incorrectly.  Furthermore, the journal_csum v2 structure had memory
access alignment issues.  Just replace this all with a 16-byte tag
with everything in it; the overhead for checksums is no more than
0.1%.

Patches 2-4 fix some problems with incorrect error codes being
returned and a place where error codes could be dropped.

Patches 5-6 enable us to format the ext4 superblock of an external
journal device with metadata_csum enabled, so that the ext4 superblock
can be protected with a checksum.  Note that this is entirely separate
from journal_checksum, which only applies to the journal blocks on the
external device.  See section 11.2 of the ext4 disk layout page for
details about external journal devices.

Patches 7-8 fix a few small problems when dealing with external
journal devices, namely that dumpe2fs failed to print external journal
features, and that tune2fs shouldn't print 'cannot find superblock'
when passed an external journal device.

Patch 9 zeroes the superblock's j_blocks field when discarding an
internal journal.

Patches 10-12 enhance debugfs with the ability to replay journals with
dirty data and more importantly to create journal transactions; this
feature gives us the ability to (easily) create journal replay
scenarios for testing.  #11 fixes a minor bug in the e2fsck journal
management code that could in theory lead to journal corruption.

Patches 13-22 add 'make check' tests that exercise (1) the new
transaction writing ability and e2fsck' ability to replay; (2)
recovering with journal_csum v1-3; and (3) the ability to replay
journals where different kinds of journal blocks fail checksum
verification.  The test journals created in these tests have been run
through kernel jbd2 to verify that they recover properly.  There
are now tests to verify the writability and replayability when
an external journal is used.

NOTE: The test "j_corrupt_journal_block" in patch 21 ensures that
e2fsck will replay everything but the corrupt block, and then proceeds
with the fsck to fix up whatever might be broken.  You can decompress
the image.gz and try to mount it to verify that it's unmountable (and
hence requires e2fsck to be run).

Patches 23-25 implement v2 of the e2fsck readahead functionality,
which promises to reduce fsck runtime by 10-30%.  You might want to
read the report: http://marc.info/?l=linux-ext4&m=140755433701165&w=2
("e2fsck readahead speedup performance report") for all the juicy
details!

I've tested these e2fsprogs changes against the -next branch as of
8/29.  The patches have been tested against the 'make check' suite and
some amount of e2fuzz testing.

Comments and questions are, as always, welcome.

--D
