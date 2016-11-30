From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Subject: Re: [PATCHv5 22/36] mm, hugetlb: switch hugetlbfs to multi-order radix-tree entries
Date: Wed, 30 Nov 2016 17:48:05 +0800
Message-ID: <017501d24aee$d9a189c0$8ce49d40$@alibaba-inc.com>
References: <20161129112304.90056-1-kirill.shutemov@linux.intel.com> <20161129112304.90056-23-kirill.shutemov@linux.intel.com>
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
	"'Hugh Dickins'" <hughd@google.com>,
	"'Andrea Arcangeli'" <aarcange@redhat.com>,
	"'Dave Hansen'" <dave.hansen@intel.com>,
	"'Vlastimil Babka'" <vbabka@suse.cz>,
	"'Matthew Wilcox'" <willy@infradead.org>,
	"'Ross Zwisler'" <ross.zwisler@linux.intel.com>,
	<linux-ext4@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>,
	<linux-block@vger.kernel.org>,
	"'Naoya Horiguchi'" <n-horiguchi@ah.jp.nec.com>
To: "'Kirill A. Shutemov'" <kirill.shutemov@linux.intel.com>,
	"'Theodore Ts'o'" <tytso@mit.edu>,
	"'Andreas Dilger'" <adilger.kernel@dilger.ca>,
	"'Jan Kara'" <jack@suse.com>,
	"'Andrew Morton'" <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161129112304.90056-23-kirill.shutemov@linux.intel.com>
Content-Language: zh-cn
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday, November 29, 2016 7:23 PM Kirill A. Shutemov wrote:
> @@ -607,10 +605,10 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  		}
> 
>  		/* Set numa allocation policy based on index */
> -		hugetlb_set_vma_policy(&pseudo_vma, inode, index);
> +		hugetlb_set_vma_policy(&pseudo_vma, inode, index >> huge_page_order(h));
> 
>  		/* addr is the offset within the file (zero based) */
> -		addr = index * hpage_size;
> +		addr = index << PAGE_SHIFT & ~huge_page_mask(h);
> 
>  		/* mutex taken here, fault path and hole punch */
>  		hash = hugetlb_fault_mutex_hash(h, mm, &pseudo_vma, mapping,

Seems we can't use index in computing hash as long as it isn't in huge page size.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
