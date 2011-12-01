From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/6] ext4: remove code related to punching hole from ext4_ext_insert_extent
Date: Thu, 01 Dec 2011 13:55:37 -0700
Message-ID: <4ED7E9C9.2020307@linux.vnet.ibm.com>
References: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com> <1321495405-9583-4-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58692 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab1LAU40 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Dec 2011 15:56:26 -0500
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Thu, 1 Dec 2011 15:56:25 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pB1KteeM327130
	for <linux-ext4@vger.kernel.org>; Thu, 1 Dec 2011 15:55:44 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pB1KtdSf022189
	for <linux-ext4@vger.kernel.org>; Thu, 1 Dec 2011 18:55:39 -0200
In-Reply-To: <1321495405-9583-4-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/16/2011 07:03 PM, Yongqiang Yang wrote:
> Punch hole should never call ext4_ext_insert_extent, so this patch
> removes code related to it from ext4_ext_insert_extent.
>
> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
> ---
>   fs/ext4/extents.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 6888d1a..720070d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1737,8 +1737,6 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
>   	 * There is no free space in the found leaf.
>   	 * We're gonna add a new leaf in the tree.
>   	 */
> -	if (flag&  EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
> -		flags = EXT4_MB_USE_ROOT_BLOCKS;
>   	err = ext4_ext_create_new_leaf(handle, inode, flags, path, newext);
>   	if (err)
>   		goto cleanup;

Hi Yongqiang,

Actually I believe it does end up inserting an extent if an extent gets 
split. For example, we punch a hole in the middle of an extent, so we 
first split the extent into three pieces, and remove the middle piece.

Because inserting the extra extents can require extra blocks, the 
operation may temporarily consume blocks. The problem that this causes 
is that if the file system is really full, it can fail with ENOSPC, even 
though punch hole is an operation that is supposed to free blocks.  The 
above EXT4_MB_USE_ROOT_BLOCKS flag was put in so that when we punch 
holes, we can borrow reserved blocks to complete the operation to avoid 
the ENOSPC problem.  I had a script to catch this and added to xfstests 
(test 256). So unless there was a change somewhere that I missed, it 
does not make sense to me to take it out at this point.

Allison Henderson

