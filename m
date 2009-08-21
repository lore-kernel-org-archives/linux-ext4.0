From: Jan Kara <jack@suse.cz>
Subject: Re: jbd: a question on __log_wait_for_space()
Date: Fri, 21 Aug 2009 15:53:05 +0200
Message-ID: <20090821135305.GB20935@atrey.karlin.mff.cuni.cz>
References: <2014bcab0908192131y71e02806u685273732d6a293a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52547 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbZHUNxE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Aug 2009 09:53:04 -0400
Content-Disposition: inline
In-Reply-To: <2014bcab0908192131y71e02806u685273732d6a293a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

> Hi. I have a question on __log_wait_for_space() in jbd/checkpoint.c
> while I read jbd code of Linux 2.6.30.4
> 
> In __log_wait_for_space(), it releases and re-takes journal->j_state_lock
> in while loop (at line 139).
> 
> After the retaking the lock, it checks 'space_left < nblocks'. It seems that
> it considers that the journal might be written during the lock
> releasing and re-taking.
> 
> Then, is it necessary to check 'journal->j_flags & JFS_ABORT' again too?
> I found that journal_t's j_flags is synchronized via j_state_lock. So, is there
> any possiblity that j_flags value can be changed during the lock
> releasing and re-taking?
  Well, it may happen that JFS_ABORT has been set while we didn't hold
j_state_lock but I don't see a problem in it. We just call a few other
functions and then reiterate the while loop and we exit the loop either
because there is enough space in the journal or becauce we notice the
JFS_ABORT flag.
  The point of JFS_ABORT check is that we didn't loop indefinitely when
the journal gets aborted and no blocks can be freed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
