From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/11] dax: Rip out get_block based IO support
Date: Thu, 17 Nov 2016 10:45:54 +0100
Message-ID: <20161117094554.GU21785@quack2.suse.cz>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-12-git-send-email-jack@suse.cz>
 <20161116181150.GC31337@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161116181150.GC31337@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 16-11-16 11:11:50, Ross Zwisler wrote:
> On Tue, Nov 08, 2016 at 12:08:17PM +0100, Jan Kara wrote:
> > No one uses functions using the get_block callback anymore. Rip them
> > out and update documentation.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  Documentation/filesystems/dax.txt |  21 ++-
> >  fs/dax.c                          | 315 --------------------------------------
> >  include/linux/dax.h               |  12 --
> >  3 files changed, 10 insertions(+), 338 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/dax.txt b/Documentation/filesystems/dax.txt
> > index 23d18b8a49d5..b870867d0321 100644
> > --- a/Documentation/filesystems/dax.txt
> > +++ b/Documentation/filesystems/dax.txt
> > @@ -58,22 +58,21 @@ Implementation Tips for Filesystem Writers
> >  Filesystem support consists of
> >  - adding support to mark inodes as being DAX by setting the S_DAX flag in
> >    i_flags
> > -- implementing the direct_IO address space operation, and calling
> > -  dax_do_io() instead of blockdev_direct_IO() if S_DAX is set
> > +- implementing ->read_iter and ->write_iter operations which use dax_iomap_rw()
> > +  when inode has S_DAX flag set
> >  - implementing an mmap file operation for DAX files which sets the
> >    VM_MIXEDMAP and VM_HUGEPAGE flags on the VMA, and setting the vm_ops to
> > -  include handlers for fault, pmd_fault and page_mkwrite (which should
> > -  probably call dax_fault(), dax_pmd_fault() and dax_mkwrite(), passing the
> > -  appropriate get_block() callback)
> > -- calling dax_truncate_page() instead of block_truncate_page() for DAX files
> > -- calling dax_zero_page_range() instead of zero_user() for DAX files
> > +  include handlers for fault, pmd_fault, page_mkwrite, pfn_mkwrite (which
> > +  should probably call dax_iomap_fault(), dax_iomap_pmd_fault(),
> > +  dax_pfn_mkwrite() passing the appropriate iomap operations)
> 
> One tiny nit - the list of operations that the filesystem needs to support is
> 4 entries long (fault, pmd_fault, page_mkwrite, pfn_mkwrite), but the list of
> functions in DAX to call is only 3 entries long (dax_iomap_fault(),
> dax_iomap_pmd_fault(), dax_pfn_mkwrite())  This is probably because both
> fault() and page_mkwrite() end up calling dax_iomap_fault().  Can you please
> add a little text to make this clearer?

OK, added.

> Yay for getting rid of the old buffer_head based DAX code!
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
