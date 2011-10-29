From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: migrate cleanup
Date: Sat, 29 Oct 2011 08:31:38 -0400
Message-ID: <20111029123138.GB19536@thunk.org>
References: <1316266379-18737-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40646 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933776Ab1J2SMk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Oct 2011 14:12:40 -0400
Content-Disposition: inline
In-Reply-To: <1316266379-18737-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 17, 2011 at 05:32:57PM +0400, Dmitry Monakhov wrote:
> This patch cleanup code a bit, actual logic not changed
> - Move current block pointer to migrate_structure, let's all
>   walk info will be in one structure.
> - Get rid of usless null ind-block ptr checks, caller already
>   does that check.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, with one fixup:

> @@ -211,17 +184,15 @@ static int update_tind_extent_range(handle_t *handle, struct inode *inode,
>  	i_data = (__le32 *)bh->b_data;
>  	for (i = 0; i < max_entries; i++) {
>  		if (i_data[i]) {
> -			retval = update_dind_extent_range(handle, inode,
> -						le32_to_cpu(i_data[i]),
> -						&blk_count, lb);
> +			retval = update_ind_extent_range(handle, inode,
> +						le32_to_cpu(i_data[i]), lb);

Surely this should remain a call to update_dind_extent_range(); I
assume it was a cut-and-paste editing error.

					- Ted
