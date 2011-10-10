From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Remove the obsolete broken
 EXT3_IOC32_WAIT_FOR_READONLY.
Date: Mon, 10 Oct 2011 18:27:00 +0200
Message-ID: <20111010162700.GG3944@quack.suse.cz>
References: <1318000878-2928-1-git-send-email-tm@tao.ma>
 <20111007221233.GD30754@quack.suse.cz>
 <20111008205235.GL7948@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1JJQ1C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 12:27:02 -0400
Content-Disposition: inline
In-Reply-To: <20111008205235.GL7948@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 08-10-11 16:52:35, Ted Tso wrote:
> On Sat, Oct 08, 2011 at 12:12:33AM +0200, Jan Kara wrote:
> > On Fri 07-10-11 23:21:18, Tao Ma wrote:
> > > From: Tao Ma <boyu.mt@taobao.com>
> > > 
> > > There are no user of EXT3_IOC32_WAIT_FOR_READONLY and also it is
> > > broken. No one set the set_ro_timer, no one wake up us and our
> > > state is set to TASK_INTERRUPTIBLE not RUNNING. So remove it.
> >   Hmm, I vaguely recall Andrew had some debugging patches which were using
> > turn_ro_timer and this functionality. But I'm not sure if they are still
> > usable or if they still make sense when one can easily test crashing using
> > virtual machines... Andrew?
> 
> That's why I decided to accept the corresponding patch for ext4; if
> the rest of debugging patch is out-of-tree, then might as well have it
> all out-of-tree --- and killall qemu is probably a better way of
> testing this anyway.
  OK. I've merged the patch in my tree. If Andrew shouts loudly, I can
always revert it :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
