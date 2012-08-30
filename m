From: Jan Kara <jack@suse.cz>
Subject: Re: query about truncate and orphan list
Date: Thu, 30 Aug 2012 11:54:15 +0200
Message-ID: <20120830095415.GA4749@quack.suse.cz>
References: <CAOiN93=uvi37EMuOYvd+Nr2up=giPikL+sLEOFTpqOzyHi+Tfw@mail.gmail.com>
 <20120829131758.GA21169@quack.suse.cz>
 <CAOiN93=g-Fj-7+BbFEi2D0O8dRkLCCKttSD7MsuLODgqLUP8hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab2H3JyR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2012 05:54:17 -0400
Content-Disposition: inline
In-Reply-To: <CAOiN93=g-Fj-7+BbFEi2D0O8dRkLCCKttSD7MsuLODgqLUP8hQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 30-08-12 14:54:33, Ashish Sangwan wrote:
> On Wed, Aug 29, 2012 at 6:47 PM, Jan Kara <jack@suse.cz> wrote:
> > On Wed 29-08-12 14:52:22, Ashish Sangwan wrote:
> >> I have a query about orphan list and truncate.
> >> Currently these steps are performed in ext4_ext_truncate():
> >> a) Start journal handle.
> >> b) add inode to orphan list.
> >> c) i_disksize is updated and inode is mark dirty.
> >> d) actual truncate happen.
> >> e) remove inode from orphan list.
> >> f) handle stop.
> >>
> >> If system crash during step d) will i_disksize is actually updated on disk?
> >> AFAIK i_disksize might be updated on the journal but not on its
> >> original location because the transaction is not commited yet.
> >   Yes, that can happen.
> >
> Ok,
> To test it, I inserted a 10 seconds sleep between d) and e)
> I created a 10MB file on new ext4 partition and tried to truncate it to 10KB.
> After waiting for 10 seconds, unplug the device.
> On remount, the inode was not present on the orphan list.
> No matter how many times I repeat this operation, result is same.
  Well, this is likely because inode is small and thus the whole truncate
operation fits in a single transaction. So your sleep just held the
transaction with add-to-orphan operation open. Try creating a big
fragmented file - like:
for ((i = 0; i < 5000; i++)); do
  dd if=/dev/urandom of=file bs=4096 count=1 conv=notrunc seek=$((i*2));
done
fsync file

Then try your above experiment and you should see inode on orphan list.

> After that I inserted a call to ext4_journal_restart() between step c)
> and d.) and repeat the above operation.
> This time the inode was present on orphan list and i_disksize was
> updated (10KB) correctly too.
> Is it the correct thing to do?
  Yes. That's expected result.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
