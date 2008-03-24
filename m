From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext3: Return EIO if new block is allocated from system
	zone.
Date: Mon, 24 Mar 2008 16:32:51 -0600
Message-ID: <20080324223251.GL2691@webber.adilger.int>
References: <1206378298-10341-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45819 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYCXWdD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 18:33:03 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2OMX1Av016878
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 15:33:01 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JY900G01AKHU500@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 24 Mar 2008 15:33:01 -0700 (PDT)
In-reply-to: <1206378298-10341-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 24, 2008  22:34 +0530, Aneesh Kumar K.V wrote:
> If the block allocator gets blocks out of system zone ext3 calls
> ext3_error. But if the file system is mounted with errors=continue
> return with -EIO.
> 
> System zone is the block range mapping block bitmap, inode bitmap and inode
> table.

I don't understand this patch.  Surely it has nothing to do with the user,
and instead the code should re-try the allocation after marking the block
in-use in the bitmap?

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Mingming Cao <cmm@us.vnet.ibm.com>
> ---
>  fs/ext3/balloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index da0cb2c..6ce7f7d 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -1642,7 +1642,7 @@ allocated:
>  			    "Allocating block in system zone - "
>  			    "blocks from "E3FSBLK", length %lu",
>  			     ret_block, num);
> -		goto out;
> +		goto io_error;
>  	}

I think the problem here is that this "goto" is simply an in-effective
method of error handling.  The block HAS to be marked in-use in the
bitmap, or it will just continue to try and be allocated.  After marking
the block in-use there should be a "goto retry-alloc" instead of error.
To be honest, I thought in 2.6 this would invoke the block bitmap checking
code to revalidate the whole bitmap at this point and then retry the alloc.

In 2.4 this similar code looks like:

        if (tmp == le32_to_cpu(gdp->bg_block_bitmap) ||
            tmp == le32_to_cpu(gdp->bg_inode_bitmap) ||
            in_range (tmp, le32_to_cpu(gdp->bg_inode_table),
                      EXT3_SB(sb)->s_itb_per_group)) {
                ext3_error(sb, __FUNCTION__,
                           "Allocating block in system zone - block = %u", tmp);

                /* Note: This will potentially use up one of the handle's
                 * buffer credits.  Normally we have way too many credits,
                 * so that is OK.  In _very_ rare cases it might not be OK.
                 * We will trigger an assertion if we run out of credits,
                 * and we will have to do a full fsck of the filesystem -
                 * better than randomly corrupting filesystem metadata.
                 */
                ext3_set_bit(j, bh->b_data);
                goto repeat;
        }


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

