From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/49] libext2fs: fix iblocks correctly when expanding an
 inline_data file
Date: Wed, 12 Mar 2014 10:01:33 -0700
Message-ID: <20140312170133.GA9070@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065502.30585.81788.stgit@birch.djwong.org>
 <5091761D-1733-4150-9999-C63CF142795B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaCLRBj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2014 13:01:39 -0400
Content-Disposition: inline
In-Reply-To: <5091761D-1733-4150-9999-C63CF142795B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2014 at 10:38:57AM -0600, Andreas Dilger wrote:
> I thought it wasn't possible to have inline data and an external xattr block?
> It doesn't make sense to do it that way compared to the normal inline xattr
> and external data block. 

I don't know if you're /supposed/ to be able to do that, but the kernel permits
me to create an inline data dir and then set a huge xattr on it that forces the
allocation of an EA block.

--D
> 
> Cheers, Andreas
> 
> > On Mar 11, 2014, at 0:55, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> > 
> > i_blocks covers the number of blocks allocated to an inode for data,
> > extents, and ACL blocks.  Since it's possible for a file to have a
> > separate ACL block and inline data, we must be careful when expanding
> > an inline data file to adjust, not set, the value of i_blocks.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > lib/ext2fs/inline_data.c |    5 +++--
> > 1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> > index 72e8fa3..a9ec923 100644
> > --- a/lib/ext2fs/inline_data.c
> > +++ b/lib/ext2fs/inline_data.c
> > @@ -372,7 +372,9 @@ ext2fs_inline_data_dir_expand(ext2_filsys fs, ext2_ino_t ino,
> >    if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT3_FEATURE_INCOMPAT_EXTENTS))
> >        inode->i_flags |= EXT4_EXTENTS_FL;
> >    inode->i_flags &= ~EXT4_INLINE_DATA_FL;
> > -    ext2fs_iblk_set(fs, inode, 1);
> > +    retval = ext2fs_iblk_add_blocks(fs, inode, 1);
> > +    if (retval)
> > +        goto errout;
> >    inode->i_size = fs->blocksize;
> >    retval = ext2fs_bmap2(fs, ino, inode, 0, BMAP_SET, 0, 0, &blk);
> >    if (retval)
> > @@ -410,7 +412,6 @@ ext2fs_inline_data_file_expand(ext2_filsys fs, ext2_ino_t ino,
> >        inode->i_flags |= EXT4_EXTENTS_FL;
> >    }
> >    inode->i_flags &= ~EXT4_INLINE_DATA_FL;
> > -    ext2fs_iblk_set(fs, inode, 0);
> >    inode->i_size = 0;
> >    retval = ext2fs_write_inode(fs, ino, inode);
> >    if (retval)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
