From: Jan Kara <jack@suse.cz>
Subject: Re: [patch 4/5] ext2: convert to use the new truncate convention
Date: Thu, 10 Dec 2009 11:20:18 +0100
Message-ID: <20091210102017.GA3696@quack.suse.cz>
References: <20091208083832.GA19823@wotan.suse.de>
 <20091208084209.GD19823@wotan.suse.de>
 <20091209145713.GD7044@quack.suse.cz>
 <20091210011103.GB9601@nick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091210011103.GB9601@nick>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 10-12-09 12:11:03, Nick Piggin wrote:
> On Wed, Dec 09, 2009 at 03:57:13PM +0100, Jan Kara wrote:
> > On Tue 08-12-09 09:42:09, Nick Piggin wrote:
> > > I also have commented a possible bug in existing ext2 code, marked with XXX.
> > > 
> > > Cc: linux-ext4@vger.kernel.org
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > ...
> > > @@ -752,8 +764,8 @@ int __ext2_write_begin(struct file *file
> > >  		loff_t pos, unsigned len, unsigned flags,
> > >  		struct page **pagep, void **fsdata)
> > >  {
> > > -	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
> > > -							ext2_get_block);
> > > +	return block_write_begin_newtrunc(file, mapping, pos, len, flags,
> > > +					pagep, fsdata, ext2_get_block);
> > >  }
> >   OK, but you should update the code in dir.c using __ext2_write_begin,
> > shouldn't you?
> 
> To trim off blocks past i_size on failure? Yes I guess it should.
> In fact, the ext2_write_failed call could just go into here I think.
> I'll take a look.
  Yes, that would be probably the easiest.

> > > +static int ext2_write_end(struct file *file, struct address_space *mapping,
> > > +			loff_t pos, unsigned len, unsigned copied,
> > > +			struct page *page, void *fsdata)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
> > > +	if (ret < len)
> > > +		ext2_write_failed(mapping, pos + len);
> > > +	return ret;
> > >  }
> >   OK, when doing this, please also update ext2_commit_chunk in dir.c...
> 
> I think commit_chunk is OK. Because block_write_end does not fail
> and the only reason for checking failure here is in case of a short
> copy (which won't happen in dir.c code).
  Ah, right.

> > > +static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
> > > +{
> > > +	/*
> > > +	 * XXX: it seems like a bug here that we don't allow
> > > +	 * IS_APPEND inode to have blocks-past-i_size trimmed off.
> > > +	 * review and fix this.
> > > +	 *
> > > +	 * Also would be nice to be able to handle IO errors and such,
> > > +	 * but that's probably too much to ask.
> > > +	 */
> > > +	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> > > +	    S_ISLNK(inode->i_mode)))
> > > +		return;
> > > +	if (ext2_inode_is_fast_symlink(inode))
> > > +		return;
> > > +	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> > > +		return;
> >   Yes, I'd remove IS_APPEND check from here.
> 
> Didn't want to change that in this patch, but I'm happy for someone to
> fix it (and in ext3/4 etc).
  OK.

> The checks probably should be done at a different level anyway: by the
> time that this code gets called, the pagecache is truncated and i_size
> modified anyway so it seems buggy if this made any difference.
  It depends. The first if can be WARN_ON as well - we shouldn't really get
different inode types here. For fast symlinks we have nothing to truncate
so we want to immediately return doing nothing. For IMMUTABLE inode it is
again a bug if we get to this function and for APPEND inode the only
acceptable way to get here is the error recovery. We can clean that up
when your patch series goes in.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
