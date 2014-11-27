From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
 write_time()
Date: Thu, 27 Nov 2014 15:27:31 -0500
Message-ID: <20141127202731.GG14091@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-2-git-send-email-tytso@mit.edu>
 <20141126192328.GA20436@infradead.org>
 <20141127144116.GA14091@thunk.org>
 <20141127153315.GC14091@thunk.org>
 <20141127164952.GA1622@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141127164952.GA1622@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 27, 2014 at 08:49:52AM -0800, Christoph Hellwig wrote:
> I don't think this scheme works well.  As mentioned earlier XFS doesn't
> even use vfs dirty tracking at the moment, so introducing this in a
> hidden way sounds like a bad idea.  Probably the same for btrfs.
> 
> I'd rather keep update_time as-is for now, don't add ->write_time and
> let btrfs and XFS figure out how to implement the semantics on their
> own.

I can do that, but part of the reason why we were doing this rather
involved set of changes was to allow other file systems to be able to
take advantage of lazytime.  I suppose there is value in allowing
other file systems, such as jfs, f2fs, etc., to use it, but still,
it's a bit of a shame to drop btrfs and xfs support for this feature.

I'll note by the way that ext3 and ext4 doesn't really use VFS dirty
tracking either --- see my other comments about the naming of
"mark_inode_dirty" being a bit misleading, at least for all/most of
the major file systems.  The problem seems to be that replacement
schemes that we've all using are slightly different.  :-/

I suppose should let the btrfs folks decide whether they want to add
is_readonly() and write_time() function --- or maybe help with the
cleanup work so that mark_inode_dirty() can reflect an error to its
callers.   Chris, David, what do you think?

		   	  	      	     - Ted

