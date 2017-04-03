From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Mon, 3 Apr 2017 12:16:02 -0700
Message-ID: <20170403191602.GF30811@bombadil.infradead.org>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <87fuhqkti0.fsf@notabene.neil.brown.name>
 <1491215318.2724.3.camel@redhat.com>
 <20170403143257.GA30811@bombadil.infradead.org>
 <1491241657.2673.10.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46058 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdDCTQE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Apr 2017 15:16:04 -0400
Content-Disposition: inline
In-Reply-To: <1491241657.2673.10.camel@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 03, 2017 at 01:47:37PM -0400, Jeff Layton wrote:
> > I wonder whether it's even worth supporting both EIO and ENOSPC for a
> > writeback problem.  If I understand correctly, at the time of write(),
> > filesystems check to see if they have enough blocks to satisfy the
> > request, so ENOSPC only comes up in the writeback context for thinly
> > provisioned devices.
> 
> No, ENOSPC on writeback can certainly happen with network filesystems.
> NFS and CIFS have no way to reserve space. You wouldn't want to have to
> do an extra RPC on every buffered write. :)

Aaah, yes, network filesystems.  I would indeed not want to do an extra
RPC on every write to a hole (it's a hole vs non-hole question, rather
than a buffered/unbuffered question ... unless you're WAFLing and not
reclaiming quickly enough, I suppose).

So, OK, that makes sense, we should keep allowing filesystems to report
ENOSPC as a writeback error.  But I think much of the argument below
still holds, and we should continue to have a prior EIO to be reported
over a new ENOSPC (even if the program has already consumed the EIO).

If you find that unconvincing, we could do something like this ...

void filemap_set_wb_error(struct address_space *mapping, int err)
{
	struct inode *inode = mapping->host;

	if (!err)
		return;
	/*
	 * This should be called with the error code that we want to return
	 * on fsync. Thus, it should always be <= 0.
	 */
	WARN_ON(err > 0);

	spin_lock(&inode->i_lock);
	if (err == -EIO)
		mapping->wb_err |= 1;
	else if (err == -ENOSPC)
		mapping->wb_err |= 2;
	mapping->wb_err += 4;
	spin_unlock(&inode->i_lock);
}

int filemap_report_wb_error(struct file *file)
{
	struct inode *inode = file_inode(file);
	struct address_space *mapping = file->f_mapping;
	int err;

	spin_lock(&inode->i_lock);
	if (file->f_wb_err == mapping->wb_err) {
		err = 0;
	} else if (mapping->wb_err & 1) {
		filp->f_wb_err = mapping->wb_err & ~2;
		err = -EIO;
	} else {
		filp->f_wb_err = mapping->wb_err;
		err = -ENOSPC;
	}
	spin_unlock(&inode->i_lock);
	return err;
}

If I got that right, calling fsync() on an inode which has experienced
both errors would first get an EIO.  Calling fsync() on it again would
get an ENOSPC.  Calling fsync() on it a third time would get 0.  When
either error occurs again, the thread will go back through the cycle
(EIO -> ENOSPC -> 0).

> > Programs have basically no use for the distinction.  In either case,
> > the situation is the same.  The written data is safely in RAM and cannot
> > be written to the storage.  If one were to make superhuman efforts,
> > one could mmap the file and write() it to a different device, but that
> > is incredibly rare.  For most programs, the response is to just die and
> > let the human deal with the corrupted file.
> > 
> > From a sysadmin point of view, of course the situation is different,
> > and the remedy is different, but they should be getting that information
> > through a different mechanism than monitoring the errno from every
> > system call.
> > 
> > If we do want to continue to support both EIO and ENOSPC from writeback,
> > then let's have EIO override ENOSPC as an error.  ie if an ENOSPC comes
> > in after an EIO is set, it only bumps the counter and applications will
> > see EIO, not ENOSPC on fresh calls to fsync().
