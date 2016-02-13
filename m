From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/9] e2fsprogs: save checksum seeds; fix broken xattr editing;
 misc fixes
Date: Sat, 13 Feb 2016 14:37:25 -0800
Message-ID: <20160213223725.25381.20929.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33868 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcBMWha (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Feb 2016 17:37:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here's a short patch series that rolls up all my pending fixes for
e2fsprogs.  The first five patches introduce the "metdata_csum_seed"
feature which decouples the metadata block checksums from the FS UUID
so that said UUID can be changed while the FS is mounted.

Patch #6 fixes filefrag not to report holes as fragmentation.

Patch #7 changes tune2fs so that prior to making invasive changes to
the filesystem it'll check that the FS has been fsck'd recently and if
so confirms with the administrator that they actually want to proceed.

Patch #8 teaches tune2fs to recover the journal if necessary.  This
prevents tune2fs modifications from being clobbered by a journal
replay.

Patch #9 fixes a bug reported by Richard Purdie wherein we didn't sort
extended attributes in an external block according to the kernel's
expectations, which results in mke2fs creating attributes that the
kernel cannot read.

The patchset should apply cleanly against the -next branch as of 13
February (it hasn't been updated since 30 November 2015).  Comments
and questions are, as always, welcome.

(Except for patch #9, none of the patches in this set have changed
since the last posting on 4 Dec 2015.)

--D
