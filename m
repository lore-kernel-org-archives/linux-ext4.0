From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] aborted ext4 leads to inifinity loop in
 balance_dirty_pages
Date: Wed, 9 Nov 2011 12:15:24 +0100
Message-ID: <20111109111524.GA1025@quack.suse.cz>
References: <4EA6A5E5.2050604@sx.jp.nec.com>
 <20111025134045.GB8072@quack.suse.cz>
 <4EAA3EE7.4040802@sx.jp.nec.com>
 <20111108000335.GA7518@quack.suse.cz>
 <4EBA39A4.3040708@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab1KILP1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Nov 2011 06:15:27 -0500
Content-Disposition: inline
In-Reply-To: <4EBA39A4.3040708@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 09-11-11 17:28:20, Kazuya Mio wrote:
> 2011/11/08 9:03, Jan Kara wrote:
> > On Fri 28-10-11 14:34:31, Kazuya Mio wrote:
> >> 2011/10/25 22:40, Jan Kara wrote:
> >>>   Please no. Generally this boils down to what do we do with dirty data
> >>> when there's error in writing them out. Currently we just throw them away
> >>> (e.g. in media error case) but I don't think that's a generally good thing
> >>> because e.g. admin may want to copy the data to other working storage or
> >>> so. So I think we should rather keep the data and provide a mechanism for
> >>> userspace to ask kernel to get rid of the data (so that we don't eventually
> >>> run OOM).
> >>
> >> I see. I agree with you.
> >>
> >>>> Do you have any ideas?
> >>>   So the question is what would you like to achieve. If you just want to
> >>> unblock a thread then a solution would be to make a thread at
> >>> balance_dirty_pages() killable. If generally you want to get rid of dirty
> >>> memory, then I don't have a really good answer but throwing dirty data away
> >>> seems like a bad answer to me.
> >>
> >> The problem is that we cannot unmount the corrupted filesystem due to
> >> un-killable dd process. We must bring down the system to resume the service
> >> with no dirty pages. I think it is important for the service continuity
> >> to be able to kill the thread handling in balance_dirty_pages().
> >    OK, attached are two patches based on latest Linus's tree that should
> > make your task killable. Can you test them?
> 
> I'm trying to reproduce now, but it's hard. Could you wait a few days?
  Sure, take as much time as you need.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
