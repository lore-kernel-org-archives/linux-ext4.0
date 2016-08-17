From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: allow DAX writeback for hole punch
Date: Wed, 17 Aug 2016 19:19:55 +0200
Message-ID: <20160817171955.GA30893@quack2.suse.cz>
References: <20160817161102.2185-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Dan Williams <dan.j.williams@intel.com>,
	Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	linux-nvdimm@lists.01.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160817161102.2185-1-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 17-08-16 10:11:02, Ross Zwisler wrote:
> Currently when doing a DAX hole punch with ext4 we fail to do a writeback.
> This is because the logic around filemap_write_and_wait_range() in
> ext4_punch_hole() only looks for dirty page cache pages in the radix tree,
> not for dirty DAX exceptional entries.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks. The patch looks correct, you can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Although why don't we just simplify the test below to
mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)? After all the mapping should
not have the dirty tag set if there are no pages / no entries?

								Honza

> @@ -3919,7 +3919,9 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>  	 * Write out all dirty pages to avoid race conditions
>  	 * Then release them.
>  	 */
> -	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> +	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
> +	    ((!dax_mapping(mapping) && mapping->nrpages) ||
> +	     (dax_mapping(mapping) && mapping->nrexceptional))) {
>  		ret = filemap_write_and_wait_range(mapping, offset,
>  						   offset + length - 1);
>  		if (ret)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
