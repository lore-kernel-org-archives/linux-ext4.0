From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv3 12/41] thp: handle write-protection faults for file THP
Date: Tue, 11 Oct 2016 17:47:50 +0200
Message-ID: <20161011154750.GL6952@quack2.suse.cz>
References: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
 <20160915115523.29737-13-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160915115523.29737-13-kirill.shutemov@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu 15-09-16 14:54:54, Kirill A. Shutemov wrote:
> For filesystems that wants to be write-notified (has mkwrite), we will
> encount write-protection faults for huge PMDs in shared mappings.
> 
> The easiest way to handle them is to clear the PMD and let it refault as
> wriable.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  mm/memory.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 83be99d9d8a1..aad8d5c6311f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3451,8 +3451,17 @@ static int wp_huge_pmd(struct fault_env *fe, pmd_t orig_pmd)
>  		return fe->vma->vm_ops->pmd_fault(fe->vma, fe->address, fe->pmd,
>  				fe->flags);
>  
> +	if (fe->vma->vm_flags & VM_SHARED) {
> +		/* Clear PMD */
> +		zap_page_range_single(fe->vma, fe->address,
> +				HPAGE_PMD_SIZE, NULL);
> +		VM_BUG_ON(!pmd_none(*fe->pmd));
> +
> +		/* Refault to establish writable PMD */
> +		return 0;
> +	}
> +

Since we want to write-protect the page table entry on each page writeback
and write-enable then on the next write, this is relatively expensive.
Would it be that complicated to handle this fully in ->pmd_fault handler
like we do for DAX?

Maybe it doesn't have to be done now but longer term I guess it might make
sense.

Otherwise the patch looks good so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
