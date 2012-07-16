From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
Date: Mon, 16 Jul 2012 14:41:41 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1207161402420.3376@eggly.anvils>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com> <1342185555-21146-2-git-send-email-lczerner@redhat.com> <20120713174209.GC17109@thunk.org> <alpine.LFD.2.00.1207160917360.5313@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1207160917360.5313@dhcp-1-248.brq.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 16 Jul 2012, Lukas Czerner wrote:
> On Fri, 13 Jul 2012, Theodore Ts'o wrote:
> > Date: Fri, 13 Jul 2012 13:42:09 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
> >     achender@linux.vnet.ibm.com
> > Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
> > 
> > Hi Lukas,
> > 
> > This patch set has changes to the VFS, XFS, and ext4, and there are
> > cross dependencies between them.  Is there any way you can disentagle
> > the dependencies between the patches so we don't need to worry about
> > how these get pulled in during the merge window?
> > 
> > I suppose could try to get the XFS folks to sign off with my carrying
> > this patch in the ext4 tree, since the bulk of the changes are
> > ext4-related, but it is a bit of a complication.
> > 
> > 	      	     	      	 - Ted
> 
> Hi Ted,
> 
> there is no VFS change, MM is probably what you've had in mind ? So
> the only reason why there are xfs, mm and tmpfs changes is that I am
> changing truncate_partial_page() and a small side effect is changed
> calling conventions.

truncate_partial_page() is static inline to mm/truncate.c:
was that a typo, or are you changing that too and I missed it?

Sorry, but I find your changes of the infinity convention from -1 to
LLONG_MAX just gratuitous and confusing (and error prone if we ever
have to backport portions to earlier stable releases).

It grieves me enough that unmap_mapping_range() has always had quite
a different convention from truncate_inode_pages_range().  You're now
proposing to give truncate_inode_pages_range() yet another convention
different from invalidate_inode_pages2_range() and
truncate_pagecache_range()?

At cost of having to make xfs and tmpfs (well, actually it's the
tiny !SHMEM ramfs case you're changing there in 03/12) dependent
on synchronizing with your other changes?

I can see that when I converted shmem_truncate_range() (later extended
to shmem_undo_range()) to partial_start and partial_end, I did put in
an ugly couple of lines
	if (lend == -1)
		end = -1;	/* unsigned, so actually very big */
but I think it's better there than "lend == -1 ? LLONG_MAX : lend;"
ugliness spread around in the filesystems.

I don't see any upside: please, could you just drop those changes,
so that then it comes down to synchronizing ext4 with mm/truncate.c?

> 
> We can push patches 3, 4, 5 and 6 through the mm tree. But we'll
> have to make sure that it will land before ext4 changes since I am
> using the new truncate_partial_page() behaviour in ext4. Will that
> be possible ?
> 
> Hugh ?

I'd like patchs 3, 4 and 5 to vanish.  As to 6 (perhaps it won't be
6 after that!), I want to work through that one myself (I'll try this
evening): it looked over-complicated to me, and I'd rather go back to
what I worked out for partial_end in shmem_truncate_range().

Then yes, if we're all happy with the result of that, it will be best
for Ted to take even the mm/truncate.c patch into his ext4 branch,
made visible in linux-next before the merge window.

We're running out of time: I'll make every effort to get back to you
on 6 after I've tested late today.

Hugh
