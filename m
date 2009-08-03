From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: spatch for 64-bit e2fsprogs (was Re: Fix device too big bug in mainline?)
Date: Mon, 3 Aug 2009 18:56:24 -0400
Message-ID: <20090803225624.GC9324@shell>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu> <20090803202740.GE10853@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Theodore Tso <tytso@mit.edu>, Julia Lawall <julia@diku.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZHCW41 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Aug 2009 18:56:27 -0400
Content-Disposition: inline
In-Reply-To: <20090803202740.GE10853@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 03, 2009 at 04:27:40PM -0400, Valerie Aurora wrote:
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
> 
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

I just remembered another reason to convert to spatch: For various
reasons, I ignored several parts of e2fsprogs while doing the 64-bit
conversion.  Some of those should remain unconverted (dead code or
32-bit only code) but others should be converted.  For example, I
found some unconverted block group descriptor references in resize2fs
last week - I remember having some reason for doing it at the time but
I don't recall what it was now since it's been a few months.  Sorry!

-VAL
