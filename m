From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Tue, 01 Sep 2009 23:59:53 -0600
Message-ID: <20090902055953.GF4197@webber.adilger.int>
References: <4A9D9574.3010606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60396 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZIBF7p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 01:59:45 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n825xjxN013911
	for <linux-ext4@vger.kernel.org>; Tue, 1 Sep 2009 22:59:47 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPB00G00XZD0L00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 01 Sep 2009 22:59:45 -0700 (PDT)
In-reply-to: <4A9D9574.3010606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 01, 2009  16:43 -0500, Eric Sandeen wrote:
> ext2fs_open2() was only looking at s_blocks_count, and
> when it wrapped to a low number, it was failing the test of:
> 
>   fs->super->s_first_data_block >= fs->super->s_blocks_count
> 
> which made the superblock look corrupt.

Is this the source of the "e2fsck is finding bad checksums" problem?

> Patch is against the pu branch
> 
> Index: e2fsprogs/lib/ext2fs/openfs.c
> ===================================================================
> --- e2fsprogs.orig/lib/ext2fs/openfs.c
> +++ e2fsprogs/lib/ext2fs/openfs.c
> @@ -288,7 +288,7 @@ errcode_t ext2fs_open2(const char *name,
>  	    blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(fs->super) ||
>  	    fs->inode_blocks_per_group > EXT2_MAX_INODES_PER_GROUP(fs->super) ||
>             EXT2_DESC_PER_BLOCK(fs->super) == 0 ||
> -           fs->super->s_first_data_block >= fs->super->s_blocks_count) {
> +           fs->super->s_first_data_block >= ext2fs_blocks_count(fs->super)) {

I would strongly suggest to replace the declaration of "s_blocks_count"
with "s_blocks_count_lo" (and similar for every other split value), so
that we catch all instances of this type of bug.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

