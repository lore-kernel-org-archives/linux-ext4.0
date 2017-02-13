From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCHv6 08/37] filemap: handle huge pages in
 do_generic_file_read()
Date: Mon, 13 Feb 2017 08:01:17 -0800
Message-ID: <20170213160117.GA6416@bombadil.infradead.org>
References: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
 <20170126115819.58875-9-kirill.shutemov@linux.intel.com>
 <20170209215505.GW2267@bombadil.infradead.org>
 <20170213153342.GE20394@node.shutemov.name>
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
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170213153342.GE20394@node.shutemov.name>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 13, 2017 at 06:33:42PM +0300, Kirill A. Shutemov wrote:
> No. pagecache_get_page() returns subpage. See description of the first
> patch.

Your description says:

> We also change interface for page-cache lookup function:
> 
>   - functions that lookup for pages[1] would return subpages of THP
>     relevant for requested indexes;
> 
>   - functions that lookup for entries[2] would return one entry per-THP
>     and index will point to index of head page (basically, round down to
>     HPAGE_PMD_NR);
> 
> This would provide balanced exposure of multi-order entires to the rest
> of the kernel.
> 
> [1] find_get_pages(), pagecache_get_page(), pagevec_lookup(), etc.
> [2] find_get_entry(), find_get_entries(), pagevec_lookup_entries(), etc.

I'm saying:

> > We got this page from find_get_page(), which gets it from
> > pagecache_get_page(), which gets it from find_get_entry() ... which
> > (unless I'm lost in your patch series) returns the head page.

Am I guilty of debugging documentation rather than code?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
