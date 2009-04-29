From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V4 2/2] ext4: Use -1 as the fake block number for delayed
 new buffer_head
Date: Wed, 29 Apr 2009 08:59:44 -0500
Message-ID: <49F85D50.2040307@redhat.com>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240980441-8105-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34832 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbZD2N74 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 09:59:56 -0400
In-Reply-To: <1240980441-8105-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Block number '0' should not be used as the fake block number for
> the delayed new buffer. This will result in vfs calling umap_underlying_metadata for
> block number '0'. So  use -1 instead.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> ---
>  fs/ext4/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 12dcfab..c7c2156 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2318,7 +2318,7 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  			/* not enough space to reserve */
>  			return ret;
>  
> -		map_bh(bh_result, inode->i_sb, 0);
> +		map_bh(bh_result, inode->i_sb, -1);
>  		set_buffer_new(bh_result);
>  		set_buffer_delay(bh_result);
>  	} else if (ret > 0) {

this seems fine too, thanks.

-Eric
