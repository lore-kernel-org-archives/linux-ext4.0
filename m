From: Eric Sandeen <sandeen@sandeen.net>
Subject: mkfs'ing a 48-bit fs... or not.
Date: Mon, 03 Oct 2011 16:55:11 -0500
Message-ID: <4E8A2F3F.30700@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41778 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645Ab1JCVzM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 17:55:12 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 6A20249637CE
	for <linux-ext4@vger.kernel.org>; Mon,  3 Oct 2011 16:55:11 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Has anyone tried mke2fs at its limits?  The latest git tree seems to fail in several ways.
(Richard Jones reported the initial failure)

# truncate --size 1152921504606846976 reallybigfile 
# mke2fs -t ext4 reallybigfile

first,

Warning: the fs_type huge is not defined in mke2fs.conf

(when types "big" and "huge" got added, they never got a mke2fs.conf update?)

Then, I got:

reallybigfile: Not enough space to build proposed filesystem while setting up superblock


because:

        fs->group_desc_count = (blk_t) ext2fs_div64_ceil(
                ext2fs_blocks_count(super) - super->s_first_data_block,
                EXT2_BLOCKS_PER_GROUP(super));
        if (fs->group_desc_count == 0) {
                retval = EXT2_ET_TOOSMALL;

The div64_ceil returns > 2^32 (2^33, actually), and the cast to blk_t
(which should be dgrp_t?) turns that into a 0.

Trying it with "-O bigalloc" (which should be automatic at this size,
I think?) just goes away for a very long time, I'm not sure what it's
thinking about, or if it's in a loop somewhere (looking now).

I also came across this in ext2fs_initialize() in the bigalloc case:

                if (super->s_clusters_per_group > EXT2_MAX_CLUSTERS_PER_GROUP(super))
                        super->s_blocks_per_group = EXT2_MAX_CLUSTERS_PER_GROUP(super);
                super->s_blocks_per_group = EXT2FS_C2B(fs,
                                       super->s_clusters_per_group);

which seems to be incorrect; I doubt that you meant to set s_blocks_per_group under
a conditional, and then unconditionally set it immediately after.  I assume
that should be super->s_clusters_per_group in the first case?  I'll send a patch,
assuming so.

TBH I've kind of lost the thread on bigalloc, so just putting this out there for
now while I look into things a bit more.

-Eric
