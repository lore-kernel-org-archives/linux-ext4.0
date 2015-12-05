From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/8] e2fsprogs: save checksum seeds; misc fixes
Date: Fri, 04 Dec 2015 18:44:16 -0800
Message-ID: <20151205024416.31087.14808.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35837 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbLECoW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 21:44:22 -0500
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

The patchset should apply cleanly against the -next branch as of 30
November.  Comments and questions are, as always, welcome.

--D
