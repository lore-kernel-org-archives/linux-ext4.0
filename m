From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4 v2] ext4: Do not discard group with BLOCK_UNINIT set
Date: Mon, 5 Mar 2012 13:41:54 +0100
Message-ID: <20120305124154.GG6643@quack.suse.cz>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
 <1330690318-22627-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab2CEMl4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 07:41:56 -0500
Content-Disposition: inline
In-Reply-To: <1330690318-22627-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 02-03-12 13:11:58, Lukas Czerner wrote:
> This commit is an optimization for FITRIM implementation. If the group
> has not been initialized yet (BLOCK_UNINIT flag set), we do not need to
> discard such group. This flag is set on mke2fs time to speed up
> subsequent file system checks, because it says to us that there is
> nothing there in the block group.
> 
> Because the BLOCK_UNINIT is only set on mke2fs time and cleared when
> allocation from that group takes place we know that when set, there was
> not anything allocated from that group, hence there should not be anything
> to discard from the file system point of view. Of course there might be
> situations where even if BLOCK_UNINIT is set the underlying storage is
> provisioned. This might happen for example when the user disables discard
> on mke2fs, however I think that this niche is not enough to not to take
> advantage of this optimization.
  This patch is correct but I'm undecided whether we really want to do this
optimization or not. It might be unexpected we didn't truncate block group
which was completely free (from user's POV). I don't consider FITRIM too
performance critical and I also don't think this will be such a massive
speedup...

								Honza
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: nothing changed
> 
>  fs/ext4/mballoc.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8f817f2..9ea1065a 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -5033,6 +5033,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  	ext4_fsblk_t first_data_blk =
>  			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
>  	ext4_fsblk_t max_blks = ext4_blocks_count(EXT4_SB(sb)->s_es);
> +	struct ext4_group_desc *desc;
>  	int ret = 0;
>  
>  	start = range->start >> sb->s_blocksize_bits;
> @@ -5076,7 +5077,14 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  		if (group == last_group)
>  			end = last_cluster;
>  
> -		if (grp->bb_free >= minlen) {
> +		desc = ext4_get_group_desc(sb, group, NULL);
> +		if (!desc) {
> +			ret = -EIO;
> +			break;
> +		}
> +
> +		if (!(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) &&
> +		    (grp->bb_free >= minlen)) {
>  			cnt = ext4_trim_all_free(sb, group, first_cluster,
>  						end, minlen);
>  			if (cnt < 0) {
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
