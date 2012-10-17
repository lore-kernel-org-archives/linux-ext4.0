From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: metadata_csum set but no space in dir leaf for checksum
Date: Wed, 17 Oct 2012 14:21:33 -0700
Message-ID: <20121017212133.GA17360@blackbox.djwong.org>
References: <20121017195130.GA29138@blackbox.djwong.org>
 <1BE5D8B7-A3C7-4556-B553-F2016174F475@dilger.ca>
Reply-To: "Darrick J. Wong" <darrick.wong@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:49824 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab2JQVVl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2012 17:21:41 -0400
Content-Disposition: inline
In-Reply-To: <1BE5D8B7-A3C7-4556-B553-F2016174F475@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[accidentally dropped linux-ext4, oops...]

On Wed, Oct 17, 2012 at 02:59:47PM -0600, Andreas Dilger wrote:
> On 2012-10-17, at 1:51 PM, Darrick J. Wong wrote:
> > So... I think that Mr. Spelvin's error message occurs when the regular hashed
> > directory lookup functions fail and the code falls back to a linear search of
> > all directory file blocks.  In this case, all blocks are treated as if they are
> > individual arrays of dirents, hence the checksum verification code was
> > expecting to find the checksum-storing dirent at the end of the block.  That's
> > not true for internal nodes of the hash tree, so I think that gating them off
> > will prevent the error messages from showing.
> > 
> > That said, using the fallback mode hints that the directory might have
> > something wrong with it.  Does e2fsck -D not fix it?
> > 
> > But before you do that, does the following patch help?
> > --
> > Subject: [PATCH] ext4: Don't verify checksums of dx non-leaf nodes during fallback linear scan
> > 
> > During a directory entry lookup of a hashed directory, if the hash-based lookup
> > functions fail and we fall back to a linear scan, don't try to verify the
> > dirent checksum on the internal nodes of the hash tree because they don't store
> > a checksum in a hidden dirent like the leaf nodes do.
> 
> That raises the question of why there are no checksums in the htree index
> blocks?  They should be considered metadata also, and corruption there can
> also have a serious impact on usability (e.g. directing lookup to wrong leaf
> block and returning -ENOENT when desired entry is not found).

The htree indexes do have checksums; they're in the htree data structures.  The
checksum covers both the dirent container and the htree index.  However, if the
htree code decides to fall back to linear search and ignore the htree indices,
then there doesn't seem to be much point in checksumming the indices. 

Hmm, maybe it's time I update the ext4 wiki again. :)

--D

> 
> Cheers, Andreas
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reported-by: George Spelvin <linux@horizon.com>
> > ---
> > 
> > fs/ext4/namei.c |   17 +++++++++++++++++
> > 1 file changed, 17 insertions(+)
> > 
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 6d600a6..158a562 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -1144,6 +1144,21 @@ static inline int search_dirblock(struct buffer_head *bh,
> > 	return 0;
> > }
> > 
> > +static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
> > +			       struct ext4_dir_entry *de)
> > +{
> > +	struct super_block *sb = dir->i_sb;
> > +
> > +	if (!is_dx(dir))
> > +		return 0;
> > +	if (block == 0)
> > +		return 1;
> > +	if (de->inode == 0 &&
> > +	    ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize) ==
> > +			sb->s_blocksize)
> > +		return 1;
> > +	return 0;
> > +}
> > 
> > /*
> >  *	ext4_find_entry()
> > @@ -1244,6 +1259,8 @@ restart:
> > 			goto next;
> > 		}
> > 		if (!buffer_verified(bh) &&
> > +		    !is_dx_internal_node(dir, block,
> > +					 (struct ext4_dir_entry *)bh->b_data) &&
> > 		    !ext4_dirent_csum_verify(dir,
> > 				(struct ext4_dir_entry *)bh->b_data)) {
> > 			EXT4_ERROR_INODE(dir, "checksumming directory "
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
