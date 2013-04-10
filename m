From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH] ext4: defragmentation code cleanup
Date: Wed, 10 Apr 2013 15:43:09 +0900
Message-ID: <516509FD.7060209@rs.jp.nec.com>
References: <1365520559-6622-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:43588 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3DJGte (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Apr 2013 02:49:34 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r3A6nWVD018380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Apr 2013 15:49:32 +0900 (JST)
In-Reply-To: <1365520559-6622-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

(2013/04/10 0:15), Dmitry Monakhov wrote:
> - grab_cache_page_write_begin() may not wait on page's writeback since
>    (1d1d1a767206). But it is still reasonable to wait on page's writeback
>    here in order to be on the safe side.
> 
> - Fix miss typo: pass 'length' instead of 'end' to __block_write_begin()
>    https://bugzilla.kernel.org/show_bug.cgi?id=56241

Looks good to me, thanks.

Reviewed-by: Akira Fujita <a-fujita.rs.jp.nec.com>
 
> TESTCASE: git://oss.sgi.com/xfs/cmds/xfstests.git
> MKFS_OPTIONS="-b1024" ; ./check ext4/304
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>   fs/ext4/move_extent.c |   11 +++++++++--
>   1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 33e1c08..58b33e9 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -737,6 +737,7 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
>   		donor_off += dext_alen;
>   		orig_off += dext_alen;
>   
> +		BUG_ON(replaced_count > count);
>   		/* Already moved the expected blocks */
>   		if (replaced_count >= count)
>   			break;
> @@ -814,7 +815,13 @@ mext_page_double_lock(struct inode *inode1, struct inode *inode2,
>   		page_cache_release(page[0]);
>   		return -ENOMEM;
>   	}
> -
> +	/*
> +	 * grab_cache_page_write_begin() may not wait on page's writeback if
> +	 * BDI not demand that. But it is reasonable to be very conservative
> +	 * here and explicitly wait on page's writeback
> +	 */
> +	wait_on_page_writeback(page[0]);
> +	wait_on_page_writeback(page[1]);
>   	if (inode1 > inode2) {
>   		struct page *tmp;
>   		tmp = page[0];
> @@ -1033,7 +1040,7 @@ data_copy:
>   	}
>   	/* Perform all necessary steps similar write_begin()/write_end()
>   	 * but keeping in mind that i_size will not change */
> -	*err = __block_write_begin(pagep[0], from, from + replaced_size,
> +	*err = __block_write_begin(pagep[0], from, replaced_size,
>   				   ext4_get_block);
>   	if (!*err)
>   		*err = block_commit_write(pagep[0], from, from + replaced_size);
> 


