From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: print 'flags' in
 trace_ext4_ext_handle_uninitialized_extents
Date: Tue, 16 Oct 2012 12:34:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210161231580.20184@dhcp-1-104.brq.redhat.com>
References: <1350372294-17939-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab2JPKeL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Oct 2012 06:34:11 -0400
In-Reply-To: <1350372294-17939-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 16 Oct 2012, Zheng Liu wrote:

> Date: Tue, 16 Oct 2012 15:24:53 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: linux-ext4@vger.kernel.org
> Cc: Zheng Liu <wenqing.lz@taobao.com>
> Subject: [PATCH 1/2] ext4: print 'flags' in
>     trace_ext4_ext_handle_uninitialized_extents
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In trace_ext4_ext_handle_uninitialized_extents we don't care about the value of
> map->m_flags because this value is probably 0, and we prefer to get the value of
> flags because we can know how to handle this extent in this function.

Looks good, thanks.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/extents.c           | 4 ++--
>  include/trace/events/ext4.h | 8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 1c94cca..4ecc210 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3628,8 +3628,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
>  		  flags, allocated);
>  	ext4_ext_show_leaf(inode, path);
>  
> -	trace_ext4_ext_handle_uninitialized_extents(inode, map, allocated,
> -						    newblock);
> +	trace_ext4_ext_handle_uninitialized_extents(inode, map, flags,
> +						    allocated, newblock);
>  
>  	/* get_block() before submit the IO, split the extent */
>  	if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index d49b285..66d78dc 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -1680,10 +1680,10 @@ DEFINE_EVENT(ext4__trim, ext4_trim_all_free,
>  );
>  
>  TRACE_EVENT(ext4_ext_handle_uninitialized_extents,
> -	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map,
> +	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map, int flags,
>  		 unsigned int allocated, ext4_fsblk_t newblock),
>  
> -	TP_ARGS(inode, map, allocated, newblock),
> +	TP_ARGS(inode, map, flags, allocated, newblock),
>  
>  	TP_STRUCT__entry(
>  		__field(	dev_t,		dev		)
> @@ -1699,7 +1699,7 @@ TRACE_EVENT(ext4_ext_handle_uninitialized_extents,
>  	TP_fast_assign(
>  		__entry->dev		= inode->i_sb->s_dev;
>  		__entry->ino		= inode->i_ino;
> -		__entry->flags		= map->m_flags;
> +		__entry->flags		= flags;
>  		__entry->lblk		= map->m_lblk;
>  		__entry->pblk		= map->m_pblk;
>  		__entry->len		= map->m_len;
> @@ -1707,7 +1707,7 @@ TRACE_EVENT(ext4_ext_handle_uninitialized_extents,
>  		__entry->newblk		= newblock;
>  	),
>  
> -	TP_printk("dev %d,%d ino %lu m_lblk %u m_pblk %llu m_len %u flags %d"
> +	TP_printk("dev %d,%d ino %lu m_lblk %u m_pblk %llu m_len %u flags %d "
>  		  "allocated %d newblock %llu",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long) __entry->ino,
> 
