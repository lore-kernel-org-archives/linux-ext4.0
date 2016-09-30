From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 09/12] dax: correct dax iomap code namespace
Date: Fri, 30 Sep 2016 10:51:11 +0200
Message-ID: <20160930085111.GF19738@lst.de>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com> <1475189370-31634-10-git-send-email-ross.zwisler@linux.intel.com>
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
In-Reply-To: <1475189370-31634-10-git-send-email-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 29, 2016 at 04:49:27PM -0600, Ross Zwisler wrote:
> The recently added DAX functions that use the new struct iomap data
> structure were named iomap_dax_rw(), iomap_dax_fault() and
> iomap_dax_actor().  These are actually defined in fs/dax.c, though, so
> should be part of the "dax" namespace and not the "iomap" namespace.
> Rename them to dax_iomap_rw(), dax_iomap_fault() and dax_iomap_actor()
> respectively.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>

I don't really care either way, but this is trivial enought to not
introduce a bug, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
