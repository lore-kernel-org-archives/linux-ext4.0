From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/27] e2fsprogs Summer 2014 patchbomb, part 5.1
Date: Sat, 16 Aug 2014 16:45:51 -0700
Message-ID: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23704 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaHPXp4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:45:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is the second release of part 5^H4 of the Summer 2014 e2fsprogs
patchset.  Whereas all the patches I've sent previously were to fix
problems in the library and e2fsck uncovered by the e2fuzz metadata
fuzzer, we're now to the part of the patch set that includes new
features.  I'm only posting things that have been discussed recently;
the other "new" features (that have been out for review for quite some
time) haven't changed since May.  They'll be in part 6, which I'm
holding until we get through this pile of patches.

Patches 1-5 fix various problems: #1 brings e2fuzz' pwrite detection
in line with unix_io.c.  #2 fixes some gcc warnings about unused
variables and ignored return values.  #3 fixes endian handling
problems with the inode sanity scan.  #4 fixes other endian handling
errors in the library.  #5 teaches e2fsck pass2 to undo dirent
byteswap on the remainder of the dirent block before trying to salvage
a directory with a bad rec_len.

Patch 6 adds the ability to create inline data symlinks, as suggested
by Pu Hou.

Patches 7-9 bring e2fsck's journal recovery and revoke code up to date
with Linux 3.16.

Patch 10 fixes a longstanding bug -- e2fsck recovery goes into an
infinite loop when a non-revoked journal block fails its metadata
checksum test.  Instead of doing that, keep replaying the journal and
proceed to the e2fsck.

Patch 11 introduces journal_csum v3 to fix numerous journal block tag
size handling bugs when metadata_csum+journal_checksum are turned on.
The test of 64bitness should not rely on guessing the tag size when it
could simply query the feature flags, since it was guessing
incorrectly.  Furthermore, the journal_csum v2 structure had memory
access alignment issues.  Just replace this all with a 16-byte tag
with everything in it; the overhead for checksums is no more than
0.1%.

Patches 12-14 enhance debugfs with the ability to replay journals with
dirty data and more importantly to create journal transactions; this
feature gives us the ability to (easily) create journal replay
scenarios for testing.  #13 fixes a minor bug in the e2fsck journal
management code that could in theory lead to journal corruption.

Patches 15-23 add 'make check' tests that exercise (1) the new
transaction writing ability and e2fsck' ability to replay; (2)
recovering with journal_csum v1-3; and (3) the ability to replay
journals where different kinds of journal blocks fail checksum
verification.  The test journals created in these tests have been run
through kernel jbd2 to verify that they recover properly.

Patch 24 turns on block_validity for new filesystems, to guard against
accidental re-allocations of critical FS metadata.

Patch 25-27 implement v2 of the e2fsck readahead functionality, which
promises to reduce fsck runtime by 10-30%.  You might want to read
the report: http://marc.info/?l=linux-ext4&m=140755433701165&w=2
("e2fsck readahead speedup performance report") for all the juicy
details!

I've tested these e2fsprogs changes against the -next branch as of
8/15.  The patches have been tested against the 'make check' suite and
some amount of e2fuzz testing.

Comments and questions are, as always, welcome.

--D
