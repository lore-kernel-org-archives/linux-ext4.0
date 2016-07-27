From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCHv1, RFC 00/33] ext4: support of huge pages
Date: Wed, 27 Jul 2016 16:09:38 +0200
Message-ID: <20160727140938.lsvn6c7pwbodkeio@redhat.com>
References: <1469493335-3622-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20160726172938.GA9284@thunk.org>
 <20160726191212.GA11776@node.shutemov.name>
 <20160727091723.GG6860@quack2.suse.cz>
 <20160727103335.GE11776@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160727103335.GE11776@node.shutemov.name>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Wed, Jul 27, 2016 at 01:33:35PM +0300, Kirill A. Shutemov wrote:
> I guess you can get work 64k blocks with 4k pages if you *always* allocate
> order-4 pages for page cache of the filesystem. But I don't think it's
> sustainable. It's significant pressure on buddy allocator and compaction.

Agreed.

To guarantee compaction to succeed for a certain percentage of the RAM
kernelcore= would need to be used, but the bigger the movable zone is,
the bigger the imbalance will be, because the memory used by the
kernel cannot use the RAM that is in the movable zone. If the movable
zone is too big, early OOM failures may materialize where the kernel
hits OOM despite there's plenty of free memory in the movable zone.
So it's not ideal.

> I guess the right approach would a mechanism to scatter one block to
> multiple order-0 pages. At least for fallback.

That would be ideal to avoid having to mess with kernelcore=, because
no matter what direct compaction does (and current direction
compaction defaults wouldn't be aggressive enough anyway), without
kernelcore= the THP (or order4) allocation can fail at times.

THP always requires a fallback so that a compaction failure isn't
fatal and it can actually be fixed up later by khugepaged as more free
memory becomes available at runtime.

Thanks,
Andrea
