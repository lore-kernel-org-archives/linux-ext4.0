From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/9] ext4: allow DAX writeback for hole punch
Date: Thu, 22 Sep 2016 08:59:43 +0200
Message-ID: <20160922065943.GA2834@quack2.suse.cz>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160823220419.11717-2-ross.zwisler@linux.intel.com>
 <20160921152244.GB10516@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nvdimm@lists.01.org,
        Matthew Wilcox <mawilcox@microsoft.com>, stable@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160921152244.GB10516@linux.intel.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 21-09-16 09:22:44, Ross Zwisler wrote:
> On Tue, Aug 23, 2016 at 04:04:11PM -0600, Ross Zwisler wrote:
> > Currently when doing a DAX hole punch with ext4 we fail to do a writeback.
> > This is because the logic around filemap_write_and_wait_range() in
> > ext4_punch_hole() only looks for dirty page cache pages in the radix tree,
> > not for dirty DAX exceptional entries.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Cc: <stable@vger.kernel.org>
> 
> Ted & Jan,
> 
> I'm still working on the latest version of the PMD work which integrates with
> the new struct iomap faults.  At this point it doesn't look like I'm going to
> make v4.9, but I think that this bug fix at least should probably go in alone?

Yeah. Ted, feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

and merge this change. Thanks!

								Honza
> >  fs/ext4/inode.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 3131747..0900cb4 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3890,7 +3890,7 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
> >  }
> >  
> >  /*
> > - * ext4_punch_hole: punches a hole in a file by releaseing the blocks
> > + * ext4_punch_hole: punches a hole in a file by releasing the blocks
> >   * associated with the given offset and length
> >   *
> >   * @inode:  File inode
> > @@ -3919,7 +3919,7 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
> >  	 * Write out all dirty pages to avoid race conditions
> >  	 * Then release them.
> >  	 */
> > -	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> > +	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> >  		ret = filemap_write_and_wait_range(mapping, offset,
> >  						   offset + length - 1);
> >  		if (ret)
> > -- 
> > 2.9.0
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
