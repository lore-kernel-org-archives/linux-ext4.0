From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3] ext4: Rewrite ext4_page_mkwrite() to use generic
 helpers
Date: Thu, 23 Jun 2011 13:09:18 +0200
Message-ID: <20110623110918.GB4229@quack.suse.cz>
References: <1308767062-27695-1-git-send-email-jack@suse.cz>
 <20110623103937.GB5171@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759168Ab1FWLJV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jun 2011 07:09:21 -0400
Content-Disposition: inline
In-Reply-To: <20110623103937.GB5171@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 23-06-11 06:39:37, Christoph Hellwig wrote:
> >  	loff_t size;
> >  	unsigned long len;
> > +	int ret;
> >  	struct file *file = vma->vm_file;
> >  	struct inode *inode = file->f_path.dentry->d_inode;
> >  	struct address_space *mapping = inode->i_mapping;
> > +	handle_t *handle;
> > +	get_block_t *get_block;
> > +	int retries = 0;
> >  
> >  	/*
> > +	 * This check is racy but catches the common case. We rely on
> > +	 * __block_page_mkwrite() to do a reliable check.
> >  	 */
> > +	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> > +	/* Delalloc case is easy... */
> > +	if (test_opt(inode->i_sb, DELALLOC) &&
> > +	    !ext4_should_journal_data(inode) &&
> > +	    !ext4_nonda_switch(inode->i_sb)) {
> > +		do {
> > +			ret = __block_page_mkwrite(vma, vmf,
> > +						   ext4_da_get_block_prep);
> > +		} while (ret == -ENOSPC &&
> > +		       ext4_should_retry_alloc(inode->i_sb, &retries));
> > +		goto out_ret;
> 
> Is there any way to simply provide a different vm_operations_struct
> and thus ->fault implementation for the delalloc vs non-delalloc case?
> 
> I think splitting those two cases completely would make the code a lot
> more readable, even if there is a tiny amount of code duplication.
  The trouble is that ext4 falls backs to standard allocation instead of
delayed allocation when we run low on free space. So complete separation
of these two cases is not possible. Also inode data journal flag can be
set on the fly so we have to check it even in delalloc mkwrite
implementation.

So what we could do is to have:
ext4_da_page_mkwrite() which will fall back to ext4_page_mkwrite() in
some special cases. Not sure how big readability win that is...

								Honza

PS: I've just realized that ext4_nonda_switch() used in the new code still
calls writeback code so my comment about ext4_da_write_begin() in the
change log is kind of moot. Can you please remove that sentence? Thanks.
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
