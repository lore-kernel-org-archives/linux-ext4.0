From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] ext3: Implement delayed allocation on page_mkwrite
 time
Date: Mon, 2 May 2011 15:29:17 -0700
Message-ID: <20110502152917.550d2475.akpm@linux-foundation.org>
References: <1304369816-14545-1-git-send-email-jack@suse.cz>
	<1304369816-14545-5-git-send-email-jack@suse.cz>
	<20110502141230.4a7640f9.akpm@linux-foundation.org>
	<20110502222020.GB14889@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424Ab1EBW3u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 18:29:50 -0400
In-Reply-To: <20110502222020.GB14889@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 3 May 2011 00:20:20 +0200
Jan Kara <jack@suse.cz> wrote:

> On Mon 02-05-11 14:12:30, Andrew Morton wrote:
> > On Mon,  2 May 2011 22:56:56 +0200
> > Jan Kara <jack@suse.cz> wrote:
> > 
> > > So far, ext3 was allocating necessary blocks for mmapped writes when
> > > writepage() was called. There are several issues with this. The worst
> > > being that user is allowed to arbitrarily exceed disk quotas because
> > > writepage() is called from flusher thread context (which is root) and thus
> > > quota limits are ignored. Another bad consequence is that data is just lost
> > > if we find there's no space on the filesystem during ->writepage() time.
> > > 
> > > We solve these issues by implementing block reservation in page_mkwrite()
> > > callback. We don't want to really allocate blocks on page_mkwrite() time
> > > because for random writes via mmap (as seen for example with applications using
> > > BerkeleyDB) it results in much more fragmented files and thus much worse
> > > performance. So we allocate indirect blocks and reserve space for data block in
> > > page_mkwrite() and do the allocation of data block from writepage().
> > 
> > Yes, instantiating the metadata and accounting the data is a good
> > approach.  The file layout will be a bit suboptimal, but surely that
> > will be a minor thing.
> > 
> > But boy, it's a complicated patch!  Are we really sure that we want to
> > make changes this extensive to our antiquated old fs?  Or do we just
> > say "yeah, it's broken with quotas - use ext4"?
>   The patch isn't trivial, I agree (although it's mostly straightforward).
> Regarding telling users to switch to ext4 - it seems a bit harsh to me
> to ask people to switch to ext4 as a response to a (possibly security)
> issue they uncover. Because for most admins switching to ext4 will require
> some non-trivial testing I presume. Of course, the counterweight is the
> possibility of new bugs introduced to the code by my patch.

Yes.

> But after some
> considerations I've decided it's worth it and and fixed the bug...

Well.  How did you come to that decision?  Are real users hurting from
this problem?  What's the real-world case for fixing it?
