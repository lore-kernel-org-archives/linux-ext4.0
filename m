From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/10] ext4: ext4_inode_info diet
Date: Wed, 26 Sep 2012 14:28:16 +0200
Message-ID: <20120926122816.GB10145@quack.suse.cz>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
 <1348487060-19598-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab2IZM2f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 08:28:35 -0400
Content-Disposition: inline
In-Reply-To: <1348487060-19598-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-09-12 15:44:11, Dmitry Monakhov wrote:
> Generic inode has unused i_private pointer which may be used as cur_aio_dio
> storage.
> 
> TODO: If cur_aio_dio will be passed as an argument to get_block_t this allow
>       to have concurent AIO_DIO requests.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/ext4.h    |    5 +++--
>  fs/ext4/extents.c |    4 ++--
>  fs/ext4/inode.c   |    6 +++---
>  fs/ext4/super.c   |    1 -
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8b6902c..e59fbc5 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -912,8 +912,6 @@ struct ext4_inode_info {
>  	struct list_head i_completed_io_list;
>  	spinlock_t i_completed_io_lock;
>  	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
> -	/* current io_end structure for async DIO write*/
> -	ext4_io_end_t *cur_aio_dio;
>  	atomic_t i_aiodio_unwritten; /* Nr. of inflight conversions pending */
>  
>  	spinlock_t i_block_reservation_lock;
> @@ -929,6 +927,9 @@ struct ext4_inode_info {
>  	__u32 i_csum_seed;
>  };
>  
> +/* current io_end structure for async DIO write */
> +#define EXT4_CUR_AIO_DIO(inode) (inode)->i_private
  Inline functions are prefered over macros (due to type checks they
provide etc.). Also that will allow you to get rid of those type casts
when using EXT4_CUR_AIO_DIO(). So please make a pair of get/set inline
functions out of this macro.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
