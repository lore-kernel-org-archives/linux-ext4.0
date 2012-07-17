From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
Date: Tue, 17 Jul 2012 09:53:19 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207170933370.2402@dhcp-1-248.brq.redhat.com>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com> <1342185555-21146-2-git-send-email-lczerner@redhat.com> <20120713174209.GC17109@thunk.org> <alpine.LFD.2.00.1207160917360.5313@dhcp-1-248.brq.redhat.com>
 <alpine.LSU.2.00.1207161402420.3376@eggly.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2GQHxa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jul 2012 03:53:30 -0400
In-Reply-To: <alpine.LSU.2.00.1207161402420.3376@eggly.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 16 Jul 2012, Hugh Dickins wrote:

> Date: Mon, 16 Jul 2012 14:41:41 -0700 (PDT)
> From: Hugh Dickins <hughd@google.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>,
>     Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com
> Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
> 
> On Mon, 16 Jul 2012, Lukas Czerner wrote:
> > On Fri, 13 Jul 2012, Theodore Ts'o wrote:
> > > Date: Fri, 13 Jul 2012 13:42:09 -0400
> > > From: Theodore Ts'o <tytso@mit.edu>
> > > To: Lukas Czerner <lczerner@redhat.com>
> > > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
> > >     achender@linux.vnet.ibm.com
> > > Subject: Re: [PATCH 02/12 v2] Revert "ext4: fix fsx truncate failure"
> > > 
> > > Hi Lukas,
> > > 
> > > This patch set has changes to the VFS, XFS, and ext4, and there are
> > > cross dependencies between them.  Is there any way you can disentagle
> > > the dependencies between the patches so we don't need to worry about
> > > how these get pulled in during the merge window?
> > > 
> > > I suppose could try to get the XFS folks to sign off with my carrying
> > > this patch in the ext4 tree, since the bulk of the changes are
> > > ext4-related, but it is a bit of a complication.
> > > 
> > > 	      	     	      	 - Ted
> > 
> > Hi Ted,
> > 
> > there is no VFS change, MM is probably what you've had in mind ? So
> > the only reason why there are xfs, mm and tmpfs changes is that I am
> > changing truncate_partial_page() and a small side effect is changed
> > calling conventions.
> 
> truncate_partial_page() is static inline to mm/truncate.c:
> was that a typo, or are you changing that too and I missed it?

Sorry, I meant truncate_inode_pages_range().

> 
> Sorry, but I find your changes of the infinity convention from -1 to
> LLONG_MAX just gratuitous and confusing (and error prone if we ever
> have to backport portions to earlier stable releases).
> 
> It grieves me enough that unmap_mapping_range() has always had quite
> a different convention from truncate_inode_pages_range().  You're now
> proposing to give truncate_inode_pages_range() yet another convention
> different from invalidate_inode_pages2_range() and
> truncate_pagecache_range()?
> 
> At cost of having to make xfs and tmpfs (well, actually it's the
> tiny !SHMEM ramfs case you're changing there in 03/12) dependent
> on synchronizing with your other changes?
> 
> I can see that when I converted shmem_truncate_range() (later extended
> to shmem_undo_range()) to partial_start and partial_end, I did put in
> an ugly couple of lines
> 	if (lend == -1)
> 		end = -1;	/* unsigned, so actually very big */
> but I think it's better there than "lend == -1 ? LLONG_MAX : lend;"
> ugliness spread around in the filesystems.

I find the -1 convention rather confusing and the above, as you said,
quite ugly. I seemed to me much cleaner to just send what we
actually want, which is LLONG_MAX. You're right that "lend == -1 ?
LLONG_MAX : lend;" is not pretty, but it at least gives the file
systems reason to fix that and do not use -1.

It is bad enough that zero_user_segment() and friends has absolutely
weird convention where instead of "end" you actually expect "end +
1", whereas zero_user() actually uses start + size instead. Things
like that, plus the -1, makes it easy to confuse (at least for me).

> 
> I don't see any upside: please, could you just drop those changes,
> so that then it comes down to synchronizing ext4 with mm/truncate.c?

The reason of this change to teach truncate_inode_pages_range() to
handle non page aligned ranges which we then can make use of in
ext4.

> 
> > 
> > We can push patches 3, 4, 5 and 6 through the mm tree. But we'll
> > have to make sure that it will land before ext4 changes since I am
> > using the new truncate_partial_page() behaviour in ext4. Will that
> > be possible ?
> > 
> > Hugh ?
> 
> I'd like patchs 3, 4 and 5 to vanish.  As to 6 (perhaps it won't be
> 6 after that!), I want to work through that one myself (I'll try this
> evening): it looked over-complicated to me, and I'd rather go back to
> what I worked out for partial_end in shmem_truncate_range().

The code in the shmem_undo_range() is really similar, except it is
not able to handle offset of LLONG_MAX, or actually even the last
page with this offset, but truncate_inode_pages_range() obviously
does. But again, there is the confusion with the "end" being "end + 1"
which seems odd.

> 
> Then yes, if we're all happy with the result of that, it will be best
> for Ted to take even the mm/truncate.c patch into his ext4 branch,
> made visible in linux-next before the merge window.
> 
> We're running out of time: I'll make every effort to get back to you
> on 6 after I've tested late today.

Great, thanks Hugh.

-Lukas

> 
> Hugh
> 
