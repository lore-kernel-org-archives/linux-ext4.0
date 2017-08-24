From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Date: Thu, 24 Aug 2017 16:45:44 +0200
Message-ID: <20170824144544.GE8969@quack2.suse.cz>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, Randy Dodgen <dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: rdodgen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Wed 23-08-17 14:26:52, rdodgen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Randy Dodgen <dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> If an ext4 filesystem is mounted with both the DAX and read-only
> options, executables on that filesystem will fail to start (claiming
> 'Segmentation fault') due to the fault handler returning
> VM_FAULT_SIGBUS.
> 
> This is due to the DAX fault handler (see ext4_dax_huge_fault)
> attempting to write to the journal when FAULT_FLAG_WRITE is set. This is
> the wrong behavior for write faults which will lead to a COW page; in
> particular, this fails for readonly mounts.
> 
> This change avoids journal writes for faults that are expected to COW.
> 
> It might be the case that this could be better handled in
> ext4_iomap_begin / ext4_iomap_end (called via iomap_ops inside
> dax_iomap_fault). These is some overlap already (e.g. grabbing journal
> handles).
> 
> Signed-off-by: Randy Dodgen <dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks for the verbose comment :). The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
> 
> This version is simplified as suggested by Ross; all fault sizes and fallbacks
> are handled by dax_iomap_fault.
> 
>  fs/ext4/file.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 0d7cf0cc9b87..dc1e1fb6b54c 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -279,7 +279,20 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
>  	handle_t *handle = NULL;
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	struct super_block *sb = inode->i_sb;
> -	bool write = vmf->flags & FAULT_FLAG_WRITE;
> +
> +	/*
> +	 * We have to distinguish real writes from writes which will result in a
> +	 * COW page; COW writes should *not* poke the journal (the file will not
> +	 * be changed). Doing so would cause unintended failures when mounted
> +	 * read-only.
> +	 *
> +	 * We check for VM_SHARED rather than vmf->cow_page since the latter is
> +	 * unset for pe_size != PE_SIZE_PTE (i.e. only in do_cow_fault); for
> +	 * other sizes, dax_iomap_fault will handle splitting / fallback so that
> +	 * we eventually come back with a COW page.
> +	 */
> +	bool write = (vmf->flags & FAULT_FLAG_WRITE) &&
> +		(vmf->vma->vm_flags & VM_SHARED);
>  
>  	if (write) {
>  		sb_start_pagefault(sb);
> -- 
> 2.14.1.342.g6490525c54-goog
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
