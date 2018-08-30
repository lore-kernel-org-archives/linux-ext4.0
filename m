From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Thu, 30 Aug 2018 16:33:52 -0700
Message-ID: <20180830163352.5a96cc721ce069bed95fdbe8@linux-foundation.org>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: konishi.ryusuke@lab.ntt.co.jp, viro@zeniv.linux.org.uk,
        tytso@mit.edu, adilger.kernel@dilger.ca, axboe@kernel.dk,
        darrick.wong@oracle.com, ebiggers@google.com, pombredanne@nexb.com,
        agruenba@redhat.com, gregkh@linuxfoundation.org,
        kemi.wang@intel.com, willy@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 30 Aug 2018 22:55:47 +0530 Souptick Joarder <jrdr.linux@gmail.com> wrote:

> Return type for fault handlers  in ext4 and nilfs are
> changed to use vm_fault_t.
> 
> Return type of block_page_mkwrite() is changed from
> int to vm_fault_t. The function signature of
> block_page_mkwrite() is changed to add one new parameter
> int *err. This will provide a way for caller functions
> to get error value along with return value and use it
> further.
> 
> Return type of block_page_mkwrite_return() is also changed
> to use new vm_fault_t type.
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -51,13 +51,14 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	return err;
>  }
>  
> -static int nilfs_page_mkwrite(struct vm_fault *vmf)
> +static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)

nilfs_page_mkwrite() already has return type vm_fault_t in Linus's
kernel, due to the now-merged
fs-nilfs2-adding-new-return-type-vm_fault_t.patch.  Looks like a simple
fix.

I'm beginning to feel vm_fault_t exhaustion.  Please remind me what
benefit we're going to get out of all this churn?

> 
> ...
>
