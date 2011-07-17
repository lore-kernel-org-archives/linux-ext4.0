From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/2 v8] XFS TESTS: ENOSPC Punch Hole Test
Date: Sun, 17 Jul 2011 16:52:44 -0700
Message-ID: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45484 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab1GQXw6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 19:52:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set adds the ENOSPC test that was used for ext4 punch hole testing.
This test will verify that a hole can be punched even when the disk is full.
Reserved blocks should be used to complete the operation when there is not blocks
to further fragment the file.

Because punching a hole does not always require extra blocks, there needs to 
be several iterations of punching holes, and then filling the file system to 100% 
usage before it is forced to grow the tree in order to handle the fragmentation. 
The growing of the tree is what would cause ENOSPC if not for the use of reserved blocks.

Allison Henderson (2):
  XFS TESTS: ENOSPC Punch Hole: Move su routines in 123 to common.rc
  XFS TESTS: Add ENOSPC Hole Punch Test

 123       |   24 ------------
 256       |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 256.out   |    1 +
 common.rc |   81 +++++++++++++++++++++++++++++++++++++++++
 group     |   12 ++++--
 5 files changed, 210 insertions(+), 28 deletions(-)
 create mode 100644 256
 create mode 100644 256.out

