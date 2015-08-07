From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/19] ext2fs: Implement block moving in libext2fs
Date: Fri, 7 Aug 2015 08:55:14 -0700
Message-ID: <20150807155514.GF10037@birch.djwong.org>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
 <1438944689-24562-9-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38730 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbbHGPzo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2015 11:55:44 -0400
Content-Disposition: inline
In-Reply-To: <1438944689-24562-9-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 07, 2015 at 12:51:18PM +0200, Jan Kara wrote:
> From: Jan Kara <jack@suse.cz>
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

<snip>

> diff --git a/lib/ext2fs/extent_map.c b/lib/ext2fs/extent_map.c
> new file mode 100644
> index 000000000000..702172b24e2b
> --- /dev/null
> +++ b/lib/ext2fs/extent_map.c
> @@ -0,0 +1,233 @@
> +/*
> + * extent.c --- ext2 extent mapping abstraction
> + *
> + * This abstraction is used to provide a compact way of representing a
> + * translation table, for moving multiple contiguous ranges (extents)
> + * of blocks or inodes.
> + *
> + * Copyright (C) 1997, 1998 by Theodore Ts'o and
> + * 	PowerQuest, Inc.
> + *
> + * Copyright (C) 1999, 2000 by Theosore Ts'o

Ted should probably weigh in on this amazing coincidence in contributors :)
but this I suspect is a spelling error waiting a long time to be fixed.

> + *
> + * %Begin-Header%

<snip>

> diff --git a/lib/ext2fs/move.h b/lib/ext2fs/move.h
> new file mode 100644
> index 000000000000..8d66aa039ec0
> --- /dev/null
> +++ b/lib/ext2fs/move.h
> @@ -0,0 +1,23 @@
> +#ifndef _EXT2FS_MOVE_H
> +#define _EXT2FS_MOVE_H
> +
> +#include "ext2fs.h"
> +
> +typedef struct _ext2_map_extent *ext2_map_extent;
> +
> +/* extent_map.c */
> +extern int ext2fs_extent_table_empty(ext2_map_extent extent);
> +extern errcode_t ext2fs_create_extent_table(ext2_map_extent *ret_extent,
> +					    __u64 size);
> +extern void ext2fs_free_extent_table(ext2_map_extent extent);
> +extern errcode_t ext2fs_add_extent_entry(ext2_map_extent extent,
> +					 __u64 old_loc, __u64 new_loc);
> +extern __u64 ext2fs_extent_translate(ext2_map_extent extent, __u64 old_loc);
> +extern errcode_t ext2fs_iterate_extent(ext2_map_extent extent, __u64 *old_loc,
> +				       __u64 *new_loc, __u64 *size);
> +
> +/* move.c */
> +errcode_t ext2fs_move_blocks(ext2_filsys fs, ext2fs_block_bitmap move_map,
> +			     ext2fs_block_bitmap reuse_map);
> +
> +#endif

Hmm... are these functions intended for use by client programs?  I'm accustomed
to looking in ext2fs.h for such functions.

--D

> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
