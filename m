From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Date: Wed, 28 Jun 2017 17:48:25 -0700
Message-ID: <20170629004825.GA5865@birch.djwong.org>
References: <c9f7090b2a58364998ad4a49cfdac379b905c7e9.1498687302.git.kkc6196@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
To: Kyungchan Koh <kkc6196@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40226 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdF2Asg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jun 2017 20:48:36 -0400
Content-Disposition: inline
In-Reply-To: <c9f7090b2a58364998ad4a49cfdac379b905c7e9.1498687302.git.kkc6196@fb.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 28, 2017 at 03:06:42PM -0700, Kyungchan Koh wrote:
> In fs/ext4/super.c, the function ext4_nfs_get_inode takes as input
> "generation" that can be used to specify the generation of the inode to
> be returned. When 0 is given as input, then inodes of any generation can
> be returned. Therefore, generation 0 is a special case that should be
> avoided when assigning generation to inodes.
> 
> A new inline function, ext4_inode_set_gen, will take care of the
> problem.  Now, inodes cannot have a generation of 0, so this patch fixes
> the issue.

Forgive my ignorance, but why is generation == 0 a special case?

>From a quick scan of the code it seems that filesystems hand out
handles to NFS with parent_{ino,gen} set (or zeroed).  That implies that
we have to check ino/gen for zeroes and garbage, but I don't see why
you'd exempt gen == 0 from checking?

(Really what I'm fishing for is whether or not there's some precedent
for this that I don't know about.)

--D

> 
> Signed-off-by: Kyungchan Koh <kkc6196@fb.com>
> ---
>  fs/ext4/ext4.h   | 8 ++++++++
>  fs/ext4/ialloc.c | 2 +-
>  fs/ext4/ioctl.c  | 4 ++--
>  3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3219154..74c6677 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1549,6 +1549,14 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
>  		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
>  }
>  
> +static inline void ext4_inode_set_gen(struct inode *inode,
> +				      struct ext4_sb_info *sbi)
> +{
> +	inode->i_generation = sbi->s_next_generation++;
> +	if (!inode->i_generation)
> +		inode->i_generation = sbi->s_next_generation++;
> +}
> +
>  /*
>   * Inode dynamic state flags
>   */
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 98ac2f1..d33f6f0 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1072,7 +1072,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>  		goto out;
>  	}
>  	spin_lock(&sbi->s_next_gen_lock);
> -	inode->i_generation = sbi->s_next_generation++;
> +	ext4_inode_set_gen(inode, sbi);
>  	spin_unlock(&sbi->s_next_gen_lock);
>  
>  	/* Precompute checksum seed for inode metadata */
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0c21e22..d52a467 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -160,8 +160,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
>  	inode->i_ctime = inode_bl->i_ctime = current_time(inode);
>  
>  	spin_lock(&sbi->s_next_gen_lock);
> -	inode->i_generation = sbi->s_next_generation++;
> -	inode_bl->i_generation = sbi->s_next_generation++;
> +	ext4_inode_set_gen(inode, sbi);
> +	ext4_inode_set_gen(inode_bl, sbi);
>  	spin_unlock(&sbi->s_next_gen_lock);
>  
>  	ext4_discard_preallocations(inode);
> -- 
> 2.9.3
> 
