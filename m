From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] ext4: Fix the locking with respect to ext3 to ext4
	migrate.
Date: Wed, 12 Mar 2008 12:19:45 +0100
Message-ID: <20080312111945.GD3090@duck.suse.cz>
References: <1204887184-9902-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204888653.3627.37.camel@localhost.localdomain> <20080307113106.GA9896@skywalker> <20080307234751.GL1881@webber.adilger.int> <20080311152537.GE6544@atrey.karlin.mff.cuni.cz> <20080311165859.GA6490@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, Mingming Cao <cmm@us.ibm.com>,
	tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53569 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751420AbYCLLTs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2008 07:19:48 -0400
Content-Disposition: inline
In-Reply-To: <20080311165859.GA6490@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 11-03-08 22:28:59, Aneesh Kumar K.V wrote:
> On Tue, Mar 11, 2008 at 04:25:37PM +0100, Jan Kara wrote:
> > > On Mar 07, 2008  17:01 +0530, Aneesh Kumar K.V wrote:
> > > > On Fri, Mar 07, 2008 at 03:17:33AM -0800, Mingming Cao wrote:
> > > > > How about we start a journal with estimated worse case transaction
> > > > > credits  and then take the i_data_sem down? So that we could ensure that
> > > > > whenever the i_data_sem is hold, the i_data is protected. That is what
> > > > > currently DIO does, I think. It would be nice to avoid introducing
> > > > > another semaphore to protect i_data for migration if we could.
> > > > 
> > > > Estimating transaction for a single page directIO write may be easy. But
> > > > in case of migrate it involves new blocks allocated to carry the extents
> > > > and also we free the indirect blocks of ext3 and that would involve
> > > > update of bitmap from different groups. I am not sure we will be able to
> > > > come up with a value. But if yes and if we can get that many credits
> > > > from journal i agree that would be better than introducing a new
> > > > semaphore.
> > > 
> > > Agreed - and if we have a generic routine to calculate the journal
> > > credits needed for a full-file (or better a range) indirect block
> > > operation (including bitmaps, group descriptors, and [dt]indirect
> > > blocks).
> > > 
> > > I don't think there would be a serious failure case if it wasn't possible
> > > to convert a block-mapped file to extent-mapped while it was mmapped.
> > > At worst the administrator would need to do that some time later, or
> > > after a system reboot, so long as the conversion actually failed if the
> > > file had any mmaps.  If this same requirement is introduced when we
> > > get defrag for ext4 (because the block mapping is changing on the file)
> > > then we may have to reconsider the benefits of the more complex code.
> >   I agree here. IMHO the better option would be to just build the
> > extent-tree for converted inode on best-effort basis. If we find in
> > the end that someone has allocated new block to the file (via mmap
> > filling a hole) while we are converting, we can just cancel the
> > conversion. Because I think the cost of extra rwsem (both in terms of
> > additional memory needed for each inode structure and in time needed for
> > rwsem acquisitions) is more than I as a user would like to bear given
> > how rare the conversion is.
> > 
> Something like the below ??
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 059f2fc..a52904b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3502,9 +3502,5 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  	 * access and zero out the page. The journal handle get initialized
>  	 * in ext4_get_block.
>  	 */
> -	/* FIXME!! should we take inode->i_mutex ? Currently we can't because
> -	 * it has a circular locking dependency with DIO. But migrate expect
> -	 * i_mutex to ensure no i_data changes
> -	 */
>  	return block_page_mkwrite(vma, page, ext4_get_block);
>  }
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 5c1e27d..c6391e9 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -327,7 +327,7 @@ static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
>  }
>  
>  static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
> -				struct inode *tmp_inode)
> +				struct inode *tmp_inode, blkcnt_t total_blocks)
>  {
>  	int retval;
>  	__le32	i_data[3];
> @@ -350,6 +350,13 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
>  	i_data[2] = ei->i_data[EXT4_TIND_BLOCK];
>  
>  	down_write(&EXT4_I(inode)->i_data_sem);
> +	/* check for number of blocks */
> +	if (total_blocks  != inode->i_blocks) {
> +		retval = -EAGAIN;
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +		goto err_out;
> +
> +	}
  Hmm, I'm just wondering whether this check wouldn't be unreliable because
we can e.g. free xattr block (AFAICS this is protected only by xattr_sem)
and allocate data block. I agree with you that checking i_version isn't
good as well because it gets updated unnecessarily often and we don't
always maintain it. We could take xattr_sem to prevent the race but that
seems a bit awkward. I'm wondering whether we don't have another way
of checking whether allocation to the file changed or not.
  If there's no better way of checking, we could also do something as
follows: when we start migration, we set "MIGRATING" flag in memory for the
inode (this setting would be protected by i_data_sem). In allocation routines,
we just unconditionally clear this flag - we are again under i_data_sem so
this should be safe. In the end of migration, we check that MIGRATING flag
is still set. This should be quite lightweight and safe...

>  	/*
>  	 * We have the extent map build with the tmp inode.
>  	 * Now copy the i_data across
> @@ -445,6 +452,7 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
>  	struct inode *tmp_inode = NULL;
>  	struct list_blocks_struct lb;
>  	unsigned long max_entries;
> +	blkcnt_t total_blocks;
>  
>  	if (!test_opt(inode->i_sb, EXTENTS))
>  		/*
> @@ -508,6 +516,12 @@ int ext4_ext_migrate(struct inode *inode, struct file *filp,
>  	 * switch the inode format to prevent read.
>  	 */
>  	mutex_lock(&(inode->i_mutex));
> +	/*
> +	 * Even though we take i_mutex we can still cause block allocation
> +	 * via mmap write to holes. If we have allocated new blocks we fail
> +	 * migrate.
> +	 */
> +	total_blocks  = inode->i_blocks;
>  	handle = ext4_journal_start(inode, 1);
>  
>  	ei = EXT4_I(inode);
> @@ -561,7 +575,7 @@ err_out:
>  		free_ext_block(handle, tmp_inode);
>  	else
>  		retval = ext4_ext_swap_inode_data(handle, inode,
> -							tmp_inode);
> +						tmp_inode, total_blocks);
>  
>  	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
>  	if (ext4_journal_extend(handle, 1) != 0)

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
