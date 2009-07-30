From: Jan Kara <jack@suse.cz>
Subject: Re: BUG? a suspected deadlock bug at ext4_fill_super()
Date: Thu, 30 Jul 2009 20:02:41 +0200
Message-ID: <20090730180241.GC9223@atrey.karlin.mff.cuni.cz>
References: <2014bcab0907292009y425f746aub389c406ab2dda8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50689 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZG3SCl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jul 2009 14:02:41 -0400
Content-Disposition: inline
In-Reply-To: <2014bcab0907292009y425f746aub389c406ab2dda8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

> Hi. I found a suspected deadlock bug from ext4.
> 
> ext4_fill_super() releases and re-takes BKL while s_umount is held.
> Lock ordering at the point where BKL is re-taken is s_umount-> BKL.
> 
> However, at do_remount(), locking ordering is BKL->s_umount.
> Therefore, concurrent execution of do_remount() and ext4_fill_super()
> may result deadlock.
  Hmm, I don't see how this could deadlock since we seem to take kernel
lock only in do_new_mount() before calling do_kern_mount(). But you are
right that taking the kernel lock with s_umount_sem looks fishy...

> p.s. I found this suspected bug by the motivation from
>        commit 5f22ca9b13551debea77a407a8d06cd9c6f15238.
  From a quick look, this looks like a different matter - they have used
lock_super() instead of lock_kernel() and that's used in more places.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
