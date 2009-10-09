From: Mingming <cmm@us.ibm.com>
Subject: [PATCH 3/4 v2] code clean up for dio fallocate handling
Date: Thu, 08 Oct 2009 18:13:33 -0700
Message-ID: <1255050813.4931.192.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:45620 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbZJIBOL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2009 21:14:11 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9912xN7030290
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:02:59 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n991DZle250916
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:13:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n991DY9O007741
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:13:35 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: code clean up for dio fallocate handling

The ext4_debug() call in ext4_end_io_dio() (inode.c) has a
should be moved after checking the io_end structure to be not a NULL pointer.

The comment above ext4_get_block_dio_write() ("Maximum
number of blocks...") is a duplicate; the original and correct comment
is above the #define DIO_MAX_BLOCKS up above.

The check for allocated > max_blocks in ext4_split_unwritten_extents()
can be removed, since the code returns immediately once allocated blocks is
less or equals to the requested blocks to convert.

Based on review comments from Curt Wohlgemuth.

Signed-off-by:	Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/extents.c |   96 +++++++++++++++++++++++++-----------------------------
 fs/ext4/inode.c   |    9 ++---
 2 files changed, 50 insertions(+), 55 deletions(-)

Index: linux-2.6.31-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/inode.c
+++ linux-2.6.31-rc4/fs/ext4/inode.c
@@ -3367,8 +3367,6 @@ out:
 	return ret;
 }
 
-/* Maximum number of blocks we map for direct IO at once. */
