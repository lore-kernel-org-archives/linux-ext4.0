From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix fallocate error path.
Date: Tue, 04 Mar 2008 16:44:38 -0800
Message-ID: <1204677879.3605.4.camel@localhost.localdomain>
References: <1204634448-16402-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59229 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029AbYCEApK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Mar 2008 19:45:10 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m250j9WY000600
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 19:45:09 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m250j9eq231272
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 19:45:10 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m250j9n3009737
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 19:45:09 -0500
In-Reply-To: <1204634448-16402-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-03-04 at 18:10 +0530, Aneesh Kumar K.V wrote:
> Put the old extent details back if we fail to split the
> uninitialized extent.
> 
Reviewed, add to the patch queue.

Mingming
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |   26 ++++++++++++++++++++++++--
>  1 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 39d5315..d315cc1 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2152,7 +2152,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  						ext4_lblk_t iblock,
>  						unsigned long max_blocks)
>  {
> -	struct ext4_extent *ex, newex;
> +	struct ext4_extent *ex, newex, orig_ex;
>  	struct ext4_extent *ex1 = NULL;
>  	struct ext4_extent *ex2 = NULL;
>  	struct ext4_extent *ex3 = NULL;
> @@ -2171,6 +2171,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	allocated = ee_len - (iblock - ee_block);
>  	newblock = iblock - ee_block + ext_pblock(ex);
>  	ex2 = ex;
> +	orig_ex.ee_block = ex->ee_block;
> +	orig_ex.ee_len   = cpu_to_le16(ee_len);
> +	ext4_ext_store_pblock(&orig_ex, ext_pblock(ex));
> 
>  	err = ext4_ext_get_access(handle, inode, path + depth);
>  	if (err)
> @@ -2199,13 +2202,25 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
>  		ext4_ext_mark_uninitialized(ex3);
>  		err = ext4_ext_insert_extent(handle, inode, path, ex3);
> -		if (err)
> +		if (err) {
> +			ex->ee_block = orig_ex.ee_block;
> +			ex->ee_len   = orig_ex.ee_len;
> +			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
> +			ext4_ext_mark_uninitialized(ex);
> +			ext4_ext_dirty(handle, inode, path + depth);
>  			goto out;
> +		}
>  		/*
>  		 * The depth, and hence eh & ex might change
>  		 * as part of the insert above.
>  		 */
>  		newdepth = ext_depth(inode);
> +		/*
> +		 * update the extent length after successfull insert of the
> +		 * split extent
> +		 */
> +		orig_ex.ee_len = cpu_to_le16(ee_len -
> +						ext4_ext_get_actual_len(ex3));
>  		if (newdepth != depth) {
>  			depth = newdepth;
>  			ext4_ext_drop_refs(path);
> @@ -2280,6 +2295,13 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  	goto out;
>  insert:
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex);
> +	if (err) {
> +		ex->ee_block = orig_ex.ee_block;
> +		ex->ee_len   = orig_ex.ee_len;
> +		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
> +		ext4_ext_mark_uninitialized(ex);
> +		ext4_ext_dirty(handle, inode, path + depth);
> +	}
>  out:
>  	return err ? err : allocated;
>  }

