From: Tao Ma <tm@tao.ma>
Subject: Re: [RFC PATCH V2 2/6] ext4: add a delayed extents tree in inode
 info
Date: Thu, 29 Sep 2011 14:56:38 +0800
Message-ID: <4E8416A6.3070302@tao.ma>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com> <1317272926-13303-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, jeff.liu@oracle.com,
	achender@linux.vnet.ibm.com, adityakali@google.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:46755 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751840Ab1I2G4r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 02:56:47 -0400
In-Reply-To: <1317272926-13303-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Yongqiang,
On 09/29/2011 01:08 PM, Yongqiang Yang wrote:
> This patch adds a delayed extents tree in inode info, so that
> delayed extents can be look up quickly.  Without the tree
> delayed extents are identified by looking up page cache.
> 
> With the tree, FIEMAP, SEEK_HOLE/DATA, bigalloc and writeout
> path can be optimized a lot.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/ext4.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index ccfa81f..d3c6b97 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -760,6 +760,8 @@ struct ext4_ext_cache {
>  	__u32		ec_len; /* must be 32bit to return holes */
>  };
>  
> +#include "delayed_extents.h"
> +
>  /*
>   * fourth extended file system inode data in memory
>   */
> @@ -837,6 +839,9 @@ struct ext4_inode_info {
>  	struct list_head i_prealloc_list;
>  	spinlock_t i_prealloc_lock;
>  
> +	/* delayed extents */
> +	struct ext4_de_tree i_de_tree;
> +
Can we integrate this patch with patch 1/6?
I think it would be beneficial for the reviewer to see both the
definition of the structure and the place you put it.

Thanks
Tao
>  	/* ialloc */
>  	ext4_group_t	i_last_alloc_group;
>  

