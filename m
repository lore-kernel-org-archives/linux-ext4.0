From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
 write_time()
Date: Mon, 24 Nov 2014 10:56:58 -0500
Message-ID: <20141124155658.GA31339@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-2-git-send-email-tytso@mit.edu>
 <20141124152101.GA12575@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141124152101.GA12575@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 24, 2014 at 07:21:01AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 21, 2014 at 02:59:21PM -0500, Theodore Ts'o wrote:
> > We needed to preserve update_time() because btrfs wants to have a
> > special btrfs_root_readonly() check; otherwise we could drop the
> > update_time() inode operation entirely.
> 
> Can't btrfs just set the immutable flag on every inode that is read
> when the root has the BTRFS_ROOT_SUBVOL_RDONLY flag?  That would
> cut down the places that need this check to the ioctl path so that
> we prevent users from clearling the immutable flag.

Sounds like a good plan to me, although I'm not sure I understand how
BTRFS_ROOT_SUBVOL_RDONLY flag works, since I would have thought there
are all sorts of places in the VFS layer where it is currently
checking MS_RDONLY and MNT_READONLY and _not_ checking
BTRFS_ROOT_SUBVOL_RDONLY isn't causing other problems.

But unless there's something more subtle going on, it would seem to me
that setting the immutable flag on each inode would be a better way to
go in any case.

					- Ted
