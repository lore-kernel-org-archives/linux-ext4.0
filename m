From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Mon, 3 Apr 2017 19:45:21 -0700
Message-ID: <20170404024521.GG30811@bombadil.infradead.org>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <87fuhqkti0.fsf@notabene.neil.brown.name>
 <1491215318.2724.3.camel@redhat.com>
 <20170403143257.GA30811@bombadil.infradead.org>
 <1491241657.2673.10.camel@redhat.com>
 <20170403191602.GF30811@bombadil.infradead.org>
 <1491250577.2673.20.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491250577.2673.20.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 03, 2017 at 04:16:17PM -0400, Jeff Layton wrote:
> On Mon, 2017-04-03 at 12:16 -0700, Matthew Wilcox wrote:
> > int filemap_report_wb_error(struct file *file)
> > {
> > 	struct inode *inode = file_inode(file);
> > 	struct address_space *mapping = file->f_mapping;
> > 	int err;
> > 
> > 	spin_lock(&inode->i_lock);
> > 	if (file->f_wb_err == mapping->wb_err) {
> > 		err = 0;
> > 	} else if (mapping->wb_err & 1) {
> > 		filp->f_wb_err = mapping->wb_err & ~2;
> > 		err = -EIO;
> > 	} else {
> > 		filp->f_wb_err = mapping->wb_err;
> > 		err = -ENOSPC;
> > 	}
> > 	spin_unlock(&inode->i_lock);
> > 	return err;
> > }
> > 
> > If I got that right, calling fsync() on an inode which has experienced
> > both errors would first get an EIO.  Calling fsync() on it again would
> > get an ENOSPC.  Calling fsync() on it a third time would get 0.  When
> > either error occurs again, the thread will go back through the cycle
> > (EIO -> ENOSPC -> 0).
> > 
> 
> I don't think so? mapping->wb_err would still have 0x1 set after the
> first call so you'd always end up in the first else if branch.
> 
> It's getting toward beer 30 here though so I could be misreading it.

Well, yes, of course you misread it.  You read what I actually wrote
instead of what I intended to write.  Silly Jeff ...

int filemap_report_wb_error(struct file *file)
{
	struct inode *inode = file_inode(file);
	struct address_space *mapping = file->f_mapping;
	int err;

	spin_lock(&inode->i_lock);
	if (file->f_wb_err == mapping->wb_err) {
		err = 0;
	} else if ((mapping->wb_err ^ file->f_wb_err) == 2) {
		filp->f_wb_err = mapping->wb_err;
		err = -ENOSPC;
	} else {
		filp->f_wb_err = mapping->wb_err & ~2;
		err = -EIO;
	}
	spin_unlock(&inode->i_lock);
	return err;
}

The read side is easier in terms of atomic ...

int filemap_report_wb_error(struct file *file)
{
	unsigned int wb_err = atomic_read(&file->f_mapping->wb_err)

	if (file->f_wb_err == wb_err)
		return 0;
	if ((file->f_wb_err ^ wb_err) == 2) {
		filp->f_wb_err = wb_err;
		return -ENOSPC;
	} else {
		filp->f_wb_err = wb_err & ~2;
		return -EIO;
	}
}

but doing the write side with an atomic looks incredibly painful.  Since
we don't actually need to make the write side scalable, I'd rather see the
write side continue to use a spinlock and do the read side this way:

int filemap_report_wb_error(struct file *file)
{
	unsigned int wb_err = READ_ONCE(file->f_mapping->wb_err)

	if (file->f_wb_err == wb_err)
		return 0;
	if ((file->f_wb_err ^ wb_err) == 2) {
		filp->f_wb_err = wb_err;
		return -ENOSPC;
	} else {
		filp->f_wb_err = wb_err & ~2;
		return -EIO;
	}
}
