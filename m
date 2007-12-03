From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Check for the correct error return from ext4_ext_get_blocks
Date: Mon, 03 Dec 2007 09:37:37 -0600
Message-ID: <475422C1.2030906@redhat.com>
References: <1196677650-10479-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbXLCPyE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Dec 2007 10:54:04 -0500
In-Reply-To: <1196677650-10479-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> ext4_ext_get_blocks returns negative values on error. We should
> check for  <= 0
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index a2475d4..ce57245 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2558,8 +2558,8 @@ retry:
>  		ret = ext4_ext_get_blocks(handle, inode, block,
>  					  max_blocks, &map_bh,
>  					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
> -		WARN_ON(!ret);
> -		if (!ret) {
> +		WARN_ON(ret <= 0);
> +		if (ret <= 0) {
>  			ext4_error(inode->i_sb, "ext4_fallocate",
>  				   "ext4_ext_get_blocks returned 0! inode#%lu"
>  				   ", block=%llu, max_blocks=%llu",

Need to change the "returned 0!" part of the error to "returned %d!"
then too, I guess?

-Eric
