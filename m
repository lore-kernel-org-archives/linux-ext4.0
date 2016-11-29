From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/6] ext2: Return BH_New buffers for zeroed blocks
Date: Tue, 29 Nov 2016 10:48:11 -0700
Message-ID: <20161129174811.GA30208@linux.intel.com>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
 <1479980796-26161-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	linux-nvdimm@lists.01.org, Johannes Weiner <hannes@cmpxchg.org>
To: Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1479980796-26161-2-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 24, 2016 at 10:46:31AM +0100, Jan Kara wrote:
> So far we did not return BH_New buffers from ext2_get_blocks() when we
> allocated and zeroed-out a block for DAX inode to avoid racy zeroing in
> DAX code. This zeroing is gone these days so we can remove the
> workaround.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
