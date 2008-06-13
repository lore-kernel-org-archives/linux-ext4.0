From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [Take2 PATCH 06/10][e2fsprogs] Add 64-bit alloc interface.
Date: Fri, 13 Jun 2008 14:31:44 -0500
Message-ID: <20080613143144.1679c75f@rx8>
References: <20080521175325.18810.25160.stgit@gara>
	<20080521175404.18810.86928.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:55083 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYFMTcG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2008 15:32:06 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5DJW14M030754
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 15:32:01 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5DJVn6W157636
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:31:50 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5DJVnNZ021156
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:31:49 -0600
In-Reply-To: <20080521175404.18810.86928.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 21 May 2008 12:54:04 -0500
"Jose R. Santos" <jrs@us.ibm.com> wrote:

> From: Jose R. Santos <jrs@us.ibm.com>
> 
> Add 64-bit alloc interface.
> 
> Add new ext2fs_new_block2(), ext2fs_get_free_blocks2() and
> ext2fs_alloc_block2() that take and return blk64_t.
> 
> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> --
> 
>  lib/ext2fs/alloc.c  |   59
> +++++++++++++++++++++++++++++++++++++++++----------
> lib/ext2fs/ext2fs.h |    8 +++++++ 2 files changed, 55 insertions(+),
> 12 deletions(-)

Hi Ted,

This patch seems like it was added incorrectly into the pu branch.  None
of the changes to alloc.c show up.

Commit: db1856299023306583f6ca8bcb450c01735da8cb

Thanks

-JRS
