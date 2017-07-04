From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fast symlink test should not rely on i_blocks
Date: Tue, 4 Jul 2017 00:11:07 -0400
Message-ID: <20170704041107.7q6jh3cpd46v3rhc@thunk.org>
References: <20170628003455.12748-1-tahsin@google.com>
 <1E96A392-4BE6-4078-B708-5C8C33C52654@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tahsin Erdogan <tahsin@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1E96A392-4BE6-4078-B708-5C8C33C52654@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 28, 2017 at 10:53:31AM -0600, Andreas Dilger wrote:
> 
> > On Jun 27, 2017, at 6:34 PM, Tahsin Erdogan <tahsin@google.com> wrote:
> > 
> > ext4_inode_info->i_data is the storage area for 4 types of data:
> > 
> >  a) Extents data
> >  b) Inline data
> >  c) Block map
> >  d) Fast symlink data (symlink length < 60)
> > 
> > Extents data case is positively identified by EXT4_INODE_EXTENTS flag.
> > Inline data case is also obvious because of EXT4_INODE_INLINE_DATA
> > flag.
> > 
> > Distinguishing c) and d) however requires additional logic. This
> > currently relies on i_blocks count. After subtracting external xattr
> > block from i_blocks, if it is greater than 0 then we know that some
> > data blocks exist, so there must be a block map.
> > 
> > This logic got broken after ea_inode feature was added. That feature
> > charges the data blocks of external xattr inodes to the referencing
> > inode and so adds them to the i_blocks. To fix this, we could subtract
> > ea_inode blocks by iterating through all xattr entries and then check
> > whether remaining i_blocks count is zero. Besides being complicated,
> > this won't change the fact that the current way of distinguishing
> > between c) and d) is fragile.
> > 
> > The alternative solution is to test whether i_size is less than 60 to
> > determine fast symlink case. ext4_symlink() uses the same test to decide
> > whether to store the symlink in i_data. There is one caveat to address
> > before this can work though.
> > 
> > If an inode's i_nlink is zero during eviction, its i_size is set to
> > zero and its data is truncated. If system crashes before inode is removed
> > from the orphan list, next boot orphan cleanup may find the inode with
> > zero i_size. So, a symlink that had its data stored in a block may now
> > appear to be a fast symlink. The solution used in this patch is to treat
> > i_size = 0 as a non-fast symlink case. A zero sized symlink is not legal
> > so the only time this can happen is the mentioned scenario. This is also
> > logically correct because a i_size = 0 symlink has no data stored in
> > i_data.
> > 
> > Fixes: 74c5bfa651af ("ext4: xattr inode deduplication")
> > 
> > Suggested-by: Andreas Dilger <adilger@dilger.ca>
> > Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> 
> The unfortunate bit is that this makes the inode impossible to undelete, but
> I don't think that is a huge concern for symlinks.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
