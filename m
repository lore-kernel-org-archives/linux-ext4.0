From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RESEND][PATCH 0/3 BUG,RFC] release block-device-mapping
	buffer_heads which have the filesystem private data for avoiding
	oom-killer
Date: Tue, 25 Nov 2008 01:22:50 -0500
Message-ID: <20081125062250.GF20928@mit.edu>
References: <20081120092711.231c69bf.toshi.okajima@jp.fujitsu.com> <20081124131352.f5485398.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	viro@zeniv.linux.org.uk, sct@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081124131352.f5485398.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 24, 2008 at 01:13:52PM -0800, Andrew Morton wrote:
> 
> I'm scratching my head trying to work out why we never encountered and
> fixed this before.
> 
> Is it possible that you have a very large number of filesystems
> mounted, and/or that they have large journals?

In Okajima-san's original test case, he was running on a 128 meg
system, and created an ext3 filesystem which with a 512 meg journal.
This could very well be a "Doctor, doctor, it hurts when I do that"
sort of thing, although I can see this being a believable situation
for small NAS boxes.  Even with his patches, though, this sort of
configuration can run into memory pressure problems, since if a
transaction grows too big, too many memory pages will get pinned, and
we currently won't close a transaction early if we seem to be pinning
too much memory and we are running into memory pressure issues
(although this would be a good idea).  So his patches will postpone
the OOM killer from running, but if the journal is sufficiently large
(thus allowing sufficiently large transactions), and the amount of
memory sufficiently small, we still could run into OOM situations.

> Would it not be more logical if the ->client_releasepage function
> pointer were a member of the blockdev address_space_operations, rather
> than some random field in the blockdev inode?  That arrangement might
> well be reused in the future, when some other address_space needs to
> talk to a different address_space to make a page reclaimable.

I'm not sure how your suggestion would be implemented practically
speaking.  Right now as I undersand things the blockdev's a_ops field
is an attribute of the block device and is normally a pointer to
default_blkdev_aops.  In Okajima-san's patch, we define the blkdev's
releasepages to be a function which looks like which
client_releasepage to call in the blockdev inode.  If we put that
field in the blockdev a_ops structure, then when when we mount the
filesystem, we would have to make a copy of the blockdev's a_ops
structure so we can set the client_releasepage pointer.  That seems to
be rather inefficient and kludgy, so I don't imagine that's what you
meant.  What am I missing?

						- Ted
