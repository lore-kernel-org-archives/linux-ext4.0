From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
Date: Thu, 19 Jul 2012 08:45:14 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207190842560.4970@localhost>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com> <1342185555-21146-2-git-send-email-lczerner@redhat.com> <50070FD7.40301@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <50070FD7.40301@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 18 Jul 2012, Eric Sandeen wrote:

> Date: Wed, 18 Jul 2012 14:34:47 -0500
> From: Eric Sandeen <sandeen@redhat.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
>     achender@linux.vnet.ibm.com
> Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
> 
> On 7/13/12 8:19 AM, Lukas Czerner wrote:
> > This reverts commit 189e868fa8fdca702eb9db9d8afc46b5cb9144c9.
> > 
> > This commit reintroduces the use of ext4_block_truncate_page() in ext4
> > truncate operation instead of ext4_discard_partial_page_buffers().
> 
> And I think commit 15291164b22a357cb211b618adfef4fa82fc0de3
> jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer
> 
> fixed the fsx problem referenced in that commit more properly.

You're probably right, I'll test that with your test case and add it
to the description.

Thanks!
-Lukas

> 
> > The statement in the commit description that the truncate operation only
> > zero block unaligned portion of the last page is not exactly right,
> > since truncate_pagecache_range() also zeroes and invalidate the unaligned
> > portion of the page. Then there is no need to zero and unmap it once more
> > and ext4_block_truncate_page() was doing the right job, although we
> > still need to update the buffer head containing the last block, which is
> > exactly what ext4_block_truncate_page() is doing.
> > 
> > This was tested on ppc64 machine with block size of 1024 bytes without
> > any problems.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/extents.c  |   13 ++-----------
> >  fs/ext4/indirect.c |   13 ++-----------
> >  2 files changed, 4 insertions(+), 22 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 91341ec..ceab5f5 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4222,7 +4222,6 @@ void ext4_ext_truncate(struct inode *inode)
> >  	struct super_block *sb = inode->i_sb;
> >  	ext4_lblk_t last_block;
> >  	handle_t *handle;
> > -	loff_t page_len;
> >  	int err = 0;
> >  
> >  	/*
> > @@ -4239,16 +4238,8 @@ void ext4_ext_truncate(struct inode *inode)
> >  	if (IS_ERR(handle))
> >  		return;
> >  
> > -	if (inode->i_size % PAGE_CACHE_SIZE != 0) {
> > -		page_len = PAGE_CACHE_SIZE -
> > -			(inode->i_size & (PAGE_CACHE_SIZE - 1));
> > -
> > -		err = ext4_discard_partial_page_buffers(handle,
> > -			mapping, inode->i_size, page_len, 0);
> > -
> > -		if (err)
> > -			goto out_stop;
> > -	}
> > +	if (inode->i_size & (sb->s_blocksize - 1))
> > +		ext4_block_truncate_page(handle, mapping, inode->i_size);
> >  
> >  	if (ext4_orphan_add(handle, inode))
> >  		goto out_stop;
> > diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> > index 830e1b2..a082b30 100644
> > --- a/fs/ext4/indirect.c
> > +++ b/fs/ext4/indirect.c
> > @@ -1349,9 +1349,7 @@ void ext4_ind_truncate(struct inode *inode)
> >  	__le32 nr = 0;
> >  	int n = 0;
> >  	ext4_lblk_t last_block, max_block;
> > -	loff_t page_len;
> >  	unsigned blocksize = inode->i_sb->s_blocksize;
> > -	int err;
> >  
> >  	handle = start_transaction(inode);
> >  	if (IS_ERR(handle))
> > @@ -1362,16 +1360,9 @@ void ext4_ind_truncate(struct inode *inode)
> >  	max_block = (EXT4_SB(inode->i_sb)->s_bitmap_maxbytes + blocksize-1)
> >  					>> EXT4_BLOCK_SIZE_BITS(inode->i_sb);
> >  
> > -	if (inode->i_size % PAGE_CACHE_SIZE != 0) {
> > -		page_len = PAGE_CACHE_SIZE -
> > -			(inode->i_size & (PAGE_CACHE_SIZE - 1));
> > -
> > -		err = ext4_discard_partial_page_buffers(handle,
> > -			mapping, inode->i_size, page_len, 0);
> > -
> > -		if (err)
> > +	if (inode->i_size & (blocksize - 1))
> > +		if (ext4_block_truncate_page(handle, mapping, inode->i_size))
> >  			goto out_stop;
> > -	}
> >  
> >  	if (last_block != max_block) {
> >  		n = ext4_block_to_path(inode, last_block, offsets, NULL);
> > 
> 
> 
> 
