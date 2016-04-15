From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 2/5] dax: fallback from pmd to pte on error
Date: Fri, 15 Apr 2016 10:55:43 -0400
Message-ID: <x497ffy7wgg.fsf@segfault.boston.devel.redhat.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-3-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-nvdimm@ml01.01.org, Jens Axboe <axboe@fb.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
To: Vishal Verma <vishal.l.verma@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1459303190-20072-3-git-send-email-vishal.l.verma@intel.com>
	(Vishal Verma's message of "Tue, 29 Mar 2016 19:59:47 -0600")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Vishal Verma <vishal.l.verma@intel.com> writes:

> From: Dan Williams <dan.j.williams@intel.com>
>
> In preparation for consulting a badblocks list in pmem_direct_access(),
> teach dax_pmd_fault() to fallback rather than fail immediately upon
> encountering an error.  The thought being that reducing the span of the
> dax request may avoid the error region.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

> ---
>  fs/dax.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 90322eb..ec6417b 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -945,8 +945,8 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		long length = dax_map_atomic(bdev, &dax);
>  
>  		if (length < 0) {
> -			result = VM_FAULT_SIGBUS;
> -			goto out;
> +			dax_pmd_dbg(&bh, address, "dax-error fallback");
> +			goto fallback;
>  		}
>  		if (length < PMD_SIZE) {
>  			dax_pmd_dbg(&bh, address, "dax-length too small");

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
