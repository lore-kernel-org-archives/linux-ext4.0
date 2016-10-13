From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv3 15/41] filemap: handle huge pages in
 do_generic_file_read()
Date: Thu, 13 Oct 2016 11:33:13 +0200
Message-ID: <20161013093313.GB26241@quack2.suse.cz>
References: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
 <20160915115523.29737-16-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>,
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
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160915115523.29737-16-kirill.shutemov@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 15-09-16 14:54:57, Kirill A. Shutemov wrote:
> Most of work happans on head page. Only when we need to do copy data to
> userspace we find relevant subpage.
> 
> We are still limited by PAGE_SIZE per iteration. Lifting this limitation
> would require some more work.

Hum, I'm kind of lost. Can you point me to some design document / email
that would explain some high level ideas how are huge pages in page cache
supposed to work? When are we supposed to operate on the head page and when
on subpage? What is protected by the page lock of the head page? Do page
locks of subpages play any role? If understand right, e.g.
pagecache_get_page() will return subpages but is it generally safe to
operate on subpages individually or do we have to be aware that they are
part of a huge page?

If I understand the motivation right, it is mostly about being able to mmap
PMD-sized chunks to userspace. So my naive idea would be that we could just
implement it by allocating PMD sized chunks of pages when adding pages to
page cache, we don't even have to read them all unless we come from PMD
fault path. Reclaim may need to be aware not to split pages unnecessarily
but that's about it. So I'd like to understand what's wrong with this
naive idea and why do filesystems need to be aware that someone wants to
map in PMD sized chunks...

								Honza
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  mm/filemap.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 50afe17230e7..b77bcf6843ee 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1860,6 +1860,7 @@ find_page:
>  			if (unlikely(page == NULL))
>  				goto no_cached_page;
>  		}
> +		page = compound_head(page);
>  		if (PageReadahead(page)) {
>  			page_cache_async_readahead(mapping,
>  					ra, filp, page,
> @@ -1936,7 +1937,8 @@ page_ok:
>  		 * now we can copy it to user space...
>  		 */
>  
> -		ret = copy_page_to_iter(page, offset, nr, iter);
> +		ret = copy_page_to_iter(page + index - page->index, offset,
> +				nr, iter);
>  		offset += ret;
>  		index += offset >> PAGE_SHIFT;
>  		offset &= ~PAGE_MASK;
> @@ -2356,6 +2358,7 @@ page_not_uptodate:
>  	 * because there really aren't any performance issues here
>  	 * and we need to check for errors.
>  	 */
> +	page = compound_head(page);
>  	ClearPageError(page);
>  	error = mapping->a_ops->readpage(file, page);
>  	if (!error) {
> -- 
> 2.9.3
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
