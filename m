From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Sync does not flush to disk!?
Date: Fri, 8 Jun 2012 14:28:26 -0400
Message-ID: <20120608182826.GA31636@thunk.org>
References: <4FD1CB8A.9080805@shiftmail.org>
 <20120608223332.5fe49193@notabene.brown>
 <4FD202CD.7000309@turmel.org>
 <4FD204B0.3000204@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.de>,
	linux-raid <linux-raid@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FD204B0.3000204@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 08, 2012 at 03:57:04PM +0200, Asdo wrote:
> 
> I might say that it seems to me a bad design: never before I saw a
> cache that is not updated by writes.
> Here the cache content is *older* than the data on the real devices!?
> if it was *newer*, there are known cases (writeback cache not
> flushed yet), but *older*... never seen.

It's not just a matter of keeping the caches in sync --- it's also a
simple matter of locking.  If a file system is mounted on two systems
at the same time, there's no way (without using a cluster lock
manager, which is what a cluster file system like ocfs2 uses) to avoid
both systems from trying to modify a particular of the file system (an
inode or a directory, for example) at the same time.

As a result, there's no way for a local disk file system to know when
a block has been modified out from under it, so that it can update its
inode cache (where the in-memory inode data structure looks quite
different from the on-disk inode table).

There is overhead in using a cluster file system, since it has to do
all of these extra checks to see if the block device has gotten
magically modified out from under it.  So that's why most people won't
use a cluster file system if it is only going to be mounted on one
system at a time.

But if you are going to have a file system mounted in both the guest
and host file system at the same time, you *have* to use a cluster
file system.  Alternately, you could have the guest access the file
system as mounted on the host OS via NFS.

Regards,

						- Ted
