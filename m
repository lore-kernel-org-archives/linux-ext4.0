From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/2] EXT4: Punch Hole Opmtimizations
Date: Mon, 27 Jun 2011 15:49:49 -0700
Message-ID: <1309214991-31141-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51918 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab1F0Wrc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 18:47:32 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5RMZj73002791
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:35:45 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5RMlVLp475684
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:47:31 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5RMlUgG014639
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:47:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We realized late that we could optimize the punch hole code by skipping
ext4_ext_remove_space, and directly calling ext4_ext_rm_leaf.  Since
punch hole is done through map blocks, the path to the extent is already
known, so we do not need to look it up again. The extra parameter that
was added in ext4_ext_remove_space is removed since we no longer need it.


Allison Henderson (2):
  EXT4: Punch Hole Optimizations: Skip un-needed extent lookup
  EXT4: Punch Hole Optimizations: Removed un-needed
    ext4_ext_remove_space param

 fs/ext4/extents.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

