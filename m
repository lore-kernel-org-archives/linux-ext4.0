From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC,PATCH 1/2] Direct IO for holes and fallocate
Date: Mon, 17 Aug 2009 19:33:14 -0400
Message-ID: <20090817233314.GA1215@mit.edu>
References: <1249916427.4337.32.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37600 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203AbZHQXdT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2009 19:33:19 -0400
Content-Disposition: inline
In-Reply-To: <1249916427.4337.32.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, here are some comments on the patch; apologies for not getting to
it sooner.

First of all, I suggest the following replacement for the patch
description.  I've rewritten it to make it clearer and more succint.
Do you think I've left anything out?

---------------

ext4: Use end_io call back to avoid direct I/O fallback to buffered I/O

From: Mingming <cmm@us.ibm.com>

Currently the DIO VFS code passes create = 0 when writing to the
middle of file.  It does this to avoid block allocation for holes, so
as not to expose stale data out when there is a parallel buffered read
(which does not hold the i_mutex lock).  Direct I/O writes into holes
falls back to buffered IO for this reason.

Since preallocated extents are treated as holes when doing a
get_block() look up (buffer is not mapped), direct IO over fallocate
also falls back to buffered IO.  Thus ext4 actually silently falls
back to buffered IO in above two cases, which is undesirable.

To fix this, this patch creates unitialized extents when a direct I/O
write needs to allocate blocks for writes that extend a file or writes
into holes in sparse files, and registering an end_io callback which
converts the uninitialized extent to an initialized extent after the
I/O is completed.

Singed-Off-By: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

-------------------

Secondly, the patch doesn't compile after applying just the first
patch.  The reason for it is that first patch references
ext4_convert_unwritten_extents(), but it is only defined in the 2nd
patch.

Other issues:

> +typedef struct ext4_io_end{
                            ^^^ add a space
> +	struct inode		*inode;		/* file being written to */
> +	unsigned int		type;		/* unwritten or written */
> +	int			error;		/* I/O error code */
> +	ext4_lblk_t		offset;		/* offset in the file */
> +	size_t			size;		/* size of the extent */
> +	struct work_struct	work;		/* data work queue */
> +}ext4_io_end_t;
  ^^^ add a space

> -
> -
> +#define EXT4_GET_BLOCKS_DIO_CREATE_EXT		0x0011
> +#define EXT4_GET_BLOCKS_DIO_CONVERT_EXT		0x0021
>  /*
>   * ioctl commands

Could you add a comment for EXT4_GET_BLOCKS_DIO_CREATE_EXT and
EXT4_GET_BLOCKS_DIO_CONVERT_EXT, like the other EXT4_GET_BLOCKS
#define's?  And a empty line before the "ioctl commands" comment would
be much appreciated.

>  /*
> + * O_DIRECT for ext3 (or indirect map) based files
> + *

Probably better just to say "O_DIRECT for direct/indirect block mapped files"

>  
> +struct workqueue_struct *ext4_unwritten_queue;

This doesn't appear to be used; it looks like you started with a
single global workqueue, and then moved to having a separate workqueue
for each filesystem.

> +static ext4_io_end_t *ext4_init_io_end (struct inode *inode, unsigned int type)
                                         ^^^ remove space


ext4_init_io_end() is only called in one place; so maybe it would be
better if it were inlined into ext4_ext_direct_IO?  It also appears
that the type field is never used, and so it can be removed from the
ext4_io_end structure.

						- Ted
