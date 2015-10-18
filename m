From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/8] ext4: store checksum seed in superblock
Date: Sat, 17 Oct 2015 18:23:26 -0700
Message-ID: <20151018012326.GS10390@birch.djwong.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215444.28872.23113.stgit@birch.djwong.org>
 <20151018011946.GF2678@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35461 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbbJRBXf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2015 21:23:35 -0400
Content-Disposition: inline
In-Reply-To: <20151018011946.GF2678@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 17, 2015 at 09:19:46PM -0400, Theodore Ts'o wrote:
> On Mon, Oct 12, 2015 at 02:54:44PM -0700, Darrick J. Wong wrote:
> > Allow the filesystem to store the metadata checksum seed in the
> > superblock and add an incompat feature to say that we're using it.
> > This enables tune2fs to change the UUID on a mounted metadata_csum
> > FS without having to (racy!) rewrite all disk metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is what I have in my tree after deconflict with project quota's
> superblock usage.
> 
> Cheers,
> 
> 					- Ted
> 					
> 
> commit 8c81bd8f586c46eaf114758a78d82895a2b081c2
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date:   Sat Oct 17 16:16:02 2015 -0400
> 
>     ext4: store checksum seed in superblock
>     
>     Allow the filesystem to store the metadata checksum seed in the
>     superblock and add an incompat feature to say that we're using it.
>     This enables tune2fs to change the UUID on a mounted metadata_csum
>     FS without having to (racy!) rewrite all disk metadata.
>     
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 320f10e..cd832b9 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1184,7 +1184,8 @@ struct ext4_super_block {
>  	__u8	s_encrypt_pw_salt[16];	/* Salt used for string2key algorithm */
>  	__le32	s_lpf_ino;		/* Location of the lost+found inode */
>  	__le32	s_prj_quota_inum;	/* inode for tracking project quota */
> -	__le32	s_reserved[99];		/* Padding to the end of the block */
> +	__le32	s_checksum_seed;	/* crc32c(uuid) if csum_seed set */
> +	__le32	s_reserved[98];		/* Padding to the end of the block */

I think this is the only change from the previous patch?  Looks good to me!

--D

>  	__le32	s_checksum;		/* crc32c(superblock) */
>  };
>  
> @@ -1584,7 +1585,7 @@ static inline int ext4_encrypted_inode(struct inode *inode)
>  #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
>  #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400 /* EA in inode */
>  #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000 /* data in dirent */
> -#define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM	0x2000 /* use crc32c for bg */
> +#define EXT4_FEATURE_INCOMPAT_CSUM_SEED		0x2000
>  #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
>  #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
>  #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
> @@ -1613,7 +1614,8 @@ static inline int ext4_encrypted_inode(struct inode *inode)
>  					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
>  					 EXT4_FEATURE_INCOMPAT_MMP | \
>  					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
> -					 EXT4_FEATURE_INCOMPAT_ENCRYPT)
> +					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
> +					 EXT4_FEATURE_INCOMPAT_CSUM_SEED)
>  #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
>  					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
>  					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7ef3fa5..43c0cc8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3196,7 +3196,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	/* Precompute checksum seed for all metadata */
> -	if (ext4_has_metadata_csum(sb))
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_CSUM_SEED))
> +		sbi->s_csum_seed = le32_to_cpu(es->s_checksum_seed);
> +	else if (ext4_has_metadata_csum(sb))
>  		sbi->s_csum_seed = ext4_chksum(sbi, ~0, es->s_uuid,
>  					       sizeof(es->s_uuid));
>  
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index 62bef0f..1b57c72 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -224,12 +224,14 @@ EXT4_ATTR_FEATURE(lazy_itable_init);
>  EXT4_ATTR_FEATURE(batched_discard);
>  EXT4_ATTR_FEATURE(meta_bg_resize);
>  EXT4_ATTR_FEATURE(encryption);
> +EXT4_ATTR_FEATURE(metadata_csum_seed);
>  
>  static struct attribute *ext4_feat_attrs[] = {
>  	ATTR_LIST(lazy_itable_init),
>  	ATTR_LIST(batched_discard),
>  	ATTR_LIST(meta_bg_resize),
>  	ATTR_LIST(encryption),
> +	ATTR_LIST(metadata_csum_seed),
>  	NULL,
>  };
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
