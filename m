From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC PATCH -v2] ext4: request for blocks with ar.excepted_group
 = -1
Date: Wed, 27 Aug 2008 17:30:03 +0900
Message-ID: <48B5108B.9020809@rs.jp.nec.com>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219663233-21849-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219663233-21849-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219663233-21849-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219663233-21849-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219663233-21849-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62783 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYH0Ibk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 04:31:40 -0400
In-Reply-To: <1219663233-21849-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Aneesh,

Thank you for your patch.
I will merge this change into the next version of defrag patches.

Regards,
Akira Fujita

Aneesh Kumar K.V Wrote:
> Otherwise we skip group 0 during block allocation.
> This cause ENOSPC even if we have free blocks in
> group 0. This should be merged with defrag. The
> expected_group changes are introduced by defrag patches.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/balloc.c  |    1 +
>  fs/ext4/extents.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 4ebe3b6..1a068f5 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -2034,6 +2034,7 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
>  	ar.goal = goal;
>  	ar.len = *count;
>  	ar.logical = iblock;
> +	ar.excepted_group = -1;
>  
>  	if (S_ISREG(inode->i_mode) && !(flags & EXT4_META_BLOCK))
>  		/* enable in-core preallocation for data block allocation */
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bf612a7..268e96d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2879,6 +2879,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  	ar.goal = ext4_ext_find_goal(inode, path, iblock);
>  	ar.logical = iblock;
>  	ar.len = allocated;
> +	ar.excepted_group = -1;
>  	if (S_ISREG(inode->i_mode))
>  		ar.flags = EXT4_MB_HINT_DATA;
>  	else

-- 
Akira Fujita <a-fujita@rs.jp.nec.com>

The First Fundamental Software Development Group,
Software Development Division,
NEC Software Tohoku, Ltd.
