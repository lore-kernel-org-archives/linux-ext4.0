From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 1/4] fs: new infrastructure for writeback error
 handling and reporting
Date: Mon, 03 Apr 2017 11:19:51 -0400
Message-ID: <1491232791.2673.1.camel@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
         <20170331192603.16442-2-jlayton@redhat.com>
         <20170403144722.GB30811@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz, neilb@suse.com
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170403144722.GB30811@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2017-04-03 at 07:47 -0700, Matthew Wilcox wrote:
> On Fri, Mar 31, 2017 at 03:26:00PM -0400, Jeff Layton wrote:
> > This set adds a wb_error field and a sequence counter to the
> > address_space, and a corresponding sequence counter in the struct file.
> > When errors are reported during writeback, we set the error field in the
> > mapping and increment the sequence counter.
> > +++ b/fs/open.c
> > @@ -709,6 +709,9 @@ static int do_dentry_open(struct file *f,
> >  	f->f_inode = inode;
> >  	f->f_mapping = inode->i_mapping;
> >  
> > +	/* Don't need the i_lock since we're only interested in sequence */
> > +	f->f_wb_err_seq = inode->i_mapping->wb_err_seq;
> > +
> 
> Do we need READ_ONCE() though, to ensure we get a consistent view of
> wb_err_seq?  In particular, you made it 64 bit, so 32-bit architectures
> are going to have a problem if it's rolling over between 2^32-1 and 2^32.
> 

Yeah, I thought about that, and wasn't sure so I left that off. If you
think it's a good idea, then I'm fine with adding it.

> > +++ b/include/linux/fs.h
> > @@ -394,6 +394,8 @@ struct address_space {
> >  	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
> >  	struct list_head	private_list;	/* ditto */
> >  	void			*private_data;	/* ditto */
> > +	u64			wb_err_seq;
> > +	int			wb_err;
> >  } __attribute__((aligned(sizeof(long))));
> >  	/*
> >  	 * On most architectures that alignment is already the case; but
> 
> I thought we had you convinced to make wb_err_seq an s32 and do clock
> arithmetic?
> 
> > +int filemap_report_wb_error(struct file *file)
> > +{
> > +	int err = 0;
> > +	struct inode *inode = file_inode(file);
> > +	struct address_space *mapping = file->f_mapping;
> > +
> > +	spin_lock(&inode->i_lock);
> > +	if (file->f_wb_err_seq < mapping->wb_err_seq) {
> > +		err = mapping->wb_err;
> > +		file->f_wb_err_seq = mapping->wb_err_seq;
> > +	}
> > +	spin_unlock(&inode->i_lock);
> > +	return err;
> > +}
> 
> Now that I think about this some more, I don't think you even need clock
> arithmetic -- you just need !=.  And that means there's only a 1 in 2^32
> chance that you miss an error.  Good enough, I say!  Particularly since
> if errors are occurring that frequently that we wrapped the sequence
> counter, the chance that we hit that magic point are really low.
> 

> We could even combine the two (I know Dave Chinner has been really
> against growing struct address_space in the past):
> 
> int decode_wb_err(u32 wb_err)
> {
> 	if (wb_err & 1)
> 		return -EIO;
> 	if (wb_err & 2)
> 		return -ENOSPC;
> 	return 0;
> }
> 
> void set_wb_err(struct address_space *mapping, int err)
> {
> 	if (err == -EIO)
> 		mapping->wb_err |= 1;
> 	else if (err == -ENOSPC)
> 		mapping->wb_err |= 2;
> 	else
> 		return;
> 	mapping->wb_err += 4;
> }
> 
> ...
> 	if (file->f_wb_err != mapping->wb_err) {
> 		err = decode_wb_err(mapping->wb_err);
> 		file->f_wb_err = mapping->wb_err;
> 	}

Agreed. I had the same thought about checking for equality just after I
hit send last week. :)

Yes, so just to be clear here if you bump a 32 bit counter every
microsecond you'll end up wrapping in a little over an hour. How fast
can DAX generate I/O errors? :)

I'm fine with a 32 bit counter (and even with using the low order bits
to store error flags) if we're ok with that limitation. The big
question there is whether it's ok to continue reporting -EIO when there
has actually been nothing but -ENOSPC errors since the last fsync. I
think it's a corner case that's not of terribly great concern so I'm
fine with that.

We could try to mitigate it by zeroing out the value when i_writecount
goes to zero though. Then if you close all of the fds on the file, the
error is cleared. Or maybe we could add a new ioctl to explicitly zero
it out?
-- 
Jeff Layton <jlayton@redhat.com>
