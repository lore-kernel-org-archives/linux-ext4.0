From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [RFC][PATCH 7/8]ext4: move victim files for the target file (-f
 mode)
Date: Mon, 16 Jun 2008 10:42:50 +0800
Message-ID: <4855D32A.1020000@cn.fujitsu.com>
References: <483FE289.7050302@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <483FE289.7050302@rs.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Akira Fujita Wrote:
> ext4: online defrag-- Move victim files for the target file (-f mode)
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> Move victim files to make sufficient space and reallocates
> the contiguous blocks for the target file.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
> ---
>  fs/ext4/balloc.c       |   10 +-
>  fs/ext4/defrag.c       |  460 +++++++++++++++++++++++++++++++++++++++++++++---
>  fs/ext4/ext4.h         |   29 +++-
>  fs/ext4/ext4_extents.h |    5 +
>  fs/ext4/extents.c      |   54 +++++--
>  fs/ext4/ioctl.c        |    5 +-
>  fs/ext4/mballoc.c      |    5 +
>  fs/ext4/mballoc.h      |    1 +
>  8 files changed, 522 insertions(+), 47 deletions(-)
> 

...snip...

> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index d0b1301..88fd100 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -94,6 +94,11 @@ struct ext4_allocation_request {
>  	unsigned long len;
>  	/* flags. see above EXT4_MB_HINT_* */
>  	unsigned long flags;
> +	/*
> +	 * for ext4 online defrag:
> +	 * the block group which is excepted from allocation target
> +	 */
> +	long long excepted_group;
>  };

Why not ext4_group_t for excepted_group here?

> 
>  /*
> @@ -303,6 +308,9 @@ struct ext4_new_group_data {
>  #define EXT4_IOC_GROUP_INFO	_IOW('f', 11, struct ext4_group_data_info)
>  #define EXT4_IOC_FREE_BLOCKS_INFO	_IOW('f', 12, struct ext4_extents_info)
>  #define EXT4_IOC_EXTENTS_INFO		_IOW('f', 13, struct ext4_extents_info)
> +#define EXT4_IOC_RESERVE_BLOCK		_IOW('f', 14, struct ext4_extents_info)
> +#define EXT4_IOC_MOVE_VICTIM		_IOW('f', 15, struct ext4_extents_info)
> +#define EXT4_IOC_BLOCK_RELEASE		_IO('f', 8)
> 

...snip...

> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
> index bfe6add..1141ad5 100644
> --- a/fs/ext4/mballoc.h
> +++ b/fs/ext4/mballoc.h
> @@ -205,6 +205,7 @@ struct ext4_allocation_context {
>  	struct page *ac_buddy_page;
>  	struct ext4_prealloc_space *ac_pa;
>  	struct ext4_locality_group *ac_lg;
> +	long long ac_excepted_group;

ditto

>  };
> 
>  #define AC_STATUS_CONTINUE	1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

