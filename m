From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: don't cache out of order extents
Date: Thu, 17 Oct 2013 15:44:35 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310171534440.3212@localhost.localdomain>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab3JQNol (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Oct 2013 09:44:41 -0400
In-Reply-To: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Oct 2013, Eryu Guan wrote:

> Date: Thu, 17 Oct 2013 17:27:53 +0800
> From: Eryu Guan <guaneryu@gmail.com>
> To: linux-ext4@vger.kernel.org
> Cc: Eryu Guan <guaneryu@gmail.com>, Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH] ext4: don't cache out of order extents
> 
> A corrupted ext4 may have out of order leaf extents, i.e.
> 
> extent: lblk 0--1023, len 1024, pblk 9217, flags: LEAF UNINIT
> extent: lblk 1000--2047, len 1024, pblk 10241, flags: LEAF UNINIT
>              ^^^^ overlap with previous extent
> 
> Reading such extent could hit BUG_ON() in ext4_es_cache_extent().
> 
> 	BUG_ON(end < lblk);
> 
> The problem is that __read_extent_tree_block() tries to cache holes as
> well but assumes 'lblk' is greater than 'prev' and passes underflowed
> length to ext4_es_cache_extent().
> 
> I hit this when fuzz testing ext4, and am able to reproduce it by
> modifying the on-disk extent by hand.
> 
> Ran xfstests on patched ext4 and no regression.

So what will happen with the file system with this patch when
presented with such corruption ?

It seems to me that ext4_es_cache_extent() will happily skip this
extent because it will find that this particular offset is already
in the tree. Hence we'll have a gap in the status tree which really
should not be there and I suspect that something bad will happen.

I think that we should deal with this corruption immediately when we
spot it there, not just hide it.

Thanks!
-Lukas

> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  fs/ext4/extents.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 54d52af..c9ebcb9 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -503,7 +503,7 @@ __read_extent_tree_block(const char *function, unsigned int line,
>  			ext4_lblk_t lblk = le32_to_cpu(ex->ee_block);
>  			int len = ext4_ext_get_actual_len(ex);
>  
> -			if (prev && (prev != lblk))
> +			if (prev && (prev < lblk))
>  				ext4_es_cache_extent(inode, prev,
>  						     lblk - prev, ~0,
>  						     EXTENT_STATUS_HOLE);
> 
