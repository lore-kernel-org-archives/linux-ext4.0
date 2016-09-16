From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv3 29/41] ext4: make ext4_mpage_readpages() hugepage-aware
Date: Fri, 16 Sep 2016 15:17:40 +0300
Message-ID: <20160916121740.GA18021@node.shutemov.name>
References: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
 <20160915115523.29737-30-kirill.shutemov@linux.intel.com>
 <56332284-449B-4998-AA99-245361CEE6D9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-block@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56332284-449B-4998-AA99-245361CEE6D9@dilger.ca>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 15, 2016 at 06:27:10AM -0600, Andreas Dilger wrote:
> On Sep 15, 2016, at 5:55 AM, Kirill A. Shutemov <kirill.shutemov@linux.intel.com> wrote:
> > 
> > This patch modifies ext4_mpage_readpages() to deal with huge pages.
> > 
> > We read out 2M at once, so we have to alloc (HPAGE_PMD_NR *
> > blocks_per_page) sector_t for that. I'm not entirely happy with kmalloc
> > in this codepath, but don't see any other option.
> 
> If you're reading 2MB from disk (possibly from disjoint blocks with seeks
> in between) I don't think that the kmalloc() is going to be the limiting
> performance factor.  If you are concerned about the size of the kmalloc()
> causing failures when pages are fragmented (it can be 16KB for 1KB blocks
> with 4KB pages), then using ext4_kvmalloc() to fall back to vmalloc() in
> case kmalloc() fails.  It shouldn't fail often for 16KB allocations,
> but it could in theory.

Good point. Will use ext4_kvmalloc().

> I also notice that ext4_kvmalloc() should probably use unlikely() for
> the failure case, so that the uncommon vmalloc() fallback is out-of-line
> in this more important codepath.  The only other callers are during mount,
> so a branch misprediction is not critical.

I agree. But it's out-of-scope for the patchset.

-- 
 Kirill A. Shutemov
