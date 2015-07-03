From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 3/6] ext4: Use ext4_get_block_write() for DAX
Date: Fri, 3 Jul 2015 14:30:27 -0400
Message-ID: <20150703183027.GH9456@thunk.org>
References: <1435934443-17090-1-git-send-email-matthew.r.wilcox@intel.com>
 <1435934443-17090-4-git-send-email-matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435934443-17090-4-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 03, 2015 at 10:40:40AM -0400, Matthew Wilcox wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> DAX relies on the get_block function either zeroing newly allocated blocks
> before they're findable by subsequent calls to get_block, or marking newly
> allocated blocks as unwritten.  ext4_get_block() cannot create unwritten
> extents, but ext4_get_block_write() can.

To be clear, this patch has no prerequistes or dependencies, right?
That is, it would be fine if I take this through the ext4 git tree?
Or is there a reason or a preference for carrying this patch
somewhere else?

Also, is there a way I can test the DAX functionality in ext4 using
KVM?  If so, can you give me a cheat sheet about how I can do that?

Thanks,

							- Ted
