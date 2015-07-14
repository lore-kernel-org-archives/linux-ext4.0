From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Return the length of a hole from get_block
Date: Tue, 14 Jul 2015 11:02:46 +0200
Message-ID: <20150714090246.GA24369@quack.suse.cz>
References: <1435936511-17705-1-git-send-email-matthew.r.wilcox@intel.com>
 <20150713151610.GC17075@quack.suse.cz>
 <20150713152615.GH13681@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbbGNJCt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jul 2015 05:02:49 -0400
Content-Disposition: inline
In-Reply-To: <20150713152615.GH13681@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 13-07-15 11:26:15, Matthew Wilcox wrote:
> On Mon, Jul 13, 2015 at 05:16:10PM +0200, Jan Kara wrote:
> > On Fri 03-07-15 11:15:11, Matthew Wilcox wrote:
> > > From: Matthew Wilcox <willy@linux.intel.com>
> > > 
> > > Currently, if ext4's get_block encounters a hole, it does not modify the
> > > buffer_head.  That's fine for many callers, but for DAX, it's useful to
> > > know how large the hole is.  XFS already returns the length of the hole,
> > > so this improvement should not confuse any callers.
> > > 
> > > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > 
> > So I'm somewhat wondering: What is the reason of BH_Uptodate flag being
> > set? I can see the XFS sets it in some cases as well but the use of the
> > flag isn't really clear to me...
> 
> No clue.  I'm just following the documentation in buffer.c:
> 
>  * NOTE! All mapped/uptodate combinations are valid:
>  *
>  *      Mapped  Uptodate        Meaning
>  *
>  *      No      No              "unknown" - must do get_block()
>  *      No      Yes             "hole" - zero-filled
>  *      Yes     No              "allocated" - allocated on disk, not read in
>  *      Yes     Yes             "valid" - allocated and up-to-date in memory.

OK, but that speaks about buffer head attached to a page. get_block()
callback gets a temporary bh (at least in some cases) only so that it can
communicate result of block mapping. And BH_Uptodate should be set only if
data in the buffer is properly filled (which cannot be the case for
temporary bh which doesn't have *any* data) and it simply isn't the case
even for bh attached to a page because ext4 get_block() functions don't
touch bh->b_data at all. So I just wouldn't set BH_Uptodate in get_block()
at all..

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
