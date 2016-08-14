From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv2, 00/41] ext4: support of huge pages
Date: Sun, 14 Aug 2016 15:40:09 +0300
Message-ID: <20160814124009.GA16848@node.shutemov.name>
References: <1471027104-115213-1-git-send-email-kirill.shutemov@linux.intel.com>
 <638E01BE-FD45-465C-8464-2E2D96ED6787@dilger.ca>
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
	Matthew Wilcox <willy@infradead.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <638E01BE-FD45-465C-8464-2E2D96ED6787@dilger.ca>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 14, 2016 at 01:20:12AM -0600, Andreas Dilger wrote:
> On Aug 12, 2016, at 12:37 PM, Kirill A. Shutemov <kirill.shutemov@linux.intel.com> wrote:
> > 
> > Here's stabilized version of my patchset which intended to bring huge pages
> > to ext4.
> > 
> > The basics are the same as with tmpfs[1] which is in Linus' tree now and
> > ext4 built on top of it. The main difference is that we need to handle
> > read out from and write-back to backing storage.
> > 
> > Head page links buffers for whole huge page. Dirty/writeback tracking
> > happens on per-hugepage level.
> > 
> > We read out whole huge page at once. It required bumping BIO_MAX_PAGES to
> > not less than HPAGE_PMD_NR. I defined BIO_MAX_PAGES to HPAGE_PMD_NR if
> > huge pagecache enabled.
> > 
> > On split_huge_page() we need to free buffers before splitting the page.
> > Page buffers takes additional pin on the page and can be a vector to mess
> > with the page during split. We want to avoid this.
> > If try_to_free_buffers() fails, split_huge_page() would return -EBUSY.
> > 
> > Readahead doesn't play with huge pages well: 128k max readahead window,
> > assumption on page size, PageReadahead() to track hit/miss.  I've got it
> > to allocate huge pages, but it doesn't provide any readahead as such.
> > I don't know how to do this right. It's not clear at this point if we
> > really need readahead with huge pages. I guess it's good enough for now.
> 
> Typically read-ahead is a loss if you are able to get large allocations on
> disk, since you can get at least seek_rate * chunk_size throughput from the
> disks even with random IO at that size.  With 1MB allocations and 7200
> RPM drives this works out to be about 150MB/s, which is close to the
> throughput of these drive already.

I'm more worried about not about throughput, but latancy spikes once we
cross huge page boundaries. We can get cache miss where we had hit with
small pages.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
