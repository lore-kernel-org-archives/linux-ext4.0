From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv3 15/41] filemap: handle huge pages in
 do_generic_file_read()
Date: Mon, 7 Nov 2016 07:01:03 -0800
Message-ID: <20161107150103.GA17451@infradead.org>
References: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
 <20160915115523.29737-16-kirill.shutemov@linux.intel.com>
 <20161013093313.GB26241@quack2.suse.cz>
 <20161031181035.GA7007@node.shutemov.name>
 <20161101163940.GA5459@quack2.suse.cz>
 <20161102143612.GA4790@infradead.org>
 <20161107111305.GB13280@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Theodore Ts'o <tytso@mit.edu>,
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
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20161107111305.GB13280@node.shutemov.name>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 07, 2016 at 02:13:05PM +0300, Kirill A. Shutemov wrote:
> It looks like a huge limitation to me.

The DAX PMD fault code can live just fine with it.  And without it
performance would suck anyway.

> I'm looking onto iomap_write_actor(): we still calculate 'offset' and
> 'bytes' based on PAGE_SIZE before we even get the page.
> This way we limit outself to PAGE_SIZE per-iteration.

Of course it does, given that it does not support huge pages _yet_.
But the important part is that this is now isolate to the highlevel
code, and the fs can get iomap_begin calls for a huge page (or in fact
much larger sizes than that).

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
