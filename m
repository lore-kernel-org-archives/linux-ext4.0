From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v4 2/7] vfs: add support for a lazytime mount option
Date: Fri, 28 Nov 2014 00:36:56 -0500
Message-ID: <20141128053656.GI14091@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-3-git-send-email-tytso@mit.edu>
	<20141127131421.GE30152@quack.suse.cz>
	<20141127230016.GH14091@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20141127230016.GH14091@thunk.org>
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

On Thu, Nov 27, 2014 at 06:00:16PM -0500, Theodore Ts'o wrote:
> Well.... it's not quite enough.  The problem is that for ext3 and
> ext4, the actual work of writing the inode happens in dirty_inode(),
> not in write_inode().  Which means we need to do something like this.
> 
> I'm not entirely sure whether or not this is too ugly to live;
> personally, I think my hack of handling this in update_time() might be
> preferable....

.... and this doesn't work because it breaks ext3/ext4's transaction
handling, since the writeback thread could be racing against some
transactional update of the inode.  So I don't see a way of making the
queue_io / move_expired_inodes approach to the 24 hour time being
tractable.

So the alternatives that I can see at this point is either give up on
the 24 hour timeout, or we fall back to handling this in
update_time().

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
