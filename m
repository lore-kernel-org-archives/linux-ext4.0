From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] aborted ext4 leads to inifinity loop in
 balance_dirty_pages
Date: Wed, 2 Nov 2011 00:13:42 +0100
Message-ID: <20111101231342.GJ18701@quack.suse.cz>
References: <4EA6A5E5.2050604@sx.jp.nec.com>
 <20111025134045.GB8072@quack.suse.cz>
 <4EAA3EE7.4040802@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab1KAXNp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 19:13:45 -0400
Content-Disposition: inline
In-Reply-To: <4EAA3EE7.4040802@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 28-10-11 14:34:31, Kazuya Mio wrote:
> 2011/10/25 22:40, Jan Kara wrote:
> >  Please no. Generally this boils down to what do we do with dirty data
> >when there's error in writing them out. Currently we just throw them away
> >(e.g. in media error case) but I don't think that's a generally good thing
> >because e.g. admin may want to copy the data to other working storage or
> >so. So I think we should rather keep the data and provide a mechanism for
> >userspace to ask kernel to get rid of the data (so that we don't eventually
> >run OOM).
> 
> I see. I agree with you.
> 
> >>Do you have any ideas?
> >  So the question is what would you like to achieve. If you just want to
> >unblock a thread then a solution would be to make a thread at
> >balance_dirty_pages() killable. If generally you want to get rid of dirty
> >memory, then I don't have a really good answer but throwing dirty data away
> >seems like a bad answer to me.
> 
> The problem is that we cannot unmount the corrupted filesystem due to
> un-killable dd process. We must bring down the system to resume the service
> with no dirty pages. I think it is important for the service continuity
> to be able to kill the thread handling in balance_dirty_pages().
  Sure. Then allowing a process to be killed while waiting in
balance_dirty_pages() would solve your problem. That can be done relatively
easily. I can write the patch, just now the code is under rewrite from
IO-less dirty throttling patches so I'll wait for a while for it to settle
down.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
