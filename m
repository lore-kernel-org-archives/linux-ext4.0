From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv6 05/37] thp: try to free page's buffers before attempt
 split
Date: Mon, 13 Feb 2017 17:32:47 +0300
Message-ID: <20170213143247.GC20394@node.shutemov.name>
References: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
 <20170126115819.58875-6-kirill.shutemov@linux.intel.com>
 <20170209201416.GS2267@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170209201416.GS2267@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 09, 2017 at 12:14:16PM -0800, Matthew Wilcox wrote:
> On Thu, Jan 26, 2017 at 02:57:47PM +0300, Kirill A. Shutemov wrote:
> > @@ -2146,6 +2146,23 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
> >  			goto out;
> >  		}
> >  
> > +		/* Try to free buffers before attempt split */
> > +		if (!PageSwapBacked(head) && PagePrivate(page)) {
> > +			/*
> > +			 * We cannot trigger writeback from here due possible
> > +			 * recursion if triggered from vmscan, only wait.
> > +			 *
> > +			 * Caller can trigger writeback it on its own, if safe.
> > +			 */
> 
> It took me a few reads to get this.  May I suggest:
> 
> 		/*
> 		 * Cannot split a page with buffers.  If the caller has
> 		 * already started writeback, we can wait for it to finish,
> 		 * but we cannot start writeback if we were called from vmscan
> 		 */

Yeah, that's better.

> > +		if (!PageSwapBacked(head) && PagePrivate(page)) {
> 
> Also, it looks weird to test PageSwapBacked of *head* and PagePrivate
> of *page*.  I think it's correct, but it still looks weird.

I'll change this.

> Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>

Thanks!

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
