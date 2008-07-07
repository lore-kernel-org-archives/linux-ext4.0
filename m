From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH][e2fsprogs][mke2fs] fix FLEX_BG offset
Date: Mon, 7 Jul 2008 14:42:40 -0500
Message-ID: <20080707144240.60656c76@gara>
References: <486C8BEE.5030200@bull.net>
	<20080703065553.53c35979@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Celine Bourde <celine.bourde@bull.net>, linux-ext4@vger.kernel.org,
	cmm@us.ibm.com,
	=?UTF-8?B?RnLDqWTDqXJpYyBCb2jDqQ==?= <frederic.bohe@bull.net>,
	SOLOFO RAMANGALAHY <Solofo.Ramangalahy@bull.net>,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35637 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbYGGTm1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2008 15:42:27 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m67JgOR1018219
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jul 2008 15:42:24 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m67JgOjh236640
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jul 2008 15:42:24 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m67JgNDI000597
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jul 2008 15:42:24 -0400
In-Reply-To: <20080703065553.53c35979@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 3 Jul 2008 06:55:53 -0500
"Jose R. Santos" <jrs@us.ibm.com> wrote:

> On Thu, 03 Jul 2008 10:21:02 +0200
> Celine Bourde <celine.bourde@bull.net> wrote:
> 
> > This patch resolves the offset problem of the flex_bg
> > option when you use mke2fs tool.
> > 
> > For example, if you type mkfs.ext4 -I256 -O flex_bg -G32 -E test_fs <device>
> > and look dumpe2fs <device> result you will see an offset problem.
> > 
> > Group 0: (Blocks 0-32767)
> > Primary superblock at 0, Group descriptors at 1-5
> > Reserved GDT blocks at 6-1024
> > Block bitmap at 1025 (+1025), Inode bitmap at 1058 (+1058)
> > Inode table at 1090-1601 (+1090)
> > 0 free blocks, 8181 free inodes, 2 directories
> > Free blocks:
> > Free inodes: 12-8192
> > 
> > Inode bitmap must start at 1025 + 32 = 1057
> > In all flexbg groups, the block between the last block bitmap and the 
> > first inode
> > bitmap (metatdata) is not used, which introduced a hole.
> > 
> > This patch corrects it.
> > You have to apply it on e2fsprogs (mke2fs 1.41-WIP (17-Jun-2008)) master 
> > branch.
> > 
> > Celine Bourde.
> 
> Acked-by: Jose R. Santos <jrs@us.ibm.com>

Looks like I jumped the gun to fast acknowledging this patch.  The
current patch doesn't run the second ext2fs_get_free_blocks() when
doing a search for block bitmap space.

Here is an updated patch.

commit a58058e85240c7834cd863efa35b21688e104047
Author: Jose R. Santos <jrs@us.ibm.com>
Date:   Mon Jul 7 14:36:08 2008 -0500

    Fix FLEX_BG offset
    
    The offset for both inode bitmaps and inode tables is overshot by one
    block causing a hole between the group of bitmaps and inode tables.

    Signed-off-by: Jose R. Santos <jrs@us.ibm.com>

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index d87585b..7f6ac77 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -46,6 +46,8 @@ static blk_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
 	if (size > fs->super->s_blocks_per_group / 8)
 		size = fs->super->s_blocks_per_group / 8;
 
+	if (offset)
+		offset -= 1;
 	/*
 	 * Dont do a long search if the previous block
 	 * search is still valid.




-JRS
