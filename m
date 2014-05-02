From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 12/37] e2fsck: insert a missing dirent tail for checksums
 if possible
Date: Fri, 2 May 2014 14:54:08 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405021452160.2154@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231341.31890.18777.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaEBMyO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2014 08:54:14 -0400
In-Reply-To: <20140501231341.31890.18777.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:13:41 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 12/37] e2fsck: insert a missing dirent tail for checksums if
>     possible
> 
> If e2fsck is writing a block of directory entries to disk, it should
> adjust the dirents to add the dirent tail if one is missing.  It's not
> a big deal if there's no space to do this since rehash (pass 3A) will
> reconstruct directories for us.  However, we may as well avoid
> unnecessary work.

I am sorry for the stupid questions, but in what case can be the
dirent tail missing ? It's not immediately obvious to me.

Thanks!
-Lukas

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  e2fsck/pass2.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> 
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 5488c73..95f51b7 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -739,6 +739,41 @@ static int is_last_entry(ext2_filsys fs, int inline_data_size,
>  		return (offset < fs->blocksize - csum_size);
>  }
>  
> +static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
> +{
> +	struct ext2_dir_entry *d;
> +	void *top;
> +	struct ext2_dir_entry_tail *t;
> +	unsigned int rec_len;
> +
> +	d = dirbuf;
> +	top = EXT2_DIRENT_TAIL(dirbuf, fs->blocksize);
> +
> +	rec_len = d->rec_len;
> +	while (rec_len && !(rec_len & 0x3)) {
> +		d = (struct ext2_dir_entry *)(((char *)d) + rec_len);
> +		if (((void *)d) + d->rec_len >= top)
> +			break;
> +		rec_len = d->rec_len;
> +	}
> +
> +	if (d != top) {
> +		size_t min_size = EXT2_DIR_REC_LEN(
> +				ext2fs_dirent_name_len(dirbuf));
> +		if (min_size > d->rec_len - sizeof(struct ext2_dir_entry_tail))
> +			return EXT2_ET_DIR_NO_SPACE_FOR_CSUM;
> +		d->rec_len -= sizeof(struct ext2_dir_entry_tail);
> +	}
> +
> +	t = (struct ext2_dir_entry_tail *)top;
> +	if (t->det_reserved_zero1 ||
> +	    t->det_rec_len != sizeof(struct ext2_dir_entry_tail) ||
> +	    t->det_reserved_name_len != EXT2_DIR_NAME_LEN_CSUM)
> +		ext2fs_initialize_dirent_tail(fs, t);
> +
> +	return 0;
> +}
> +
>  static int check_dir_block(ext2_filsys fs,
>  			   struct ext2_db_entry2 *db,
>  			   void *priv_data)
> @@ -1275,8 +1310,13 @@ skip_checksum:
>  		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
>  				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
>  		    is_leaf &&
> +		    !inline_data_size &&
>  		    !ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf))
> +		{
> +			if (insert_dirent_tail(fs, buf) == 0)
> +				goto write_and_fix;
>  			e2fsck_rehash_dir_later(ctx, ino);
> +		}
>  
>  write_and_fix:
>  		if (e2fsck_dir_will_be_rehashed(ctx, ino))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
