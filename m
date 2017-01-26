From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCHv6 02/37] Revert "radix-tree: implement
 radix_tree_maybe_preload_order()"
Date: Thu, 26 Jan 2017 07:38:06 -0800
Message-ID: <20170126153805.GA20495@bombadil.infradead.org>
References: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
 <20170126115819.58875-3-kirill.shutemov@linux.intel.com>
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
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-block@vger.kernel.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170126115819.58875-3-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 26, 2017 at 02:57:44PM +0300, Kirill A. Shutemov wrote:
> This reverts commit 356e1c23292a4f63cfdf1daf0e0ddada51f32de8.
> 
> After conversion of huge tmpfs to multi-order entries, we don't need
> this anymore.

Yay!  Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
