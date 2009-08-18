From: Mingming <cmm@us.ibm.com>
Subject: Re: [RFC,PATCH 1/2] Direct IO for holes and fallocate
Date: Tue, 18 Aug 2009 15:49:14 -0700
Message-ID: <1250635754.9822.32.camel@mingming-laptop>
References: <1249916427.4337.32.camel@mingming-laptop>
	 <20090817233314.GA1215@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:56097 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZHRWtU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2009 18:49:20 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7IMjNm8014404
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 16:45:23 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7IMnIG1214258
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 16:49:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7IMnGtL021503
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 16:49:17 -0600
In-Reply-To: <20090817233314.GA1215@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-08-17 at 19:33 -0400, Theodore Tso wrote:
> OK, here are some comments on the patch; apologies for not getting to
> it sooner.
> 

Not a problem. I appreciate your feedbacks..

> First of all, I suggest the following replacement for the patch
> description.  I've rewritten it to make it clearer and more succint.
> Do you think I've left anything out?
> 

Looks cleaner and sane to me, thanks!
> ---------------
> 
> ext4: Use end_io call back to avoid direct I/O fallback to buffered I/O
> 
> From: Mingming <cmm@us.ibm.com>
> 
> Currently the DIO VFS code passes create = 0 when writing to the
> middle of file.  It does this to avoid block allocation for holes, so
> as not to expose stale data out when there is a parallel buffered read
> (which does not hold the i_mutex lock).  Direct I/O writes into holes
> falls back to buffered IO for this reason.
> 
> Since preallocated extents are treated as holes when doing a
> get_block() look up (buffer is not mapped), direct IO over fallocate
> also falls back to buffered IO.  Thus ext4 actually silently falls
> back to buffered IO in above two cases, which is undesirable.
> 
> To fix this, this patch creates unitialized extents when a direct I/O
> write needs to allocate blocks for writes that extend a file or writes
> into holes in sparse files, and registering an end_io callback which
> converts the uninitialized extent to an initialized extent after the
> I/O is completed.
> 
> Singed-Off-By: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> -------------------
> 
> Secondly, the patch doesn't compile after applying just the first
> patch.  The reason for it is that first patch references
> ext4_convert_unwritten_extents(), but it is only defined in the 2nd
> patch.
> 

Oh, yes, the ext4_convert_unwritten_extents() function is implemented in
the second patch. Drag that function into this patch will force to drag
other functions into this patch too.  Perhaps I could define a empty
ext4_convert_unwritten_extents() in the first patch for now.

> Other issues:
> 
> > +typedef struct ext4_io_end{
>                             ^^^ add a space
> > +	struct inode		*inode;		/* file being written to */
> > +	unsigned int		type;		/* unwritten or written */
> > +	int			error;		/* I/O error code */
> > +	ext4_lblk_t		offset;		/* offset in the file */
> > +	size_t			size;		/* size of the extent */
> > +	struct work_struct	work;		/* data work queue */
> > +}ext4_io_end_t;
>   ^^^ add a space
> 
Sure.

> > -
> > -
> > +#define EXT4_GET_BLOCKS_DIO_CREATE_EXT		0x0011
> > +#define EXT4_GET_BLOCKS_DIO_CONVERT_EXT		0x0021
> >  /*
> >   * ioctl commands
> 
> Could you add a comment for EXT4_GET_BLOCKS_DIO_CREATE_EXT and
> EXT4_GET_BLOCKS_DIO_CONVERT_EXT, like the other EXT4_GET_BLOCKS
> #define's?  And a empty line before the "ioctl commands" comment would
> be much appreciated.
> 

Will do.

> >  /*
> > + * O_DIRECT for ext3 (or indirect map) based files
> > + *
> 
> Probably better just to say "O_DIRECT for direct/indirect block mapped files"
> 

Sounds good.

> >  
> > +struct workqueue_struct *ext4_unwritten_queue;
> 
> This doesn't appear to be used; it looks like you started with a
> single global workqueue, and then moved to having a separate workqueue
> for each filesystem.
> 

Ah, thanks for catching this. Yes, that was my initial intention. After
moving this workqueue for each filesystem, I forget to remove the global
one.

> > +static ext4_io_end_t *ext4_init_io_end (struct inode *inode, unsigned int type)
>                                          ^^^ remove space
> 
> 
> ext4_init_io_end() is only called in one place; so maybe it would be
> better if it were inlined into ext4_ext_direct_IO? 

okay, will do.

>  It also appears
> that the type field is never used, and so it can be removed from the
> ext4_io_end structure.
> 

I was thinking maybe in the future we could use the type for delalloc
and guarded mode buffered IO ...so I define a type here, but we could
remove it from the structure now, and add it later if needed for
delalloc buffered IO.

Thanks for your review comments!

> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


