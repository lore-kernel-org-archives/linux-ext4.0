From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 5/6] [64-bit] (blk_t) cast in ext2fs_new_block2()
Date: Mon, 4 May 2009 02:21:24 -0400
Message-ID: <20090504062124.GG9151@shell>
References: <15586.1241167637@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbZEDGVZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 02:21:25 -0400
Content-Disposition: inline
In-Reply-To: <15586.1241167637@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 04:47:17AM -0400, Nick Dokos wrote:
> Found by code inspection after similar gratuitous cast in
> ext2fs_get_free_blocks2() (first patch in this series).
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
> ---
>  lib/ext2fs/alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
> index 9f11673..a7c8860 100644
> --- a/lib/ext2fs/alloc.c
> +++ b/lib/ext2fs/alloc.c
> @@ -170,7 +170,7 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
>  					   (i - fs->super->s_first_data_block) /
>  					   EXT2_BLOCKS_PER_GROUP(fs->super));
>  
> -		if (!ext2fs_fast_test_block_bitmap2(map, (blk_t) i)) {
> +		if (!ext2fs_fast_test_block_bitmap2(map, i)) {
>  			*ret = i;
>  			return 0;
>  		}
> -- 
> 1.6.0.6
> 

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

-VAL
