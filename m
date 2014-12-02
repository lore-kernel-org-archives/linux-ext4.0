From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
	write_time()
Date: Tue, 2 Dec 2014 10:09:12 -0500
Message-ID: <20141202150912.GA3496@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-2-git-send-email-tytso@mit.edu>
	<20141126192328.GA20436@infradead.org>
	<20141127144116.GA14091@thunk.org>
	<20141127153315.GC14091@thunk.org>
	<20141127164952.GA1622@infradead.org>
	<20141127202731.GG14091@thunk.org>
	<20141201092810.GA5538@infradead.org>
	<20141201150450.GA3337@thunk.org>
	<20141202092033.GA29712@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20141202092033.GA29712@infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 02, 2014 at 01:20:33AM -0800, Christoph Hellwig wrote:
> Why do you need the additional I_DIRTY flag?  A "lesser"
> __mark_inode_dirty should never override a stronger one.

Agreed, will fix.

> Otherwise this looks fine to me, except that I would split the default
> implementation into a new generic_update_time helper.

Sure, I can do that.

> > XFS doesn't have a ->dirty_time yet, but that way XFS would be able to
> > use the I_DIRTY_TIME flag to log the journal timestamps if it so
> > desires, and perhaps drop the need for it to use update_time().
> 
> We will probably always need a ->update_time to proide proper locking
> around the timestamp updates.

Couldn't you let the VFS set the inode timesstamps and then have xfs's
->dirty_time(inode, I_DIRTY_TIME) copy the timestamps to the on-disk
inode structure under the appropriate lock, or am I missing something?

> In the current from the generic lazytime might even be a loss for XFS as
> we're already really good at batching updates from multiple inodes in
> the same cluster for the in-place writeback, so I really don't want
> to just enable it without those optimizations without a lot of testing.

Fair enough; it's not surprising that this might be much more
effective as an optimization for ext4, for no other reason that
timestamp updates are so much heavyweight for us.  I suspect that it
should be a win for btrfs, though, and it should definitely be a win
for those file systems that don't use journalling at all.

    	       	       	    	      		     - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
