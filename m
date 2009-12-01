From: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 32/41] fallthru: ext2 fallthru support
Date: Mon, 30 Nov 2009 23:17:11 -0500
Message-ID: <200912010417.nB14HBsi030481@agora.fsl.cs.sunysb.edu>
References: <1256152779-10054-33-git-send-email-vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Andy Whitcroft <apw@canonical.com>,
	Scott James Remnant <scott@canonical.com>,
	Sandu Popa Marius <sandupopamarius@gmail.com>,
	Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
	"J. R. Okajima" <hooanon05@yahoo.co.jp>,
	Arnd Bergmann <arnd@arndb.de>,
	Vladimir Dronnikov <dronnikov@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753462AbZLAERh@vger.kernel.org>
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:30 PDT."
             <1256152779-10054-33-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In message <1256152779-10054-33-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> Add support for fallthru directory entries to ext2.
> 
> XXX - Makes up inode number for fallthru entry
> XXX - Might be better implemented as special symlinks
> 
> Cc: Theodore Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/ext2/dir.c           |   92 ++++++++++++++++++++++++++++++++++++++++++++--
>  fs/ext2/ext2.h          |    1 +
>  fs/ext2/namei.c         |   20 ++++++++++
>  include/linux/ext2_fs.h |    1 +
>  4 files changed, 110 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index d4628c0..2665bc6 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -219,7 +219,8 @@ static inline int ext2_match (int len, const char * const name,
>  {
>  	if (len != de->name_len)
>  		return 0;
> -	if (!de->inode && (de->file_type != EXT2_FT_WHT))
> +	if (!de->inode && ((de->file_type != EXT2_FT_WHT) &&
> +			   (de->file_type != EXT2_FT_FALLTHRU)))

Extra set of () unnecessary here and in several places below.

>  		return 0;
>  	return !memcmp(name, de->name, len);
>  }
> @@ -256,6 +257,7 @@ static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
>  	[EXT2_FT_SOCK]		= DT_SOCK,
>  	[EXT2_FT_SYMLINK]	= DT_LNK,
>  	[EXT2_FT_WHT]		= DT_WHT,
> +	[EXT2_FT_FALLTHRU]	= DT_UNKNOWN,
>  };
>  
>  #define S_SHIFT 12
> @@ -342,6 +344,24 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
>  					ext2_put_page(page);
>  					return 0;
>  				}
> +			} else if (de->file_type == EXT2_FT_FALLTHRU) {
> +				int over;
> +				unsigned char d_type = DT_UNKNOWN;
> +
> +				offset = (char *)de - kaddr;
> +				/* XXX We don't know the inode number
> +				 * of the directory entry in the
> +				 * underlying file system.  Should
> +				 * look it up, either on fallthru
> +				 * creation at first readdir or now at
> +				 * filldir time. */
> +				over = filldir(dirent, de->name, de->name_len,
> +					       (n<<PAGE_CACHE_SHIFT) | offset,
> +					       123 /* Made up ino */, d_type);

So, why 123 and not at least some other unused number below 10: at least
that way it's in the ext2 "reserved" range should something go horribly
wrong (like a power failure right shortly thereafter).

BTW, this yet-unimplemented functionality should be mentioned under
"limitations" or something in the current design doc.  I also think the
design doc should list all short-term and long-term things that need to be
implemented, and in what order.

> +				if (over) {
> +					ext2_put_page(page);
> +					return 0;
> +				}
>  			}
>  			filp->f_pos += ext2_rec_len_from_disk(de->rec_len);
>  		}
> @@ -463,6 +483,10 @@ ino_t ext2_inode_by_dentry(struct inode *dir, struct dentry *dentry)
>  			spin_lock(&dentry->d_lock);
>  			dentry->d_flags |= DCACHE_WHITEOUT;
>  			spin_unlock(&dentry->d_lock);
> +		} else if(!res && de->file_type == EXT2_FT_FALLTHRU) {
> +			spin_lock(&dentry->d_lock);
> +			dentry->d_flags |= DCACHE_FALLTHRU;
> +			spin_unlock(&dentry->d_lock);
>  		}
>  		ext2_put_page(page);
>  	}
> @@ -532,6 +556,7 @@ static ext2_dirent * ext2_append_entry(struct dentry * dentry,
>  				de->name_len = 0;
>  				de->rec_len = ext2_rec_len_to_disk(chunk_size);
>  				de->inode = 0;
> +				de->file_type = 0;
>  				goto got_it;
>  			}
>  			if (de->rec_len == 0) {
> @@ -545,6 +570,7 @@ static ext2_dirent * ext2_append_entry(struct dentry * dentry,
>  			name_len = EXT2_DIR_REC_LEN(de->name_len);
>  			rec_len = ext2_rec_len_from_disk(de->rec_len);
>  			if (!de->inode && (de->file_type != EXT2_FT_WHT) &&
> +			    (de->file_type != EXT2_FT_FALLTHRU) &&
>  			    (rec_len >= reclen))
>  				goto got_it;
>  			if (rec_len >= name_len + reclen)
> @@ -587,7 +613,8 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
>  
>  	err = -EEXIST;
>  	if (ext2_match (namelen, name, de)) {
> -		if (de->file_type == EXT2_FT_WHT)
> +		if ((de->file_type == EXT2_FT_WHT) ||
> +		    (de->file_type == EXT2_FT_FALLTHRU))
>  			goto got_it;
>  		goto out_unlock;
>  	}
> @@ -602,7 +629,8 @@ got_it:
>  							&page, NULL);
>  	if (err)
>  		goto out_unlock;
> -	if (de->inode || ((de->file_type == EXT2_FT_WHT) &&
> +	if (de->inode || (((de->file_type == EXT2_FT_WHT) ||
> +			   (de->file_type == EXT2_FT_FALLTHRU)) &&
>  			  !ext2_match (namelen, name, de))) {
>  		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
>  		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
> @@ -627,6 +655,60 @@ out_unlock:
>  }
>  
>  /*
> + * Create a fallthru entry.
> + */
> +int ext2_fallthru_entry (struct inode *dir, struct dentry *dentry)
> +{
> +	const char *name = dentry->d_name.name;
> +	int namelen = dentry->d_name.len;
> +	unsigned short rec_len, name_len;
> +	ext2_dirent * de;
> +	struct page *page;
> +	loff_t pos;
> +	int err;
> +
> +	de = ext2_append_entry(dentry, &page);
> +	if (IS_ERR(de))
> +		return PTR_ERR(de);
> +
> +	err = -EEXIST;
> +	if (ext2_match (namelen, name, de))
> +		goto out_unlock;
> +
> +	name_len = EXT2_DIR_REC_LEN(de->name_len);
> +	rec_len = ext2_rec_len_from_disk(de->rec_len);
> +
> +	pos = page_offset(page) +
> +		(char*)de - (char*)page_address(page);
> +	err = __ext2_write_begin(NULL, page->mapping, pos, rec_len, 0,
> +							&page, NULL);
> +	if (err)
> +		goto out_unlock;
> +	if (de->inode || (de->file_type == EXT2_FT_WHT) ||
> +	    (de->file_type == EXT2_FT_FALLTHRU)) {
> +		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
> +		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
> +		de->rec_len = ext2_rec_len_to_disk(name_len);
> +		de = de1;
> +	}
> +	de->name_len = namelen;
> +	memcpy(de->name, name, namelen);
> +	de->inode = 0;
> +	de->file_type = EXT2_FT_FALLTHRU;
> +	err = ext2_commit_chunk(page, pos, rec_len);
> +	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
> +	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
> +	mark_inode_dirty(dir);
> +	/* OFFSET_CACHE */
> +out_put:
> +	ext2_put_page(page);
> +	return err;
> +out_unlock:
> +	unlock_page(page);
> +	goto out_put;
> +}
> +
> +/*
>   * ext2_delete_entry deletes a directory entry by merging it with the
>   * previous entry. Page is up-to-date. Releases the page.
>   */
> @@ -711,7 +793,9 @@ int ext2_whiteout_entry (struct inode * dir, struct dentry * dentry,
>  	 */
>  	if (ext2_match (namelen, name, de))
>  		de->inode = 0;
> -	if (de->inode || (de->file_type == EXT2_FT_WHT)) {
> +	if (de->inode || (((de->file_type == EXT2_FT_WHT) ||
> +			   (de->file_type == EXT2_FT_FALLTHRU)) &&
> +			  !ext2_match (namelen, name, de))) {
>  		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
>  		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
>  		de->rec_len = ext2_rec_len_to_disk(name_len);
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index a7f057f..328fc1c 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -108,6 +108,7 @@ extern struct ext2_dir_entry_2 * ext2_find_entry (struct inode *,struct qstr *,
>  extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *);
>  extern int ext2_whiteout_entry (struct inode *, struct dentry *,
>  				struct ext2_dir_entry_2 *, struct page *);
> +extern int ext2_fallthru_entry (struct inode *, struct dentry *);
>  extern int ext2_empty_dir (struct inode *);
>  extern struct ext2_dir_entry_2 * ext2_dotdot (struct inode *, struct page **);
>  extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, struct inode *, int);
> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index 9c4eef2..2ac44f1 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -333,6 +333,7 @@ static int ext2_whiteout(struct inode *dir, struct dentry *dentry,
>  		goto out;
>  
>  	spin_lock(&new_dentry->d_lock);
> +	new_dentry->d_flags &= ~DCACHE_FALLTHRU;
>  	new_dentry->d_flags |= DCACHE_WHITEOUT;
>  	spin_unlock(&new_dentry->d_lock);
>  	d_add(new_dentry, NULL);
> @@ -351,6 +352,24 @@ out:
>  	return err;
>  }
>  
> +/*
> + * Create a fallthru entry.
> + */
> +static int ext2_fallthru (struct inode *dir, struct dentry *dentry)
> +{
> +	int err;
> +
> +	err = ext2_fallthru_entry(dir, dentry);
> +	if (err)
> +		return err;
> +
> +	d_instantiate(dentry, NULL);
> +	spin_lock(&dentry->d_lock);
> +	dentry->d_flags |= DCACHE_FALLTHRU;
> +	spin_unlock(&dentry->d_lock);
> +	return 0;
> +}
> +
>  static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
>  	struct inode * new_dir,	struct dentry * new_dentry )
>  {
> @@ -451,6 +470,7 @@ const struct inode_operations ext2_dir_inode_operations = {
>  	.rmdir		= ext2_rmdir,
>  	.mknod		= ext2_mknod,
>  	.whiteout	= ext2_whiteout,
> +	.fallthru	= ext2_fallthru,
>  	.rename		= ext2_rename,
>  #ifdef CONFIG_EXT2_FS_XATTR
>  	.setxattr	= generic_setxattr,
> diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
> index bd10826..f6b68ec 100644
> --- a/include/linux/ext2_fs.h
> +++ b/include/linux/ext2_fs.h
> @@ -577,6 +577,7 @@ enum {
>  	EXT2_FT_SOCK,
>  	EXT2_FT_SYMLINK,
>  	EXT2_FT_WHT,
> +	EXT2_FT_FALLTHRU,
>  	EXT2_FT_MAX
>  };
>  
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
