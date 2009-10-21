From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: flush delalloc blocks when space is low
Date: Tue, 20 Oct 2009 21:37:48 -0500
Message-ID: <4ADE73FC.1080807@redhat.com>
References: <4ADE24CF.1080906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZJUChs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2009 22:37:48 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9L2brLV013664
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 22:37:53 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n9L2bnwT027825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 22:37:52 -0400
In-Reply-To: <4ADE24CF.1080906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Creating many small files in rapid succession on a small
> filesystem can lead to spurious ENOSPC; on a 104MB filesystem:
> 
> for i in `seq 1 22500`; do
>    echo -n > $SCRATCH_MNT/$i
>    echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
> done
> 
> leads to ENOSPC even though after a sync, 40% of the fs is free
> again.
> 
> This is because we reserve worst-case metadata for delalloc writes,
> and when data is allocated that worst-case reservation was not
> needed.
> 
> I've added 2 flushers here:
> 
> * when free space is low compared to dirty blocks, do an async flush
> * when we get a hard ENOSPC, do a sync flush before retry
> 
> This resolves the testcase for me.

argh, but fails xfstests 083 at least:

# Exercise filesystem full behaviour - run numerous fsstress
# processes in write mode on a small filesystem.  NB: delayed
# allocate flushing is quite deadlock prone at the filesystem
# full boundary due to the fact that we will retry allocation
# several times after flushing, before giving back ENOSPC.

and indeed I deadlock ;)  so don't merge this yet!

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 1d04189..63519fc 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -605,6 +605,17 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
>  */
> int ext4_should_retry_alloc(struct super_block *sb, int *retries)
> {
> +    /* try a sync to flush delalloc space & free resvd metadata */
> +    if (test_opt(sb, DELALLOC) &&
> +        *retries == 0 &&
> +        !ext4_has_free_blocks(EXT4_SB(sb), 1)) {
> +        down_read(&sb->s_umount);
> +        sync_inodes_sb(sb);
> +        up_read(&sb->s_umount);
> +        (*retries)++;
> +        return 1;
> +    }
> +
>     if (!ext4_has_free_blocks(EXT4_SB(sb), 1) ||
>         (*retries)++ > 3 ||
>         !EXT4_SB(sb)->s_journal)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5c5bc5d..27c8b9b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3024,11 +3024,18 @@ static int ext4_nonda_switch(struct super_block 
> *sb)
>     if (2 * free_blocks < 3 * dirty_blocks ||
>         free_blocks < (dirty_blocks + EXT4_FREEBLOCKS_WATERMARK)) {
>         /*
> -         * free block count is less that 150% of dirty blocks
> -         * or free blocks is less that watermark
> +         * free block count is less than 150% of dirty blocks
> +         * or free blocks is less than watermark
>          */
>         return 1;
>     }
> +    /*
> +     * Even if we don't switch but are nearing capacity,
> +     * start pushing delalloc when 1/2 of free blocks are dirty.
> +     */
> +    if (free_blocks < 2 * dirty_blocks)
> +        writeback_inodes_sb(sb);
> +
>     return 0;
> }
> 
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

