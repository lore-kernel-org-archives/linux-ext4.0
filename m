From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] block: reimplement FLUSH/FUA to support merge
Date: Fri, 21 Jan 2011 16:59:55 +0100
Message-ID: <1295625598-15203-1-git-send-email-tj@kernel.org>
To: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40594 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AUQAR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jan 2011 11:00:17 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This patchset reimplements (yeah, once more) so that FLUSH/FUA
requests can be merged.  This is inspired by Darrick's patches to
merge multiple zero-data flushes which helps workloads with highly
concurrent fsync requests.

For more information, please read the patch description on the third
patch.

 0001-block-add-REQ_FLUSH_SEQ.patch
 0002-block-improve-flush-bio-completion.patch
 0003-block-reimplement-FLUSH-FUA-to-support-merge.patch

0001-0002 prepare for the reimplementation.  0003 reimplements.

Tested on FLUSH+FUA, FLUSH, and no FLUSH configurations.  Works pretty
solid for me.  Darrick says that preliminary performance test looks
okay.  Darrick, please use this version for further testing as I fixed
a few problems.

This patchset is based on 2.6.38-rc1 (2b1caf6e) and available in the
following git branch,

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-flush-merge

and contains the following changes.

 block/blk-core.c          |   56 ++---
 block/blk-flush.c         |  441 +++++++++++++++++++++++++++++++---------------
 block/blk.h               |   12 -
 block/elevator.c          |    7 
 include/linux/blk_types.h |    2 
 include/linux/blkdev.h    |   18 +
 include/linux/elevator.h  |    1 
 7 files changed, 355 insertions(+), 182 deletions(-)

Thanks.

--
tejun
