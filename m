From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 3/5] ext4: add warning to
 ext4_convert_unwritten_extents_endio
Date: Mon, 4 Mar 2013 22:00:00 +0800
Message-ID: <20130304140000.GA11871@gmail.com>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
 <1361808463-25471-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:44404 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab3CDNo4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2013 08:44:56 -0500
Received: by mail-da0-f44.google.com with SMTP id z20so2565443dae.3
        for <linux-ext4@vger.kernel.org>; Mon, 04 Mar 2013 05:44:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1361808463-25471-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2013 at 08:07:41PM +0400, Dmitry Monakhov wrote:
> Splitting extents inside endio is bad thing, but unfortunetly it is still
> possible. In fact we are pretty close to the moment when all related
> issues will be fixed. Let's warn developer if it still the case.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 1d37f2d..78c2a91 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3386,8 +3386,19 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
>  		"block %llu, max_blocks %u\n", inode->i_ino,
>  		  (unsigned long long)ee_block, ee_len);
>  
> -	/* If extent is larger than requested then split is required */
> +	/* If extent is larger than requested it is a clear sign that we still
> +	 * have some extent state machine issues left. So extent_split is still
> +	 * required.
> +	 * TODO: Once all related issues will be fixed this situation should be
> +	 * illegal.
> +	 */
>  	if (ee_block != map->m_lblk || ee_len > map->m_len) {
> +#ifdef EXT4_DEBUG
> +		ext4_warning("Inode (%ld) finished: extent logical block %llu,"
A parameter is missing.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 25c86aa..daf8bb9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3395,7 +3395,8 @@ static int
ext4_convert_unwritten_extents_endio(handle_t *handle,
         */
        if (ee_block != map->m_lblk || ee_len > map->m_len) {
 #ifdef EXT4_DEBUG
-               ext4_warning("Inode (%ld) finished: extent logical block %llu,"
+               ext4_warning(inode->i_sb,
+                            "Inode (%ld) finished: extent logical block %llu,"
                             " len %u; IO logical block %llu, len %u\n",
                             inode->i_ino, (unsigned long long)ee_block, ee_len,
                             (unsigned long long)map->m_lblk, map->m_len);

Regards,
                                                - Zheng

> +			     " len %u; IO logical block %llu, len %u\n",
> +			     inode->i_ino, (unsigned long long)ee_block, ee_len,
> +			     (unsigned long long)map->m_lblk, map->m_len);
> +#endif
>  		err = ext4_split_unwritten_extents(handle, inode, map, path,
>  						   EXT4_GET_BLOCKS_CONVERT);
>  		if (err < 0)
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
