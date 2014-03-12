From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 10/49] libext2fs: fix iblocks correctly when expanding an inline_data file
Date: Wed, 12 Mar 2014 10:38:57 -0600
Message-ID: <5091761D-1733-4150-9999-C63CF142795B@dilger.ca>
References: <20140311065356.30585.47192.stgit@birch.djwong.org> <20140311065502.30585.81788.stgit@birch.djwong.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"darrick.wong@oracle.com" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50038 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbaCLQi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2014 12:38:58 -0400
Received: by mail-pd0-f169.google.com with SMTP id fp1so1299533pdb.14
        for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2014 09:38:57 -0700 (PDT)
In-Reply-To: <20140311065502.30585.81788.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I thought it wasn't possible to have inline data and an external xattr block?  It doesn't make sense to do it that way compared to the normal inline xattr and external data block. 

Cheers, Andreas

> On Mar 11, 2014, at 0:55, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> i_blocks covers the number of blocks allocated to an inode for data,
> extents, and ACL blocks.  Since it's possible for a file to have a
> separate ACL block and inline data, we must be careful when expanding
> an inline data file to adjust, not set, the value of i_blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> lib/ext2fs/inline_data.c |    5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index 72e8fa3..a9ec923 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -372,7 +372,9 @@ ext2fs_inline_data_dir_expand(ext2_filsys fs, ext2_ino_t ino,
>    if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT3_FEATURE_INCOMPAT_EXTENTS))
>        inode->i_flags |= EXT4_EXTENTS_FL;
>    inode->i_flags &= ~EXT4_INLINE_DATA_FL;
> -    ext2fs_iblk_set(fs, inode, 1);
> +    retval = ext2fs_iblk_add_blocks(fs, inode, 1);
> +    if (retval)
> +        goto errout;
>    inode->i_size = fs->blocksize;
>    retval = ext2fs_bmap2(fs, ino, inode, 0, BMAP_SET, 0, 0, &blk);
>    if (retval)
> @@ -410,7 +412,6 @@ ext2fs_inline_data_file_expand(ext2_filsys fs, ext2_ino_t ino,
>        inode->i_flags |= EXT4_EXTENTS_FL;
>    }
>    inode->i_flags &= ~EXT4_INLINE_DATA_FL;
> -    ext2fs_iblk_set(fs, inode, 0);
>    inode->i_size = 0;
>    retval = ext2fs_write_inode(fs, ino, inode);
>    if (retval)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
