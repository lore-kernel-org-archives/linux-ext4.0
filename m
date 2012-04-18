From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/6] ext4: status extents
Date: Wed, 18 Apr 2012 00:07:12 -0700
Message-ID: <1334732838-25102-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:57008 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2DRHHP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Apr 2012 03:07:15 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 18 Apr 2012 01:07:13 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 7D5D53E4004E
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:07 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3I766Tr215378
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:06 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3I76bVU005352
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:37 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This set is based on the earlier delayed extent tree, but has
been renamed to a "status extent" scheme.  The plan is that the
tree will be expanded to track allocated extents and also
support extent locks.  Thus status extents seemed like a
more appropriate name.

Allison Henderson (6):
  ext4: add two structures supporting status extent tree
  ext4: add operations on status extent tree
  ext4: initialize status extent tree
  ext4: let ext4 maintian status extent trees
  ext4: reimplement fiemap on status extent tree
  ext4: reimplement ext4_find_delay_alloc_range on status extent tree

 fs/ext4/Makefile         |    2 +-
 fs/ext4/ext4.h           |    9 +-
 fs/ext4/ext4_extents.h   |    3 +-
 fs/ext4/extents.c        |  297 ++++-----------------------------
 fs/ext4/indirect.c       |    3 +
 fs/ext4/inode.c          |   83 ++++------
 fs/ext4/status_extents.c |  417 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/status_extents.h |   40 +++++
 fs/ext4/super.c          |   13 ++-
 9 files changed, 545 insertions(+), 322 deletions(-)
 create mode 100644 fs/ext4/status_extents.c
 create mode 100644 fs/ext4/status_extents.h

