From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Mon, 03 Apr 2017 16:16:17 -0400
Message-ID: <1491250577.2673.20.camel@redhat.com>
References: <20170331192603.16442-1-jlayton@redhat.com>
         <87fuhqkti0.fsf@notabene.neil.brown.name>
         <1491215318.2724.3.camel@redhat.com>
         <20170403143257.GA30811@bombadil.infradead.org>
         <1491241657.2673.10.camel@redhat.com>
         <20170403191602.GF30811@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170403191602.GF30811@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2017-04-03 at 12:16 -0700, Matthew Wilcox wrote:
> On Mon, Apr 03, 2017 at 01:47:37PM -0400, Jeff Layton wrote:
> > > I wonder whether it's even worth supporting both EIO and ENOSPC for a
> > > writeback problem.  If I understand correctly, at the time of write(),
> > > filesystems check to see if they have enough blocks to satisfy the
> > > request, so ENOSPC only comes up in the writeback context for thinly
> > > provisioned devices.
> > 
> > No, ENOSPC on writeback can certainly happen with network filesystems.
> > NFS and CIFS have no way to reserve space. You wouldn't want to have to
> > do an extra RPC on every buffered write. :)
> 
> Aaah, yes, network filesystems.  I would indeed not want to do an extra
> RPC on every write to a hole (it's a hole vs non-hole question, rather
> than a buffered/unbuffered question ... unless you're WAFLing and not
> reclaiming quickly enough, I suppose).
> 
> So, OK, that makes sense, we should keep allowing filesystems to report
> ENOSPC as a writeback error.  But I think much of the argument below
> still holds, and we should continue to have a prior EIO to be reported
> over a new ENOSPC (even if the program has already consumed the EIO).
> 

I'm fine with that (though I'd like Neil's thoughts before we decide
anything) there.

> If you find that unconvincing, we could do something like this ...
> 
> void filemap_set_wb_error(struct address_space *mapping, int err)
> {
> 	struct inode *inode = mapping->host;
> 
> 	if (!err)
> 		return;
> 	/*
> 	 * This should be called with the error code that we want to return
> 	 * on fsync. Thus, it should always be <= 0.
> 	 */
> 	WARN_ON(err > 0);
> 
> 	spin_lock(&inode->i_lock);
> 	if (err == -EIO)
> 		mapping->wb_err |= 1;
> 	else if (err == -ENOSPC)
> 		mapping->wb_err |= 2;
> 	mapping->wb_err += 4;
> 	spin_unlock(&inode->i_lock);
> }
> 
> int filemap_report_wb_error(struct file *file)
> {
> 	struct inode *inode = file_inode(file);
> 	struct address_space *mapping = file->f_mapping;
> 	int err;
> 
> 	spin_lock(&inode->i_lock);
> 	if (file->f_wb_err == mapping->wb_err) {
> 		err = 0;
> 	} else if (mapping->wb_err & 1) {
> 		filp->f_wb_err = mapping->wb_err & ~2;
> 		err = -EIO;
> 	} else {
> 		filp->f_wb_err = mapping->wb_err;
> 		err = -ENOSPC;
> 	}
> 	spin_unlock(&inode->i_lock);
> 	return err;
> }
> 
> If I got that right, calling fsync() on an inode which has experienced
> both errors would first get an EIO.  Calling fsync() on it again would
> get an ENOSPC.  Calling fsync() on it a third time would get 0.  When
> either error occurs again, the thread will go back through the cycle
> (EIO -> ENOSPC -> 0).
> 

I don't think so? mapping->wb_err would still have 0x1 set after the
first call so you'd always end up in the first else if branch.

It's getting toward beer 30 here though so I could be misreading it.

In any case, I'd rather not do this any more cleverly than we have to.
Simpler is better here, and letting EIO override ENOSPC would be
preferable to me.

Also, since we're going to do this with 32 bit values, it might be nice
to use atomics and not need the spinlock there, especially if we want
to be able to clear that value out when the i_writecount goes to 0.

-- 
Jeff Layton <jlayton@redhat.com>
