From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Convert int to vm_fault_t type
Date: Wed, 1 Aug 2018 08:55:12 -0400
Message-ID: <20180801125512.GA10761@thunk.org>
References: <20180728085000.GA9136@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: willy@infradead.org, adilger.kernel@dilger.ca,
        darrick.wong@oracle.com, axboe@kernel.dk, agruenba@redhat.com,
        ebiggers@google.com, gregkh@linuxfoundation.org,
        kemi.wang@intel.com, sabyasachi.linux@gmail.com,
        brajeswar.linux@gmail.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180728085000.GA9136@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 28, 2018 at 02:20:00PM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for ext4_page_mkwrite
> handler and block_page_mkwrite_return.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

FYI, this patch was very sloppy, and didn't do the right thing.  That's
because of how you messed with the changing how the return codes are
now handled.

> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6108,27 +6108,27 @@ static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
>  	return !buffer_mapped(bh);
>  }
>  
> -int ext4_page_mkwrite(struct vm_fault *vmf)
> +vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct page *page = vmf->page;
>  	loff_t size;
>  	unsigned long len;
> -	int ret;
> +	vm_fault_t ret;
>  	struct file *file = vma->vm_file;
>  	struct inode *inode = file_inode(file);
>  	struct address_space *mapping = inode->i_mapping;
>  	handle_t *handle;
>  	get_block_t *get_block;
> -	int retries = 0;
> +	int retries = 0, err;

OK, ret now is a vm_fault_t, and err is an error return....

> @@ -6138,9 +6138,9 @@ int ext4_page_mkwrite(struct vm_fault *vmf)
>  		do {
>  			ret = block_page_mkwrite(vma, vmf,
>  						   ext4_da_get_block_prep);

But block_page_mkwrite() still returns an int, not a vm_fault_t....

>  -		} while (ret == -ENOSPC &&
> +		} while (ret == VM_FAULT_SIGBUS &&
>  		       ext4_should_retry_alloc(inode->i_sb, &retries));

So this is Just wrong,  This needed to be:

  		do {
  			err = block_page_mkwrite(vma, vmf,
  						   ext4_da_get_block_prep);
		} while (err == -ENOSPC &&
  		         ext4_should_retry_alloc(inode->i_sb, &retries));
		goto out_ret;

That's because out_ret is what will translate the int error code to
the vm_fault_t via:

	ret = block_page_mkwrite_return(err);

The fact that ext4_page_mkwrite() returns a vm_fault_t, while
block_page_mkwrite() returns an int which then has to get translated
into a vm_fault_t via block_page_mkwrite_return() is I suspect going
to confuse an awful lot of callers.

I'll fix up the patch, but I just wanted to call your attention to
this pitfall in the patch which confused even you as the patch author....

(BTW, the buggy patch triggered a new failure, ext4/307, which is how
I noticed that the patch was all wrong.  If you had run any kind of
static code checker you would have noticed that block_page_mkwrite()
was returning an int and that was getting assigned into a variable of
type vm_fault_t.  The fact that you *didn't* notice makes me worry
that all of this code churn may, in the end, not actually help us as
much as we thought.  :-(

     	     	    	  		      - Ted
