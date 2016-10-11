From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 09/17] dax: coordinate locking for offsets in PMD range
Date: Tue, 11 Oct 2016 09:04:09 +0200
Message-ID: <20161011070409.GC6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-10-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>,
	Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1475874544-24842-10-git-send-email-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri 07-10-16 15:08:56, Ross Zwisler wrote:
> DAX radix tree locking currently locks entries based on the unique
> combination of the 'mapping' pointer and the pgoff_t 'index' for the entry.
> This works for PTEs, but as we move to PMDs we will need to have all the
> offsets within the range covered by the PMD to map to the same bit lock.
> To accomplish this, for ranges covered by a PMD entry we will instead lock
> based on the page offset of the beginning of the PMD entry.  The 'mapping'
> pointer is still used in the same way.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just one thing which IMO deserves a comment below:

> @@ -448,9 +460,12 @@ restart:
>  }
>  
>  void dax_wake_mapping_entry_waiter(struct address_space *mapping,
> -				   pgoff_t index, bool wake_all)
> +		pgoff_t index, void *entry, bool wake_all)
>  {
> -	wait_queue_head_t *wq = dax_entry_waitqueue(mapping, index);
> +	struct exceptional_entry_key key;
> +	wait_queue_head_t *wq;
> +
> +	wq = dax_entry_waitqueue(mapping, index, entry, &key);

So I believe we should comment above this function that the 'entry' it gets
may be invalid by the time it gets it (we call it without tree_lock held so
the passed entry may be changed in the radix tree as we work) but we use it
only to find appropriate waitqueue where tasks sleep waiting for that old
entry to unlock so we indeed wake up all tasks we need.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
