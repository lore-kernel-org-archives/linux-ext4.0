From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv4 18/43] block: define BIO_MAX_PAGES to HPAGE_PMD_NR if
 huge page cache enabled
Date: Wed, 26 Oct 2016 00:36:48 -0700
Message-ID: <20161026073648.GC1128@infradead.org>
References: <20161025001342.76126-1-kirill.shutemov@linux.intel.com>
 <20161025001342.76126-19-kirill.shutemov@linux.intel.com>
 <20161025072122.GA21708@infradead.org>
 <20161025125431.GA22787@node.shutemov.name>
 <BD27B76A-AF34-48B9-8D4F-F69AD2C17C66@dilger.ca>
 <CACVXFVOYXJW1c8LHiwoM9a0nLnkeeGVPUZRvs2=MohFwvhugsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Christoph Hellwig <hch@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Theodore Ts'o <tytso@mit.edu>,
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
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
To: Ming Lei <tom.leiming@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVOYXJW1c8LHiwoM9a0nLnkeeGVPUZRvs2=MohFwvhugsQ@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 26, 2016 at 03:30:05PM +0800, Ming Lei wrote:
> I am preparing for the multipage bvec support[1], and once it is ready the
> default 256 bvecs should be enough for normal cases.

Yes, multipage bvecs are defintively the way to got to efficiently
support I/O on huge pages.
