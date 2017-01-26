From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv6 06/37] thp: handle write-protection faults for file THP
Date: Thu, 26 Jan 2017 18:57:09 +0300
Message-ID: <20170126155709.GA11239@node.shutemov.name>
References: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
 <20170126115819.58875-7-kirill.shutemov@linux.intel.com>
 <20170126154439.GB20495@bombadil.infradead.org>
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
In-Reply-To: <20170126154439.GB20495@bombadil.infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 26, 2017 at 07:44:39AM -0800, Matthew Wilcox wrote:
> On Thu, Jan 26, 2017 at 02:57:48PM +0300, Kirill A. Shutemov wrote:
> > For filesystems that wants to be write-notified (has mkwrite), we will
> > encount write-protection faults for huge PMDs in shared mappings.
> > 
> > The easiest way to handle them is to clear the PMD and let it refault as
> > wriable.
> 
> ... of course, the filesystem could implement ->pmd_fault, and then it
> wouldn't hit this case ...

I would rather get rid of ->pmd_fault/->huge_fault :)

->fault should be flexible enough to provide for all of them...

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
