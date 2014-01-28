From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v5 22/22] XIP: Add support for unwritten extents
Date: Mon, 27 Jan 2014 20:49:00 -0700
Message-ID: <20140128034859.GC20939@parisc-linux.org>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com> <CEFD7DAD.22F65%matthew.r.wilcox@intel.com> <alpine.OSX.2.00.1401221546240.70541@scrumpy> <CF0C370C.235F1%willy@linux.intel.com> <alpine.OSX.2.00.1401271617570.9254@scrumpy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1401271617570.9254@scrumpy>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 27, 2014 at 04:32:07PM -0700, Ross Zwisler wrote:
> It looks like we have an additional bit of complexity with the hole case.  The
> issue is that for holes, bh->b_size is just the full size of the write as set
> earlier in the function:
> 
>                         bh->b_size = ALIGN(end - offset, PAGE_SIZE);
> 
> >From this code it seems like you hoped the call into get_block() would adjust
> bh->b_size to the size of the hole, allowing you to zero just the hole space
> in the user buffer.  It doesn't look like it does, though, at least for ext4.

Argh.  I got confused.  ext4 *has* this information, it just doesn't
propagate it into the bh if it's a hole!  Should it?  The comments in
the direct IO code imply that it *may*, but doesn't *have* to.  What it's
doing now (not touching it) is probably wrong.

> To just assume the current FS block is a hole, we can do something like this:

Yes, this should fix things on an interim basis.  Bit inefficient,
but it'll work.

> diff --git a/fs/xip.c b/fs/xip.c
> index 35e401e..e902593 100644
> --- a/fs/xip.c
> +++ b/fs/xip.c
> @@ -122,7 +122,7 @@ static ssize_t xip_io(int rw, struct inode *inode, const struct
>  
>                         if (hole) {
>                                 addr = NULL;
> -                               size = bh->b_size - first;
> +                               size = (1 << inode->i_blkbits) - first;
>                         } else {
>                                 retval = xip_get_addr(inode, bh, &addr);
>                                 if (retval < 0)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
