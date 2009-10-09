From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 1/2] code clean up for dio fallocate handling
Date: Thu, 08 Oct 2009 18:03:49 -0700
Message-ID: <1255050229.4931.146.camel@mingming-laptop>
References: <1254935953.18662.2.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52465 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760113AbZJIBEb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2009 21:04:31 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n990vQEW006235
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 18:57:26 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9913p7F247422
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:03:51 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9913p7Z016912
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:03:51 -0600
In-Reply-To: <1254935953.18662.2.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-10-07 at 10:19 -0700, Mingming wrote:
> ext4: code clean up for dio fallocate handling
> 
> In the non async IO direct IO case, the io_end structure could be NULL.
> The ext4_debug() call in ext4_end_io_dio() (inode.c) should be moved
> after checking the io_end structure to be a non NULL pointer.
> 
> The comment above ext4_get_block_dio_write() ("Maximum
> number of blocks...") is a duplicate; the original and correct comment
> is above the #define DIO_MAX_BLOCKS up above.
> 
> The check for allocated > max_blocks in ext4_split_unwritten_extents()
> can be removed, since the code returns immediately once allocated blocks
> is less or equals to the requested blocks to convert.
> 
> Based on review comments from Curt Wohlgemuth.
> 
> Signed-off-by:	Mingming Cao <cmm@us.ibm.com>

Updated cleanup patch after [patch 2/2 Fix return value of splitting
extents for dio write over fallocate ]fixed another bug. We still need
the check for allocated > max_blocks in ext4_split_unwritten_extents().

I'll resubmit the updated patch series (including two other bug
fixes/clean ups sent earlier this week) to the list again to avoid
confusion.

Thanks,
Mingming


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
