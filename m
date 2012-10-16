From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: add a variable to record the value of map->m_flags
 in tracepoint
Date: Tue, 16 Oct 2012 12:41:33 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210161235530.20184@dhcp-1-104.brq.redhat.com>
References: <1350372294-17939-1-git-send-email-wenqing.lz@taobao.com> <1350372294-17939-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab2JPKlm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Oct 2012 06:41:42 -0400
In-Reply-To: <1350372294-17939-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 16 Oct 2012, Zheng Liu wrote:

> Date: Tue, 16 Oct 2012 15:24:54 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: linux-ext4@vger.kernel.org
> Cc: Zheng Liu <wenqing.lz@taobao.com>
> Subject: [PATCH 2/2] ext4: add a variable to record the value of map->m_flags
>     in tracepoint
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When we use trace_ext4_ext/ind_map_blocks_exit, we will print the value of
> map->m_flags in order that we can understand what currently status is.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/extents.c           |  2 +-
>  fs/ext4/indirect.c          |  4 ++--
>  include/trace/events/ext4.h | 18 ++++++++++--------
>  3 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 4ecc210..204bafa 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4250,7 +4250,7 @@ out2:
>  	}
>  
>  	trace_ext4_ext_map_blocks_exit(inode, map->m_lblk,
> -		newblock, map->m_len, err ? err : allocated);
> +		newblock, map->m_len, map->m_flags, err ? err : allocated);
>  
>  	return err ? err : allocated;
>  }
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 792e388..a22d296 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -755,8 +755,8 @@ cleanup:
>  		partial--;
>  	}
>  out:
> -	trace_ext4_ind_map_blocks_exit(inode, map->m_lblk,
> -				map->m_pblk, map->m_len, err);
> +	trace_ext4_ind_map_blocks_exit(inode, map->m_lblk, map->m_pblk,
> +					map->m_len, map->m_flags, err);
>  	return err;
>  }
>  
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 66d78dc..680c249b 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -1520,9 +1520,9 @@ DEFINE_EVENT(ext4__map_blocks_enter, ext4_ind_map_blocks_enter,
>  
>  DECLARE_EVENT_CLASS(ext4__map_blocks_exit,
>  	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
> -		 ext4_fsblk_t pblk, unsigned int len, int ret),
> +		 ext4_fsblk_t pblk, unsigned int len, int flags, int ret),

What about the whole struct ext4_map_blocks instead of m_lblk, m_len
and m_flags separately ?

>  
> -	TP_ARGS(inode, lblk, pblk, len, ret),
> +	TP_ARGS(inode, lblk, pblk, len, flags, ret),
>  
>  	TP_STRUCT__entry(
>  		__field(	dev_t,		dev		)
> @@ -1530,6 +1530,7 @@ DECLARE_EVENT_CLASS(ext4__map_blocks_exit,
>  		__field(	ext4_fsblk_t,	pblk		)
>  		__field(	ext4_lblk_t,	lblk		)
>  		__field(	unsigned int,	len		)
> +		__field(	int,		flags		)

map->m_flags is unsigned int.

>  		__field(	int,		ret		)
>  	),
>  
> @@ -1539,28 +1540,29 @@ DECLARE_EVENT_CLASS(ext4__map_blocks_exit,
>  		__entry->pblk	= pblk;
>  		__entry->lblk	= lblk;
>  		__entry->len	= len;
> +		__entry->flags	= flags;
>  		__entry->ret	= ret;
>  	),
>  
> -	TP_printk("dev %d,%d ino %lu lblk %u pblk %llu len %u ret %d",
> +	TP_printk("dev %d,%d ino %lu lblk %u pblk %llu len %u flags %x ret %d",

It's better to be consistent. If we agree that using %x for flags is
better format then be it, but change the first patch as well.

Thanks!
-Lukas

>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long) __entry->ino,
>  		  __entry->lblk, __entry->pblk,
> -		  __entry->len, __entry->ret)
> +		  __entry->len, __entry->flags, __entry->ret)
>  );
>  
>  DEFINE_EVENT(ext4__map_blocks_exit, ext4_ext_map_blocks_exit,
>  	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
> -		 ext4_fsblk_t pblk, unsigned len, int ret),
> +		 ext4_fsblk_t pblk, unsigned len, int flags, int ret),
>  
> -	TP_ARGS(inode, lblk, pblk, len, ret)
> +	TP_ARGS(inode, lblk, pblk, len, flags, ret)
>  );
>  
>  DEFINE_EVENT(ext4__map_blocks_exit, ext4_ind_map_blocks_exit,
>  	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
> -		 ext4_fsblk_t pblk, unsigned len, int ret),
> +		 ext4_fsblk_t pblk, unsigned len, int flags, int ret),
>  
> -	TP_ARGS(inode, lblk, pblk, len, ret)
> +	TP_ARGS(inode, lblk, pblk, len, flags, ret)
>  );
>  
>  TRACE_EVENT(ext4_ext_load_extent,
> 
