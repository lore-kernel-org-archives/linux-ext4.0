From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [Cluster-devel] fallocate vs O_(D)SYNC
Date: Wed, 16 Nov 2011 09:43:08 +0000
Message-ID: <1321436588.2713.5.camel@menhir>
References: <20111116084256.GA22963@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org, cluster-devel@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111116084256.GA22963@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Wed, 2011-11-16 at 03:42 -0500, Christoph Hellwig wrote:
> It seems all filesystems but XFS ignore O_SYNC for fallocate, and never
> make sure the size update transaction made it to disk.
> 
> Given that a fallocate without FALLOC_FL_KEEP_SIZE very much is a data
> operation (it adds new blocks that return zeroes) that seems like a
> fairly nasty surprise for O_SYNC users.
> 


In GFS2 we zero out the data blocks as we go (since our metadata doesn't
allow us to mark blocks as zeroed at alloc time) and also because we are
mostly interested in being able to do FALLOC_FL_KEEP_SIZE which we use
on our rindex system file in order to ensure that there is always enough
space to expand a filesystem.

So there is no danger of having non-zeroed blocks appearing later, as
that is done before the metadata change.

Our fallocate_chunk() function calls mark_inode_dirty(inode) on each
call, so that fsync should pick that up and ensure that the metadata has
been written back. So we should thus have both data and metadata stable
on disk.

Do you have some evidence that this is not happening?

Steve.


