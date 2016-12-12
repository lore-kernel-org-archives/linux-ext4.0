From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/6] mm: Invalidate DAX radix tree entries only if
 appropriate
Date: Mon, 12 Dec 2016 12:50:55 -0500
Message-ID: <20161212175054.GA8688@cmpxchg.org>
References: <20161212164708.23244-1-jack@suse.cz>
 <20161212164708.23244-3-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161212164708.23244-3-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 12, 2016 at 05:47:04PM +0100, Jan Kara wrote:
> Currently invalidate_inode_pages2_range() and invalidate_mapping_pages()
> just delete all exceptional radix tree entries they find. For DAX this
> is not desirable as we track cache dirtiness in these entries and when
> they are evicted, we may not flush caches although it is necessary. This
> can for example manifest when we write to the same block both via mmap
> and via write(2) (to different offsets) and fsync(2) then does not
> properly flush CPU caches when modification via write(2) was the last
> one.
> 
> Create appropriate DAX functions to handle invalidation of DAX entries
> for invalidate_inode_pages2_range() and invalidate_mapping_pages() and
> wire them up into the corresponding mm functions.
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
