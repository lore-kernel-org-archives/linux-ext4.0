From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/2] jbd2 checksum-related fixes
Date: Fri, 15 Aug 2014 13:43:46 -0700
Message-ID: <20140815204346.16444.14064.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23647 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaHOUnv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2014 16:43:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is a pair of patches to jbd2 that fix some problems that have
been found when journal checksumming is enabled.

Patch 1 fixes a longstanding bug -- journal recovery goes into an
infinite loop when a non-revoked journal block fails its metadata
checksum test.  Instead, keep replaying the journal and proceed to the
e2fsck.

Patch 2 introduces journal_csum v3 to fix numerous journal block
tag size handling bugs.  The test of 64bitness should not rely on
guessing the tag size when it could simply query the feature flags.
Furthermore, the journal_csum v2 structure had memory access alignment
issues.  Just replace this all with a 16-byte tag with everything in
it; the overhead for checksums is no more than 0.1%.

Patches are against 3.16, and have been xfstest'd and checked against
debugfs creating test journals (see e2fsprogs patchbomb 5.1 later
tonight).

Comments and questions are, as always, welcome.

--D
