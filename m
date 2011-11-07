From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] aborted ext4 leads to inifinity loop in
 balance_dirty_pages
Date: Mon, 7 Nov 2011 18:29:39 +0100
Message-ID: <20111107172939.GH15796@quack.suse.cz>
References: <4EA6A5E5.2050604@sx.jp.nec.com>
 <20111025134045.GB8072@quack.suse.cz>
 <4EAA3EE7.4040802@sx.jp.nec.com>
 <87y5vsl5ue.fsf@dmbot.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, Jan Kara <jack@suse.cz>,
	ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab1KGR3n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Nov 2011 12:29:43 -0500
Content-Disposition: inline
In-Reply-To: <87y5vsl5ue.fsf@dmbot.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 07-11-11 12:00:41, Dmitry Monakhov wrote:
> On Fri, 28 Oct 2011 14:34:31 +0900, Kazuya Mio <k-mio@sx.jp.nec.com> wrote:
> > 2011/10/25 22:40, Jan Kara wrote:
> > >   Please no. Generally this boils down to what do we do with dirty data
> > > when there's error in writing them out. Currently we just throw them away
> > > (e.g. in media error case) but I don't think that's a generally good thing
> > > because e.g. admin may want to copy the data to other working storage or
> > > so. So I think we should rather keep the data and provide a mechanism for
> > > userspace to ask kernel to get rid of the data (so that we don't eventually
> > > run OOM).
> > 
> > I see. I agree with you.
> > 
> > >> Do you have any ideas?
> > >   So the question is what would you like to achieve. If you just want to
> > > unblock a thread then a solution would be to make a thread at
> > > balance_dirty_pages() killable. If generally you want to get rid of dirty
> > > memory, then I don't have a really good answer but throwing dirty data away
> > > seems like a bad answer to me.
> > 
> > The problem is that we cannot unmount the corrupted filesystem due to
> > un-killable dd process. We must bring down the system to resume the service
> > with no dirty pages. I think it is important for the service continuity
> > to be able to kill the thread handling in balance_dirty_pages().
> In fact you are very lucky because dd is just deadlocked, in many cases
> journal abort result in BUG_ON triggering(if IO load is high enough).
  Can you provide the exact kernel message? I'd be interested...

> This is because transaction abort check is racy. Right now i've no good
> fix which has reasonable performance. My latest idea is to protect
> transaction abort check via SRCU.
  Yeah, the code does not seem to care about races too much but I don't see
which BUG_ON would be triggered...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
