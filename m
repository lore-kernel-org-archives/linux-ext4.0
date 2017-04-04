From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Tue, 04 Apr 2017 14:08:54 -0400
Message-ID: <1491329334.309.6.camel@redhat.com>
References: <1491215318.2724.3.camel@redhat.com>
         <20170403143257.GA30811@bombadil.infradead.org>
         <1491241657.2673.10.camel@redhat.com>
         <20170403191602.GF30811@bombadil.infradead.org>
         <1491250577.2673.20.camel@redhat.com>
         <87h924kh6t.fsf@notabene.neil.brown.name>
         <20170404115358.GH30811@bombadil.infradead.org>
         <1491308268.20445.4.camel@redhat.com>
         <20170404161247.GJ30811@bombadil.infradead.org>
         <1491323146.309.1.camel@redhat.com>
         <20170404170909.GK30811@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170404170909.GK30811@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-04-04 at 10:09 -0700, Matthew Wilcox wrote:
> On Tue, Apr 04, 2017 at 12:25:46PM -0400, Jeff Layton wrote:
> > That said, I think giving more specific errors where we can is useful.
> > When your program is erroring out and writing 'I/O error' to the logs,
> > then how much time will your admins burn before they figure out that it
> > really failed because the filesystem was full?
> 
> df is one of the first things I check ... a few years ago, I also learned
> to check df -i ... ;-)
> 
> Anyway, given the decision to simply report the last error lets us do this
> implementation:
> 
> void filemap_set_wb_error(struct address_space *mapping, int err)
> {
> 	struct inode *inode = mapping->host;
> 	unsigned int wb_err;
> 
> 	if (!err)
> 		return;
> 	/*
> 	 * This should be called with the error code that we want to return
> 	 * on fsync. Thus, it should always be <= 0.
> 	 */
> 	WARN_ON(err > 0 || err < -MAX_ERRNO);
> 
> 	spin_lock(&inode->i_lock);
> 	wb_err = ((mapping->wb_err & ~MAX_ERRNO) + (1 << 12)) | -err;
> 	WRITE_ONCE(mapping->wb_err, wb_err);

Do we need the WRITE_ONCE, given that you're under a spinlock there?

> 	spin_unlock(&inode->i_lock);
> }
> 
> int filemap_report_wb_error(struct file *file)
> {
> 	struct inode *inode = file_inode(file);
> 	unsigned int wb_err = READ_ONCE(mapping->wb_err);
> 
> 	if (file->f_wb_err == wb_err)
> 		return 0;
> 	return -(wb_err & 4095);
> }
> 
> That only gives us 20 bits of counter, but I think that's enough.

That'd be fine with me, but I'm all for allowing filesystems to return
arbitrary writeback errors on fsync.

Others may have different opinions there. We could add a wrapper
function that sanitizes the error codes if some filesystems wanted that
though.

-- 
Jeff Layton <jlayton@redhat.com>
