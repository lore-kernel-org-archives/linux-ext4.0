From: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: ext3 lockdep warning in 2.6.25-rc6
Date: Wed, 2 Apr 2008 12:34:20 -0400
Message-ID: <200804021634.m32GYKdZ018898@agora.fsl.cs.sunysb.edu>
References: <20080402081215.GA2716@duck.suse.cz>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41258 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568AbYDBQiP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Apr 2008 12:38:15 -0400
In-reply-to: Your message of "Wed, 02 Apr 2008 10:12:15 +0200."
             <20080402081215.GA2716@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In message <20080402081215.GA2716@duck.suse.cz>, Jan Kara writes:
> On Tue 01-04-08 17:23:34, Erez Zadok wrote:
>  <snip>
[...]
>   I'll try to explain the locking here:
> 1) We are not allowed to call into __invalidate_mapping_pages() with
> inode_lock held - that it the bug lockdep is complaining about. Moreover it
> leads to rather long waiting times for inode_lock (quite possibly several
> seconds).
> 2) When we release inode_lock, we need to protect from inode going away,
> thus we hold reference to it - that guarantees us inode stays in the list.
> 3) When we continue scanning of the list we must get inode_lock before we
> put the inode reference to avoid races. But we cannot do iput() when we
> hold inode_lock. Thus we save pointer to inode and do iput() next time we
> have released the inode_lock...
> 
> > Peter's post:
> > 
> > 	http://lkml.org/lkml/2008/3/23/202
> > 
> > includes a reference to a mail by Andrew which implies that the fix may be
> > much more involved than what you outlined above, no?
>   Definitely we can do a more involved fix ;) What Andrew proposes would have
> some other benefits as well. But until somebody gets to that, this slight
> hack should work fine (Andrew has already merged my patch in -mm so I
> guess he agrees ;).

Thanks for the explanation.  And good to know it's in -mm.  I'll give it a
try.

Cheers,
Erez.
