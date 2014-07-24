From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: check inline directory before converting
Date: Thu, 24 Jul 2014 15:57:39 -0700
Message-ID: <20140724225739.GH8628@birch.djwong.org>
References: <20140724212222.GG8628@birch.djwong.org>
 <253FEEC3-F619-4D9B-8358-A8FC8A832740@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19957 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaGXW5q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 18:57:46 -0400
Content-Disposition: inline
In-Reply-To: <253FEEC3-F619-4D9B-8358-A8FC8A832740@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 24, 2014 at 04:41:04PM -0600, Andreas Dilger wrote:
> On Jul 24, 2014, at 3:22 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > Before converting an inline directory to a regular directory, check
> > the directory entries to make sure they're not obviously broken.
> > This helps us to avoid a BUG_ON if one of the dirents is trashed.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > fs/ext4/inline.c |   37 +++++++++++++++++++++++++++++++++++++
> > 1 file changed, 37 insertions(+)
> > 
> > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > index 645205d..c79d8e7 100644
> > --- a/fs/ext4/inline.c
> > +++ b/fs/ext4/inline.c
> > @@ -1157,6 +1157,31 @@ out:
> > 	return err;
> > }
> > 
> > +static int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
> > +			     void *buf, int buf_size)
> 
> It would seem that this function would be useful in ext4_readdir(), which
> open-codes something very similar?  It might be better to locate this
> function in ext4/dir.c since it doesn't appear to have anything specific
> to do with inline directories.

I don't have any problem with moving it to dir.c.

As for _readdir, while it does open-code a similar loop, I don't know if it's
really worth it to try to shoe-horn what it does into the same function, since
it has to update ctx->pos and call dir_emit when it finds a valid entry.
Assuming you're talking about the while loop towards the end of the function.

--D

> 
> Cheers, Andreas
> 
> > +{
> > +	struct ext4_dir_entry_2 *de;
> > +	int nlen, rlen;
> > +	unsigned int offset = 0;
> > +	char *top;
> > +
> > +	de = (struct ext4_dir_entry_2 *)buf;
> > +	top = buf + buf_size;
> > +	while ((char *) de < top) {
> > +		if (ext4_check_dir_entry(dir, NULL, de, bh,
> > +					 buf, buf_size, offset))
> > +			return -EIO;
> > +		nlen = EXT4_DIR_REC_LEN(de->name_len);
> > +		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
> > +		de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
> > +		offset += rlen;
> > +	}
> > +	if ((char *) de > top)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
> > static int ext4_convert_inline_data_nolock(handle_t *handle,
> > 					   struct inode *inode,
> > 					   struct ext4_iloc *iloc)
> > @@ -1178,6 +1203,18 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
> > 	if (error < 0)
> > 		goto out;
> > 
> > +	/*
> > +	 * Make sure the inline directory entries pass checks before we try to
> > +	 * convert them, so that we avoid touching stuff that needs fsck.
> > +	 */
> > +	if (S_ISDIR(inode->i_mode)) {
> > +		error = ext4_check_all_de(inode, iloc->bh,
> > +					buf + EXT4_INLINE_DOTDOT_SIZE,
> > +					inline_size - EXT4_INLINE_DOTDOT_SIZE);
> > +		if (error)
> > +			goto out;
> > +	}
> > +
> > 	error = ext4_destroy_inline_data_nolock(handle, inode);
> > 	if (error)
> > 		goto out;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


