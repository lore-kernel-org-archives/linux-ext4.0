From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/3] ext4: punch hole beyond i_size
Date: Sat, 14 Jan 2012 12:34:58 -0700
Message-ID: <1326569701-21620-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39217 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098Ab2ANT3W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Jan 2012 14:29:22 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Sat, 14 Jan 2012 14:29:21 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0EJTHVG3457192
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 14:29:17 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0EJTHah025864
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 17:29:17 -0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set allows punch hole to punch beyond i_size.
Additionally some uneeded code has been removed, and
some return codes in ext4_punch_hole has been corrected.

Allison Henderson (3):
  ext4: Allow punch hole beyond i_size
  ext4: Remove uneeded i_size handling
  ext4: Correct ext4_punch_hole return codes

 fs/ext4/extents.c |   34 ----------------------------------
 fs/ext4/inode.c   |    6 +++---
 2 files changed, 3 insertions(+), 37 deletions(-)

