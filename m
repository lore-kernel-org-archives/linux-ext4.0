From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC PATCH 2/2] ext4: improve extents status tree shrinker to
 avoid scanning delayed entries
Date: Tue, 31 Dec 2013 10:50:52 +0800
Message-ID: <20131231025052.GA6936@gmail.com>
References: <1387536165-15956-1-git-send-email-wenqing.lz@taobao.com>
 <1387536165-15956-3-git-send-email-wenqing.lz@taobao.com>
 <20131223085419.GB9199@quack.suse.cz>
 <20131225033448.GC23505@gmail.com>
 <20131230210917.GD5457@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34643 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab3LaCrU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Dec 2013 21:47:20 -0500
Received: by mail-pd0-f174.google.com with SMTP id x10so11831250pdj.19
        for <linux-ext4@vger.kernel.org>; Mon, 30 Dec 2013 18:47:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131230210917.GD5457@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 30, 2013 at 10:09:17PM +0100, Jan Kara wrote:
> On Wed 25-12-13 11:34:48, Zheng Liu wrote:
> > On Mon, Dec 23, 2013 at 09:54:19AM +0100, Jan Kara wrote:
> > > On Fri 20-12-13 18:42:45, Zheng Liu wrote:
> > > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > > 
> > > > The extents status tree shrinker will scan all inodes on sbi->s_es_lru
> > > > under heavy memory pressure, and try to reclaim the entry from extents
> > > > status tree.  During this process it couldn't reclaim the delayed entry
> > > > because ext4 needs to use these entries to do delayed allocation space
> > > > reservation, seek_data/hole, etc....  So if a system has done a huge
> > > > number of writes and these dirty pages don't be written out.  There will
> > > > be a lot of delayed entries on extents status tree.  If shrinker tries
> > > > to reclaim memory from the tree, it will burn some CPU time to iterate
> > > > on these non-reclaimable entries.  At some circumstances it could cause
> > > > excessive stall time.
> > > > 
> > > > In this commit a new list is used to track reclaimable entries of extent
> > > > status tree (e.g. written/unwritten/hole entries).  The shrinker will
> > > > scan reclaimable entry on this list.  So it won't encouter any delayed
> > > > entry and don't need to take too much time to spin.  But the defect is
> > > > that we need to cost extra 1/3 memory space for one entry.  Before this
> > > > commit, 'struct extent_status' occupies 48 bytes on a 64bits platform.
> > > > After that it will occupy 64 bytes. :(
> > >   This looks sensible. I was just wondering about one thing: One incorrect
> > > thing the old extent shrinker does is that it tries to reclaim 'nr_to_scan'
> > > objects. That is wrong - it should *scan* 'nr_to_scan' objects and reclaim
> > > objects it can find. Now we shouldn't always start scanning at the end of
> > > the LRU because if delayed extents accumulate there we would never reclaim
> > > anything. Rather we should cycle through the list of entries we have. But
> > > that doesn't play well with the fact we have LRU list and thus want to
> > > reclaim from the end of the list. In the end what you do might be the best
> > > we can do but I wanted to mention the above just in case someone has some
> > > idea.
> > 
> > Ah, thanks for pointing it out.  So maybe we can fix this issue before
> > we are sure that the new improvement is acceptable because it makes us
> > avoid scanning too many objects.  What do you think?
>   I'm sorry but I'm not sure I understand.  By 'fix this issue' do you mean
> using your patch or somehow fixing the problem that we try to reclaim
> 'nr_to_scan' objects instead of just trying to scan that many objects?

Sorry, let me clarify it please.  I mean that we can have a patch to fix
the issue that we try to reclaim 'nr_to_scan' objects.  After this we
could avoid scanning too much objects in extent status tree.  My idea is
that we use a single patch to fix this issue.  That means that we don't
need to wait other improvements because we still needs to take some time
verifing these improvements useful.

Thanks for the reply and happy new year :)!
                                                - Zheng
