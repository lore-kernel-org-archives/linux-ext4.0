From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree
Date: Tue, 17 Feb 2015 08:37:45 -0500
Message-ID: <20150217133745.GG3364@wil.cx>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
 <20150115124106.GF12739@quack.suse.cz>
 <100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com>
 <20150119141858.GF5662@quack.suse.cz>
 <20150217085200.GA23192@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Dilger, Andreas" <andreas.dilger@intel.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"boaz@plexistor.com" <boaz@plexistor.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@lst.de" <hch@lst.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Matthew Wilcox <willy@linux.intel.com>, xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:52222 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbbBQNhv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2015 08:37:51 -0500
Content-Disposition: inline
In-Reply-To: <20150217085200.GA23192@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 17, 2015 at 09:52:00AM +0100, Jan Kara wrote:
>   Matthew, I think I still didn't see response to this. I think we can
> fixup things after they are merged (since Andrew sent this patch to Linus)
> but IMHO it needs some action...

Sorry, I thought I'd replied to this.

> On Mon 19-01-15 15:18:58, Jan Kara wrote:
> > On Fri 16-01-15 21:16:03, Wilcox, Matthew R wrote:
> > > Are you sure it shouldn't be ext4_get_block_write, or _write_nolock?
> > > According to the comments, ext4_get_block() doesn't allocate
> > > uninitialized extents, which we do want it to do.
> >   Hum, so if I understand the code right dax_fault() will allocate a block
> > (== page in persistent memory) for a faulted address and will map this
> > block directly into process' address space. Thus that block has to be
> > zeroed out before the fault finishes no matter what (so that userspace
> > doesn't see garbage) - unwritten block handling in the filesystem doesn't
> > really matter (and would only cause unnecessary overhead) because of the
> > direct mapping of the block to process' address space. So I would think
> > that it would be easiest if dax_fault() simply zeroed out blocks which got
> > allocated. You could rewrite part of dax_fault() to something like:
> > 
> > 	create = !vmf->cow_page && (vmf->flags & FAULT_FLAG_WRITE);
> > 	error = get_block(inode, block, &bh, create);
> > 	if (!error && (bh.b_size < PAGE_SIZE))
> > 		error = -EIO;
> > 	if (error)
> > 		goto unlock_page;
> > 
> > 	if (buffer_new(&bh)) {
> > 		count_vm_event(PGMAJFAULT);
> > 		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> > 		major = VM_FAULT_MAJOR;
> > 		dax_clear_blocks(inode, bh->b_blocknr, PAGE_SIZE);
> > 	} else if (!buffer_mapped(&bh))
> > 		return dax_load_hole(mapping, page, vmf);
> > 
> > Note, that we also avoided calling get_block() callback twice on major fault
> > as that's relatively expensive due to locking, extent tree lookups, etc.
> > 
> > Also note that ext2 then doesn't have to call dax_clear_blocks() at all if
> > I understand the code right.

I think you've missed the case where we lose power after ext2 has
allocated the block and before dax_clear_blocks() is called.  After power
returns, ext4 will show an unwritten extent in the tree, which will be
zeroed before being handed to a user.  ext2 must have zeroed the block
before linking it into the inode's data blocks.

I didn't realise that calling get_block() was an expensive operation;
I'm open to reworking this piece of code to only call it once.

> > > This got added to fix a problem that Dave Chinner pointed out.  We need
> > > the allocated extent to either be zeroed (as ext2 does), or marked as
> > > unwritten (ext4, XFS) so that a racing read/page fault doesn't return
> > > uninitialized data.  If it's marked as unwritten, we need to convert it
> > > to a written extent after we've initialised the contents.  We use the
> > > b_end_io() callback to do this, and it's called from the DAX code, not in
> > > softirq context.
> >   OK, I see. But I didn't find where ->b_end_io gets called from dax code
> > (specifically I don't see it anywhere in dax_do_IO() or dax_io()). Can you
> > point me please?

For faults, we call it in dax_insert_mapping(), the very last thing
before returning in the fault path.  The normal I/O path gets to use
the dio_iodone_t for the same purpose.

> > Also abusing b_end_io of a phony buffer for that looks ugly to me (we are
> > trying to get away from passing phony bh around and this would entangle us
> > even more into that mess). Normally I would think that end_io() callback
> > passed into dax_do_io() should perform necessary conversions and for
> > dax_fault() we could do necessary conversions inside foofs_page_mkwrite()...

Dave sees to be the one trying the hardest to get rid of the phony BHs
... and it was his idea to (ab)use b_end_io for this.  The problem with
doing the conversion in ext4_page_mkwrite() is that we don't know at
that point whether the BH is unwritten or not.


