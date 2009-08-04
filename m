From: Julia Lawall <julia@diku.dk>
Subject: Re: spatch for 64-bit e2fsprogs (was Re: Fix device too big bug in
 mainline?)
Date: Tue, 4 Aug 2009 08:40:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0908040837260.29989@ask.diku.dk>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu>
 <20090802022209.GC8680@mit.edu> <20090803202740.GE10853@shell>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Jesper Andersen <jespera@diku.dk>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:53278 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029AbZHDGku (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 02:40:50 -0400
In-Reply-To: <20090803202740.GE10853@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Aug 2009, Valerie Aurora wrote:

> On Sat, Aug 01, 2009 at 10:22:09PM -0400, Theodore Tso wrote:
> > 
> > I also would greatly prefer it if people who submit patches to me obey
> > basic patch and code formatting guidelines.  Things like this are
> > really uncool:
> > 
> > -				fs->group_desc[i].bg_free_blocks_count =
> > -					free_array[i];
> > +				ext2fs_bg_free_blocks_count_set(fs, i, free_array[i])
> > +					;
> 
> Ah, that's left over from an spatch bug that Julia Lawall (cc'd)
> kindly fixed immediately after I reported it.  It won't happen if you
> use the current spatch.  My apologies for missing this one during
> review!
> 
> I think spatch could probably also wrap lines automatically when
> making semantic patches - Julia?

It doesn't now, but it is a good point that it probably could.  The pretty 
printing works at the token level, and thus one knows the size of 
everything.  I will look into it.

> I'm curious what you think of this proposal: Redo all the foo() ->
> foo2() patches in the entire 64-bit series as a semantic patches.
> This would also fix this kind of cut and paste bug:
> 
> +                               ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
> +                               ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
> 
> I fixed several of these in the existing 64-bit code when I took it
> over, so I assume more lurk undiscovered and would be revealed if we
> redid them with spatch.
> 
> Julia, would you and/or your students be interested in helping?  I
> think you're running out of bugs in the kernel and e2fsprogs would be
> another excellent showcase for spatch/Coccinelle. :)

Actually, my PhD student Jesper (added to CC list) could generate semantic 
patches for such things automatically.  Where can he find the normal 
patches?

julia
