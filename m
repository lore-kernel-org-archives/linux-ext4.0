From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/2 v3] EXT4: Secure Delete
Date: Thu, 30 Jun 2011 14:22:01 -0700
Message-ID: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36645 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1F3VTw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2011 17:19:52 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5UKuqFZ016271
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 16:56:52 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5ULJp15156600
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 17:19:51 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5ULJobA011213
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 17:19:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set implements secure delete for ext4.  New
flags have been added to ext4_free_blocks and ext4_delete_entry
that cause the data blocks and directory entries to be
zeroed before they are released.  Files that have the 
secure remove attribute flag on will have their data and
directory entries zeroed when they are deleted.

Allison Henderson (2):
  EXT4: Secure Delete: Zero out file data
  EXT4: Secure Delete: Zero out files directory entry

 fs/ext4/ext4.h    |    6 ++++++
 fs/ext4/extents.c |    3 +++
 fs/ext4/inode.c   |    3 +++
 fs/ext4/mballoc.c |    8 ++++++++
 fs/ext4/namei.c   |   52 +++++++++++++++++++++++++++++++++++++++++-----------
 fs/ext4/xattr.c   |   12 ++++++++----
 6 files changed, 69 insertions(+), 15 deletions(-)

