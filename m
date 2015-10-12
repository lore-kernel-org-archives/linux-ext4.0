From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 00/12] e2fsprogs: misc fixes and cleanups;
 save checksum seeds
Date: Mon, 12 Oct 2015 14:56:29 -0700
Message-ID: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39829 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbJLV4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:56:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here's a short patch series that rolls up all my pending fixes for
assorted minor problems with e2fsprogs.  It then replaces all the open
coded feature flag functions with a series of helper functions; and
finally it introduces the "metdata_csum_seed" feature which decouples
the metadata block checksums from the FS UUID so that said UUID can be
changed while the FS is mounted.

Patches 1-2 fix an incorrect overhead calculation in mke2fs when
formatting with meta_bg that prevented formatting devices larger than
256TB; and teaches mke2fs to enable meta_bg whenever the group
descriptor blocks overflow a block group.  This makes it possible to
format ext4 on multi-petabyte block devices, albeit at a SEVERE
overhead cost.

Patches 3-7 replace open-coded feature flag manipulation code with
helper functions.  I've hand-checked all the changes to ensure that
they are correct.

Patches 8-12 introduces the metadata_csum_seed feature, which saves
the first component of metadata block checksums (specifically, the
value of crc32c(~0, FS_UUID)) in the superblock.  This enables the
administrator to change the UUID on a mounted metadata_csum
filesystem.

The patchset should apply cleanly against the -next branch as of 29
September.  Comments and questions are, as always, welcome.

--D
