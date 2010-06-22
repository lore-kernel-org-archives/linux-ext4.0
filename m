From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: problems with large group descriptors and 64bit
Date: Tue, 22 Jun 2010 17:24:34 -0600
Message-ID: <C14E4BEF-0064-4E36-975F-B74272E246B1@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:58759 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab0FVXYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 19:24:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was just looking through the 64-bit patches that have landed on master, and I see some obvious bugs with the handling of large group descriptors.  In particular, there are some places that still assume they know the group descriptor size, even in the "opaque" routines added by Eric in commit efe0b401465a3ee836180614b5b435acbb84fc27.

lib/ext2fs/open.c assumes ext2_group_desc in a couple of places, instead of calling ext2fs_group_desc() to get the right offset:
#ifdef WORDS_BIGENDIAN  
                gdp = (struct ext2_group_desc *) dest;
                for (j=0; j < groups_per_block*first_meta_bg; j++)
                        ext2fs_swap_group_desc2(fs, gdp++);
#endif


lib/ext2fs/blknum.c assumes 64BIT means ext4_group_desc, not s_desc_size:
struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
                                          struct opaque_ext2_group_desc *gdp,
                                          dgrp_t group)
{               
        if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT)
                return (struct ext2_group_desc *)
                        ((struct ext4_group_desc *) gdp + group);
        else
                return (struct ext2_group_desc *) gdp + group;
}




Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

