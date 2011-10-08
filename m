From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext3: Remove the obsolete broken
 EXT3_IOC32_WAIT_FOR_READONLY.
Date: Sat, 8 Oct 2011 16:52:35 -0400
Message-ID: <20111008205235.GL7948@thunk.org>
References: <1318000878-2928-1-git-send-email-tm@tao.ma>
 <20111007221233.GD30754@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51067 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab1JHUwk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 16:52:40 -0400
Content-Disposition: inline
In-Reply-To: <20111007221233.GD30754@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 08, 2011 at 12:12:33AM +0200, Jan Kara wrote:
> On Fri 07-10-11 23:21:18, Tao Ma wrote:
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > There are no user of EXT3_IOC32_WAIT_FOR_READONLY and also it is
> > broken. No one set the set_ro_timer, no one wake up us and our
> > state is set to TASK_INTERRUPTIBLE not RUNNING. So remove it.
>   Hmm, I vaguely recall Andrew had some debugging patches which were using
> turn_ro_timer and this functionality. But I'm not sure if they are still
> usable or if they still make sense when one can easily test crashing using
> virtual machines... Andrew?

That's why I decided to accept the corresponding patch for ext4; if
the rest of debugging patch is out-of-tree, then might as well have it
all out-of-tree --- and killall qemu is probably a better way of
testing this anyway.

							- Ted
