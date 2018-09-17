From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/3] ext2, dax: set ext2_dax_aops for dax files
Date: Mon, 17 Sep 2018 18:37:09 +0200
Message-ID: <20180917163709.GA10257@quack2.suse.cz>
References: <20180914145114.11122-1-toshi.kani@hpe.com>
 <20180914145114.11122-4-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, dan.j.williams@intel.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180914145114.11122-4-toshi.kani@hpe.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 14-09-18 08:51:14, Toshi Kani wrote:
> Sync syscall to DAX file needs to flush processor cache, but it
> currently does not flush to existing DAX files.  This is because
> 'ext2_da_aops' is set to address_space_operations of existing DAX
> files, instead of 'ext2_dax_aops', since S_DAX flag is set after
> ext2_set_aops() in the open path.
> 
> Similar to ext4, change ext2_iget() to initialize i_flags before
> ext2_set_aops().
> 
> Fixes: fb094c90748f ("ext2, dax: introduce ext2_dax_aops")
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: <stable@vger.kernel.org>

Thanks. I'll take the patch through my tree.

								Honza

> ---
>  fs/ext2/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 7f7ee18fe179..e4bb9386c045 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1448,6 +1448,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  	}
>  	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
>  	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
> +	ext2_set_inode_flags(inode);
>  	ei->i_faddr = le32_to_cpu(raw_inode->i_faddr);
>  	ei->i_frag_no = raw_inode->i_frag;
>  	ei->i_frag_size = raw_inode->i_fsize;
> @@ -1517,7 +1518,6 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  			   new_decode_dev(le32_to_cpu(raw_inode->i_block[1])));
>  	}
>  	brelse (bh);
> -	ext2_set_inode_flags(inode);
>  	unlock_new_inode(inode);
>  	return inode;
>  	
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
