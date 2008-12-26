From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH -v3] vfs: add releasepages hooks to block devices which
	can be used by file systems
Date: Fri, 26 Dec 2008 05:01:38 +0000
Message-ID: <20081226050138.GU28946@ZenIV.linux.org.uk>
References: <20081212062148.GJ10890@mit.edu> <1229104375-11567-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1229104375-11567-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 12, 2008 at 12:52:53PM -0500, Theodore Ts'o wrote:
> From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> 
> Implement blkdev_releasepage() to release the buffer_heads and page
> after we release private data which belongs to a client of the block
> device, such as a filesystem.
> 
> blkdev_releasepage() call the client's releasepage() which is
> registered by blkdev_register_client_releasepage() to release its
> private data.
> 
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: linux-fsdevel@vger.kernel.org
Entire-pile-NAKed-by: Al Viro <viro@zeniv.linux.org.uk>

a) Use of fs_type to hide a callback is wrong.  Pass it explicitly to
whatever helper you want, don't do that crapin get_sb_bdev()

b) the same goes from unregistration

c) you are unregistering your callback before doing generic_shutdown_super().
Odd, seeing that a _lot_ of fs operations can happen at that point.

d) we *already* have exclusion mechanism.  It's called open_bdev_exclusive()
and it is used by get_sb_bdev() and friends already.  Don't reinvent the
wheel, please.

e) what's going on with the locking there?  Comments about mount/umount races
are absolutely bogus - we *have* serialization for fs shutdown/startup.  And
if we hadn't, we would have far worse problems with races than that.  The
other kind of race is possible, but... this interface is asking for trouble.
It sounds like a way to attach some data structures of your own to page and
rely on that callback for freeing them.  But as soon as somebody tries that
we'll have a problem; page can outlive the unregistration of callback and
we'll get a leak (in the best case).  Sure, ext3 and ext4 won't step into
it (journal shutdown will deal with that), but it's a trap for unaware.
At the very least it needs to be commented.

Said that, I still don't like the use of rwlock here ;-/  If nothing else,
that calls for rcu - fs shutdown is extremely rare compared to releasepage...
