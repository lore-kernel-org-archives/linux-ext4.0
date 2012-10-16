From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2 v2] ext4: add a variable to record the value of
 map->m_flags in tracepoint
Date: Tue, 16 Oct 2012 14:44:06 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210161443440.6908@dhcp-1-104.brq.redhat.com>
References: <1350390934-3101-1-git-send-email-wenqing.lz@taobao.com> <1350390934-3101-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2JPMoQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Oct 2012 08:44:16 -0400
In-Reply-To: <1350390934-3101-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 16 Oct 2012, Zheng Liu wrote:

> Date: Tue, 16 Oct 2012 20:35:34 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: linux-ext4@vger.kernel.org
> Cc: Lukas Czerner <lczerner@redhat.com>, Zheng Liu <wenqing.lz@taobao.com>
> Subject: [PATCH 2/2 v2] ext4: add a variable to record the value of
>     map->m_flags in tracepoint
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When we use trace_ext4_ext/ind_map_blocks_exit, we will print the value of
> map->m_flags in order that we can understand what currently status is.
> 
> CC: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Looks good, thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> ---
> v2 <- v1:
> 	pass the whole ext4_map_blocks instead of lblk, pblk, flags and len
> 	change type of 'flags' from 'int' to 'unsigned int'
> 
>  fs/ext4/extents.c           |  3 +--
>  fs/ext4/indirect.c          |  3 +--
>  include/trace/events/ext4.h | 27 +++++++++++++--------------
>  3 files changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 4ecc210..a29b3f8 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4249,8 +4249,7 @@ out2:
>  		kfree(path);
>  	}
>  
> -	trace_ext4_ext_map_blocks_exit(inode, map->m_lblk,
> -		newblock, map->m_len, err ? err : allocated);
> +	trace_ext4_ext_map_blocks_exit(inode, map, err ? err : allocated);
>  
>  	return err ? err : allocated;
>  }
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 792e388..292337f 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -755,8 +755,7 @@ cleanup:
>  		partial--;
>  	}
>  out:
> -	trace_ext4_ind_map_blocks_exit(inode, map->m_lblk,
> -				map->m_pblk, map->m_len, err);
> +	trace_ext4_ind_map_blocks_exit(inode, map, err);
>  	return err;
>  }
>  
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 25914e3..d2a125a 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -1519,10 +1519,9 @@ DEFINE_EVENT(ext4__map_blocks_enter, ext4_ind_map_blocks_enter,
>  );
>  
>  DECLARE_EVENT_CLASS(ext4__map_blocks_exit,
> -	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
> -		 ext4_fsblk_t pblk, unsigned int len, int ret),
> +	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map, int ret),
>  
> -	TP_ARGS(inode, lblk, pblk, len, ret),
> +	TP_ARGS(inode, map, ret),
>  
>  	TP_STRUCT__entry(
>  		__field(	dev_t,		dev		)
> @@ -1530,37 +1529,37 @@ DECLARE_EVENT_CLASS(ext4__map_blocks_exit,
>  		__field(	ext4_fsblk_t,	pblk		)
>  		__field(	ext4_lblk_t,	lblk		)
>  		__field(	unsigned int,	len		)
> +		__field(	unsigned int,	flags		)
>  		__field(	int,		ret		)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->dev    = inode->i_sb->s_dev;
>  		__entry->ino    = inode->i_ino;
> -		__entry->pblk	= pblk;
> -		__entry->lblk	= lblk;
> -		__entry->len	= len;
> +		__entry->pblk	= map->m_pblk;
> +		__entry->lblk	= map->m_lblk;
> +		__entry->len	= map->m_len;
> +		__entry->flags	= map->m_flags;
>  		__entry->ret	= ret;
>  	),
>  
> -	TP_printk("dev %d,%d ino %lu lblk %u pblk %llu len %u ret %d",
> +	TP_printk("dev %d,%d ino %lu lblk %u pblk %llu len %u flags %x ret %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long) __entry->ino,
>  		  __entry->lblk, __entry->pblk,
> -		  __entry->len, __entry->ret)
> +		  __entry->len, __entry->flags, __entry->ret)
>  );
>  
>  DEFINE_EVENT(ext4__map_blocks_exit, ext4_ext_map_blocks_exit,
> -	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
> -		 ext4_fsblk_t pblk, unsigned len, int ret),
> +	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map, int ret),
>  
> -	TP_ARGS(inode, lblk, pblk, len, ret)
> +	TP_ARGS(inode, map, ret)
>  );
>  
>  DEFINE_EVENT(ext4__map_blocks_exit, ext4_ind_map_blocks_exit,
> -	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
> -		 ext4_fsblk_t pblk, unsigned len, int ret),
> +	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map, int ret),
>  
> -	TP_ARGS(inode, lblk, pblk, len, ret)
> +	TP_ARGS(inode, map, ret)
>  );
>  
>  TRACE_EVENT(ext4_ext_load_extent,
> 
