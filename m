Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36144 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbeJCXZR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 19:25:17 -0400
Date: Wed, 3 Oct 2018 12:35:58 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-mm@kvack.org,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH] mm: Fix warning in insert_pfn()
Message-ID: <20181003163557.GA18434@thunk.org>
References: <20180824154542.26872-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180824154542.26872-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 24, 2018 at 05:45:42PM +0200, Jan Kara wrote:
> In DAX mode a write pagefault can race with write(2) in the following
> way:
> 
> CPU0                            CPU1
>                                 write fault for mapped zero page (hole)
> dax_iomap_rw()
>   iomap_apply()
>     xfs_file_iomap_begin()
>       - allocates blocks
>     dax_iomap_actor()
>       invalidate_inode_pages2_range()
>         - invalidates radix tree entries in given range
>                                 dax_iomap_pte_fault()
>                                   grab_mapping_entry()
>                                     - no entry found, creates empty
>                                   ...
>                                   xfs_file_iomap_begin()
>                                     - finds already allocated block
>                                   ...
>                                   vmf_insert_mixed_mkwrite()
>                                     - WARNs and does nothing because there
>                                       is still zero page mapped in PTE
>         unmap_mapping_pages()
> 
> This race results in WARN_ON from insert_pfn() and is occasionally
> triggered by fstest generic/344. Note that the race is otherwise
> harmless as before write(2) on CPU0 is finished, we will invalidate page
> tables properly and thus user of mmap will see modified data from
> write(2) from that point on. So just restrict the warning only to the
> case when the PFN in PTE is not zero page.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I don't see this in linux-next.  What's the status of this patch?

Thanks,

					- Ted
