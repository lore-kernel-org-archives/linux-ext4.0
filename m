From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/6] Rename delayed extents to status extents
Date: Fri,  9 Mar 2012 21:41:19 -0700
Message-ID: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, xiaoqiangnk@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:42526 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab2CJEkx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 23:40:53 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 9 Mar 2012 21:40:52 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0757419D804A
	for <linux-ext4@vger.kernel.org>; Fri,  9 Mar 2012 21:40:44 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2A4enEh180564
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:49 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2A4emFA030453
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:49 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This set is based on Yongqiang's 
"[PATCH V3 0/6] ext4: add delayed extent tree for ext4".  
This patch set renames the changes introduced by the delayed
extent set to follow a "status extent" naming scheme.  This
set does not yet introduce any functional changes other than renaming.
The purpose of the rename it to prepare the set for supporting
allocated extents as well as delayed extents.  Then once we have
it tracking allocated extents, we can implement extent locks.
Merging the solutions will eliminate the need to maintain yet
another tree, sense both solutions are an rbtree of extents.

Sense delayed extents have not yet been merged, the plan is
to merge this set with the existing delayed extent set, and
the new "status extent" set will be the foundation for extent
locks.

Yongqiang, if this all looks good to you, I will merge
our sets and include it as part of the extent lock set,
once I get the rest of it finished up.  Thx!

Allison Henderson (6):
  Rename de patch1 from de to se scheme
  Rename de patch2 from de to se scheme
  Rename de patch3 from de to se scheme
  Rename de patch4 from de to se scheme
  Rename de patch5 from de to se scheme
  Rename de patch6 from de to se scheme

 fs/ext4/Makefile          |    2 +-
 fs/ext4/delayed_extents.c |  415 --------------------------------------------
 fs/ext4/delayed_extents.h |   40 -----
 fs/ext4/ext4.h            |    4 +-
 fs/ext4/extents.c         |   24 ++--
 fs/ext4/indirect.c        |    2 +-
 fs/ext4/inode.c           |    4 +-
 fs/ext4/status_extents.c  |  417 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/status_extents.h  |   40 +++++
 fs/ext4/super.c           |    8 +-
 10 files changed, 479 insertions(+), 477 deletions(-)
 delete mode 100644 fs/ext4/delayed_extents.c
 delete mode 100644 fs/ext4/delayed_extents.h
 create mode 100644 fs/ext4/status_extents.c
 create mode 100644 fs/ext4/status_extents.h

