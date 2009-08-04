From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: spatch for 64-bit e2fsprogs (was Re: Fix device too big bug in mainline?)
Date: Tue, 4 Aug 2009 15:58:44 -0400
Message-ID: <20090804195843.GJ9324@shell>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu> <20090803202740.GE10853@shell> <20090804144846.GE28678@mit.edu> <20090804181850.GF9324@shell> <20090804192408.GE3340@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Julia Lawall <julia@diku.dk>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Jesper Andersen <jespera@diku.dk>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbZHDT6r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 15:58:47 -0400
Content-Disposition: inline
In-Reply-To: <20090804192408.GE3340@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 04, 2009 at 01:24:08PM -0600, Andreas Dilger wrote:
> Semantic patches...  a very interesting idea.
> 
> On Aug 04, 2009  14:18 -0400, Valerie Aurora wrote:
> > // Free blocks
> > -fs->group_desc[group].bg_free_blocks_count++
> > +ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)+1)
> > |
> > -fs->group_desc[group].bg_free_blocks_count--
> > +ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)-1)
> > |
> > -fs->group_desc[group].bg_free_blocks_count += i
> > +ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)+i)
> > |
> > -fs->group_desc[group].bg_free_blocks_count -= i
> > +ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group)-i)
> 
> I wonder if it makes more sense for ext2fs to export functions like
> ext2fs_bg_free_blocks_count_add() and ext2fs_bg_free_blocks_count_sub()?

I am agnostic.

> > -fs->group_desc[group].bg_flags = 0
> > +ext2fs_bg_flags_clear(fs, group, 0)
> 
> This last one looks like an error.  To clear the flags you should
> use ext2fs_bg_flags_set(fs, group, 0), otherwise you are "clearing
> no flags".

The code does the right thing:

void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
{
        if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
                struct ext4_group_desc *gdp;
                gdp = (struct ext4_group_desc *) (fs->group_desc) + group;

                gdp->bg_flags = 0;
                return;
        }

        fs->group_desc[group].bg_flags = 0;
}

The problem is that this function is stupidly named:

ext2fs_bg_flag_clear() - does what you think
ext2fs_bg_flags_clear() - does above
              ^

It should be removed and replaced by ext2fs_bg_flags_set(), I agree.

-VAL
