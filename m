From: Jan Kara <jack@suse.cz>
Subject: Re: query about truncate and orphan list
Date: Wed, 29 Aug 2012 15:17:58 +0200
Message-ID: <20120829131758.GA21169@quack.suse.cz>
References: <CAOiN93=uvi37EMuOYvd+Nr2up=giPikL+sLEOFTpqOzyHi+Tfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab2H2NSA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Aug 2012 09:18:00 -0400
Content-Disposition: inline
In-Reply-To: <CAOiN93=uvi37EMuOYvd+Nr2up=giPikL+sLEOFTpqOzyHi+Tfw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 29-08-12 14:52:22, Ashish Sangwan wrote:
> I have a query about orphan list and truncate.
> Currently these steps are performed in ext4_ext_truncate():
> a) Start journal handle.
> b) add inode to orphan list.
> c) i_disksize is updated and inode is mark dirty.
> d) actual truncate happen.
> e) remove inode from orphan list.
> f) handle stop.
> 
> If system crash during step d) will i_disksize is actually updated on disk?
> AFAIK i_disksize might be updated on the journal but not on its
> original location because the transaction is not commited yet.
  Yes, that can happen.

> If this is the case than what is the use of re-starting truncate
> operation while processing orphan inode list?
  Because it can be on disk (noone guarantees when a transaction commits)
and in that case we have to perform the truncate because some of the blocks
might have been already freed by a transaction which is also committed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
