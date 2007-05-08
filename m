From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Date: Tue, 08 May 2007 10:46:01 -0700
Message-ID: <1178646362.4135.17.camel@dyn9047017103.beaverton.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070507171541.5370a36a.akpm@linux-foundation.org>
	 <1178584899.3933.73.camel@dyn9047017103.beaverton.ibm.com>
	 <20070508014337.GA14072@thunk.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070508014337.GA14072@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-05-07 at 21:43 -0400, Theodore Tso wrote:
> On Mon, May 07, 2007 at 05:41:39PM -0700, Mingming Cao wrote:
> > We could check the total number of fs free blocks account before
> > preallocation happens, if there isn't enough space left, there is no
> > need to bother preallocating.
> 
> Checking against the fs free blocks is a good idea, since it will
> prevent the obvious error case where someone tries to preallocate 10GB
> when there is only 2GB left.
Think it again, this check is useful when preallocate blocks at EOF.
It's not much useful is preallocating a range with holes. In that case
2GB space might be enough if the application tries to preallocate a
10GB.

>   But it won't help if there are multiple
> processes trying to allocate blocks the same time.  On the other hand,
> that case is probably relatively rare, and in that case, the
> filesystem was probably going to be left completely full in any case.

> On Mon, May 07, 2007 at 05:15:41PM -0700, Andrew Morton wrote:
> > Userspace could presumably repair the mess in most situations by truncating
> > the file back again.  The kernel cannot do that because there might be live
> > data in amongst there.
> 
> Actually, the kernel could do it, in that could simply release all
> unitialized extents back to the system.  The problem is distinguishing
> between the unitialized extents that had just been newly added, versus
> the ones that had there from before.

True, the new uninitialized extents can be merged to the near old
uninitialized extents, there is no way to distinguish the just added
unintialized extents from the merged one.

>   (On the other hand, if the
> filesystem was completely full, releasing unitialized blocks wouldn't
> be the worse thing in the world to do, although releasing previously
> fallocated blocks probably does violate the princple of least
> surprise, even if it's what the user would have wanted.)
> 
> On Mon, May 07, 2007 at 05:41:39PM -0700, Mingming Cao wrote:
> > If there is enough free space, we could make a reservation window that
> > have at least N free blocks and mark it not stealable by other files. So
> > later we will not run into the ENOSPC error.
> 
> Could you really use a single reservation window?  When the filesystem
> is almost full, the free extents are likely going to be scattered all
> over the disk.  The general principle of grabbing all of the extents
> and keeping them in an in-memory data structure, and only adding them
> to the extent tree would work, though; I'm just not sure we could do
> it using the existing reservation window code, since it only supports
> a single reservation window per file, yes?
> 
You are right.  One reservation window per file and there is limit to
the maximum window size). So yeah this way it's not going to prevent
ENOSPC for sure:(

Mingming

