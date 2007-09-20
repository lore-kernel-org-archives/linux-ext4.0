From: Jan Kara <jack@suse.cz>
Subject: Re: Enabling h-trees too early?
Date: Thu, 20 Sep 2007 16:58:39 +0200
Message-ID: <20070920145839.GD1986@atrey.karlin.mff.cuni.cz>
References: <20070919150715.GH9232@duck.suse.cz> <20070919182450.GF25497@thunk.org> <20070920133350.GH2689@duck.suse.cz> <20070920142800.GC30221@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56733 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXITO6l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Sep 2007 10:58:41 -0400
Content-Disposition: inline
In-Reply-To: <20070920142800.GC30221@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Thu, Sep 20, 2007 at 03:33:50PM +0200, Jan Kara wrote:
> >   So for example deleting kernel tree on my computer takes ~14 seconds with
> > h-trees and less than 9 without them. Also doing 'cp -lr' of the kernel
> > tree takes 8 seconds with h-trees and 6.3s without them... So I think the
> > performance difference is quite measurable.
> 
> This is in a completely cold cache state?  (i.e. mounting and
> unmounting the filesystem before doing the rm -rf?)
  Yes.

> On my kernel tree, using the command: "lsattr -R | grep -- -I-" shows
> that only 8 directories are htree indexed, and they're not that big:
> 
> 12 drwxr-xr-x 12 tytso tytso 12288 2007-09-14 16:25 ./drivers/char
> 24 drwxr-xr-x 30 tytso tytso 24576 2007-09-14 16:25 ./drivers/net
> 20 drwxr-xr-x  2 tytso tytso 20480 2007-09-14 16:25 ./drivers/usb/serial
> 32 drwxr-xr-x 24 tytso tytso 32768 2007-09-14 16:10 ./include/linux
> 12 drwxr-xr-x  2 tytso tytso 12288 2007-09-14 16:25 ./net/bridge/netfilter
> 24 drwxr-xr-x  2 tytso tytso 24576 2007-09-14 16:25 ./net/ipv4/netfilter
> 12 drwxr-xr-x  2 tytso tytso 12288 2007-09-14 16:25 ./net/ipv6/netfilter
> 32 drwxr-xr-x  2 tytso tytso 32768 2007-09-14 16:25 ./net/netfilter
> 
> ... which means if the benchmark only focused on deleting these files,
> then presumably the percentage increase would be even worse.
  Hmm, strange - I've just looked at my computer and dir_index is set
just for 5 directories in my tree. If I try deleting just them, I also
see some performance decrease but it's less than if I try deleting the
whole tree (and that result seems to be quite consistent)... There's something
fishy there. Maybe I could try seekwatcher or something similar to see
what's really happening.
 
> > > Certainly one of the things that we could consider is for small
> > > directories to do an in-memory sort of all of the directory entries at
> > > opendir() time, and keeping that list until it is closed.  We can't do
> > > this for really big directories, but we could easily do it for
> > > directories under 32k or 64k.
> >
> >   Umm, yes. That would be probably feasible. But converting to htrees only
> > when directories grow larger would avoid the problem also. It also does not
> > seem *that* hard but maybe I miss some nasty details...
> 
> The reason why I mentioned the caching idea is we already have code to
> manage and return directories stored in an rbtree in the kernel,
> albeit for a slightly different purpose.  So hacking it up to cache
> all of the directory entries for directories < 64k and to index them
> by inode number instead of hash key would be pretty easy.
> 
> What's nasty about converting to htrees after the directories become
> larger is that we need to reserve extra space in the journal for each
> block that we need to modify, and then just the fact that we have to
> keep track of the multiple buffers.  Basically, not impossible but
> just a pain in the *ss.
  I see :).

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
