From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv6 03/37] page-flags: relax page flag policy for few flags
Date: Mon, 13 Feb 2017 16:59:50 +0300
Message-ID: <20170213135950.GB20394@node.shutemov.name>
References: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
 <20170126115819.58875-4-kirill.shutemov@linux.intel.com>
 <20170209040113.GR2267@bombadil.infradead.org>
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
In-Reply-To: <20170209040113.GR2267@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 08, 2017 at 08:01:13PM -0800, Matthew Wilcox wrote:
> On Thu, Jan 26, 2017 at 02:57:45PM +0300, Kirill A. Shutemov wrote:
> > These flags are in use for filesystems with backing storage: PG_error,
> > PG_writeback and PG_readahead.
> 
> Oh ;-)  Then I amend my comment on patch 1 to be "patch 3 needs to go
> ahead of patch 1" ;-)

It doesn't really matter as long as both before patch 37 :P

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
