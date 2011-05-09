From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Mon, 9 May 2011 16:05:37 +0200
Message-ID: <20110509140537.GN4122@quack.suse.cz>
References: <4DC5DBB3.9030207@linux.vnet.ibm.com>
 <20110509110329.GF4122@quack.suse.cz>
 <BANLkTi=hSeN4mb8x9vu4DfBb-us_ocaqXw@mail.gmail.com>
 <20110509113052.GI4122@quack.suse.cz>
 <20110509135516.GJ4138@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab1EIOFk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 10:05:40 -0400
Content-Disposition: inline
In-Reply-To: <20110509135516.GJ4138@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 09-05-11 09:55:16, Ted Tso wrote:
> On Mon, May 09, 2011 at 01:30:52PM +0200, Jan Kara wrote:
> > Ah, I see. But then you just reintroduced the bug I was trying to fix. So
> > either do_split() has to do the marking of buffer dirty, or we have to do
> > it before calllig do_split(), or do_split() has to be changed and not
> > release passed buffer (and the two callers have to do it - which they seem
> > to do anyway). I don't mind either way but your fix is wrong.
> 
> I think it's OK.  We do call ext4_handle_dirty_metadata on frame->bh,
> which deals with the original version of bh.  And the cases where
> do_split() sets bh to NULL is either (a) a journal error, in which
> case we will have already aborted the journal, or an I/O error while
> reading in the block, so bh won't have gotten modified yet.
> 
> Is there a case that you're worried about that I'm missing?
  Yes. ext4_append() can return ENOSPC and passed bh will get set to NULL
without being marked dirty.  Note that we need to call
ext4_handle_dirty_metadata() on the passed bh as well specifically in the
make_indexed_dir() case because there we move contents of the first block
(in frame->bh) to the second block (passed bh) and create indexed tree root
in the first block. Then we call do_split() to further split the second
block...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
