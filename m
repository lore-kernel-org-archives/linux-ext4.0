From: Jan Kara <jack@suse.cz>
Subject: Re: a question for i_inode's i_size in ext2
Date: Sat, 20 Sep 2008 05:25:22 +0200
Message-ID: <20080920032522.GB9633@atrey.karlin.mff.cuni.cz>
References: <2014bcab0809190021qbca7bect601c891c2db197cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47310 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYITDZX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Sep 2008 23:25:23 -0400
Content-Disposition: inline
In-Reply-To: <2014bcab0809190021qbca7bect601c891c2db197cf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Dear Shin Hong,

>   I have a question of inode's i_size. I found that it is hard to find
> any consistent synchronization mechanism that protects inode's i_size
> field.
>   Is there any lock or synchronization mechanism that consistently
> protects i_size fields of inode objects to avoid data race?
>   In inode's definition in /include/linux/fs.h, there is comment that
> i_lock protects i_size but it is not clear.
  As Ted said, i_size changes use i_mutex to guard them (actually,
the comment you are probably refering to speaks about i_mutex - i_lock is
something different). Reading i_size is a different matter - see
i_size_read function. We use seqlock for that - essentially we use an
atomic counter which is incremented on every change of i_size and check
that it's value before we started reading i_size and after we have
finished reading it has not changed. I hope this helps.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
