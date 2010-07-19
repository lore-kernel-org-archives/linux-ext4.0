From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 11/38] whiteout: ext2 whiteout support
Date: Mon, 19 Jul 2010 18:14:16 -0400
Message-ID: <20100719221416.GB11089@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-12-git-send-email-vaurora@redhat.com> <20100713042418.GC3949@zeus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Jan Blunck <jblunck@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965985Ab0GSWOe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jul 2010 18:14:34 -0400
Content-Disposition: inline
In-Reply-To: <20100713042418.GC3949@zeus.themaw.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 13, 2010 at 12:24:20PM +0800, Ian Kent wrote:
> On Tue, Jun 15, 2010 at 11:39:41AM -0700, Valerie Aurora wrote:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > This patch adds whiteout support to EXT2. A whiteout is an empty directory
> > entry (inode == 0) with the file type set to EXT2_FT_WHT. Therefore it
> > allocates space in directories. Due to being implemented as a filetype it is
> > necessary to have the EXT2_FEATURE_INCOMPAT_FILETYPE flag set.
> > 
> > XXX - Needs serious review.  Al wonders: What happens with a delete at
> > the beginning of a block?  Will we find the matching dentry or the
> > first empty space?
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > Cc: Theodore Tso <tytso@mit.edu>
> > Cc: linux-ext4@vger.kernel.org
> > ---
> >  fs/ext2/dir.c           |   96 +++++++++++++++++++++++++++++++++++++++++++++--
> >  fs/ext2/ext2.h          |    3 +
> >  fs/ext2/inode.c         |   11 ++++-
> >  fs/ext2/namei.c         |   67 +++++++++++++++++++++++++++++++-
> >  fs/ext2/super.c         |    6 +++
> >  include/linux/ext2_fs.h |    4 ++
> >  6 files changed, 177 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> > index 57207a9..030bd46 100644
> > --- a/fs/ext2/dir.c
> > +++ b/fs/ext2/dir.c
> > @@ -219,7 +219,7 @@ static inline int ext2_match (int len, const char * const name,
> >  {
> >  	if (len != de->name_len)
> >  		return 0;
> > -	if (!de->inode)
> > +	if (!de->inode && (de->file_type != EXT2_FT_WHT))
> >  		return 0;
> >  	return !memcmp(name, de->name, len);
> >  }
> > @@ -255,6 +255,7 @@ static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
> >  	[EXT2_FT_FIFO]		= DT_FIFO,
> >  	[EXT2_FT_SOCK]		= DT_SOCK,
> >  	[EXT2_FT_SYMLINK]	= DT_LNK,
> > +	[EXT2_FT_WHT]		= DT_WHT,
> >  };
> >  
> >  #define S_SHIFT 12
> > @@ -448,6 +449,26 @@ ino_t ext2_inode_by_name(struct inode *dir, struct qstr *child)
> >  	return res;
> >  }
> >  
> > +/* Special version for filetype based whiteout support */
> > +ino_t ext2_inode_by_dentry(struct inode *dir, struct dentry *dentry)
> > +{
> > +	ino_t res = 0;
> > +	struct ext2_dir_entry_2 *de;
> > +	struct page *page;
> > +
> > +	de = ext2_find_entry (dir, &dentry->d_name, &page);
> > +	if (de) {
> > +		res = le32_to_cpu(de->inode);
> > +		if (!res && de->file_type == EXT2_FT_WHT) {
> > +			spin_lock(&dentry->d_lock);
> > +			dentry->d_flags |= DCACHE_WHITEOUT;
> > +			spin_unlock(&dentry->d_lock);
> > +		}
> > +		ext2_put_page(page);
> > +	}
> > +	return res;
> > +}
> > +
> >  /* Releases the page */
> >  void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
> >  		   struct page *page, struct inode *inode, int update_times)
> > @@ -523,7 +544,8 @@ static ext2_dirent * ext2_append_entry(struct dentry * dentry,
> >  				goto got_it;
> >  			name_len = EXT2_DIR_REC_LEN(de->name_len);
> >  			rec_len = ext2_rec_len_from_disk(de->rec_len);
> > -			if (!de->inode && rec_len >= reclen)
> > +			if (!de->inode && (de->file_type != EXT2_FT_WHT) &&
> > +			    (rec_len >= reclen))
> >  				goto got_it;
> >  			if (rec_len >= name_len + reclen)
> >  				goto got_it;
> > @@ -564,8 +586,11 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
> >  		return PTR_ERR(de);
> >  
> >  	err = -EEXIST;
> > -	if (ext2_match (namelen, name, de))
> > +	if (ext2_match (namelen, name, de)) {
> > +		if (de->file_type == EXT2_FT_WHT)
> > +			goto got_it;
> >  		goto out_unlock;
> > +	}
> >  
> >  got_it:
> >  	name_len = EXT2_DIR_REC_LEN(de->name_len);
> > @@ -577,7 +602,8 @@ got_it:
> >  							&page, NULL);
> >  	if (err)
> >  		goto out_unlock;
> > -	if (de->inode) {
> > +	if (de->inode || ((de->file_type == EXT2_FT_WHT) &&
> > +			  !ext2_match (namelen, name, de))) {
> >  		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
> >  		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
> >  		de->rec_len = ext2_rec_len_to_disk(name_len);
> > @@ -646,6 +672,68 @@ out:
> >  	return err;
> >  }
> >  
> > +int ext2_whiteout_entry (struct inode * dir, struct dentry * dentry,
> > +			 struct ext2_dir_entry_2 * de, struct page * page)
> > +{
> > +	const char *name = dentry->d_name.name;
> > +	int namelen = dentry->d_name.len;
> > +	unsigned short rec_len, name_len;
> > +	loff_t pos;
> > +	int err;
> > +
> > +	if (!de) {
> > +		de = ext2_append_entry(dentry, &page);
> > +		BUG_ON(!de);
> > +	}
> > +
> > +	err = -EEXIST;
> > +	if (ext2_match (namelen, name, de) &&
> > +	    (de->file_type == EXT2_FT_WHT)) {
> > +		ext2_error(dir->i_sb, __func__,
> > +			   "entry is already a whiteout in directory #%lu",
> > +			   dir->i_ino);
> > +		goto out_unlock;
> > +	}
> > +
> > +	name_len = EXT2_DIR_REC_LEN(de->name_len);
> > +	rec_len = ext2_rec_len_from_disk(de->rec_len);
> > +
> > +	pos = page_offset(page) +
> > +		(char*)de - (char*)page_address(page);
> > +	err = __ext2_write_begin(NULL, page->mapping, pos, rec_len, 0,
> > +							&page, NULL);
> > +	if (err)
> > +		goto out_unlock;
> > +	/*
> > +	 * We whiteout an existing entry. Do what ext2_delete_entry() would do,
> > +	 * except that we don't need to merge with the previous entry since
> > +	 * we are going to reuse it.
> > +	 */
> > +	if (ext2_match (namelen, name, de))
> > +		de->inode = 0;
> > +	if (de->inode || (de->file_type == EXT2_FT_WHT)) {
> > +		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
> > +		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
> > +		de->rec_len = ext2_rec_len_to_disk(name_len);
> > +		de = de1;
> > +	}
> 
> This looks odd, can someone tell me what's actually going with de and de1
> here please?

This patch needs serious review (as noted).  I will corner some ext*
developer at some point to look at it.

-VAL
