From: tytso@mit.edu
Subject: Re: [PATCH v7 19/22] ext4: Make ext4_block_zero_page_range static
Date: Mon, 24 Mar 2014 15:11:59 -0400
Message-ID: <20140324191158.GC6896@thunk.org>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <6ae0bcd05c2e114d3c4a7803415b6c2c8a8dadd7.1395591795.git.matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, willy@linux.intel.com,
	linux-ext4@vger.kernel.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <6ae0bcd05c2e114d3c4a7803415b6c2c8a8dadd7.1395591795.git.matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Mar 23, 2014 at 03:08:45PM -0400, Matthew Wilcox wrote:
> It's only called within inode.c, so make it static, remove its prototype
> from ext4.h and move it above all of its callers so it doesn't need a
> prototype within inode.c.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

Thanks, applied to the ext4 tree.

					- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
