From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCHv6 10/37] filemap: handle huge pages in
 filemap_fdatawait_range()
Date: Thu, 9 Feb 2017 15:03:58 -0800
Message-ID: <20170209230358.GY2267@bombadil.infradead.org>
References: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
 <20170126115819.58875-11-kirill.shutemov@linux.intel.com>
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
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170126115819.58875-11-kirill.shutemov@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 26, 2017 at 02:57:52PM +0300, Kirill A. Shutemov wrote:
> @@ -405,9 +405,14 @@ static int __filemap_fdatawait_range(struct address_space *mapping,
>  			if (page->index > end)
>  				continue;
>  
> +			page = compound_head(page);
>  			wait_on_page_writeback(page);
>  			if (TestClearPageError(page))
>  				ret = -EIO;
> +			if (PageTransHuge(page)) {
> +				index = page->index + HPAGE_PMD_NR;
> +				i += index - pvec.pages[i]->index - 1;
> +			}
>  		}

I'm really not sure about your decision to have some interfaces expose
subpages and other expose huge pages.  I think I'd be happier to see
all the existing interfaces made to continue exposing subpages, then
start adding in new interfaces and converting users one at a time
to use them.  For example here, we'd add find_get_huge_pages_tag(),
then pagevec_lookup_huge_tag(), and switch this function from calling
pagevec_lookup_tag() to calling pagevec_lookup_huge_tag() ... then this
function is done; there's no messing around with calling compound_head
or PageTransHuge.

My dream is that eventually all callers will be able to cope with getting
a compound page back from the page cache and we can delete the versions
that return subpages, and rename the 'huge_' variations.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
