From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: avoid reusing recently deleted inodes in no
 journal mode
Date: Wed, 31 Jul 2013 18:12:35 -0400
Message-ID: <20130731221235.GB11378@thunk.org>
References: <1374809631-5258-1-git-send-email-tytso@mit.edu>
 <1374867164-21942-1-git-send-email-tytso@mit.edu>
 <20130729133231.GC9860@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37599 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab3GaWMj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 18:12:39 -0400
Content-Disposition: inline
In-Reply-To: <20130729133231.GC9860@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 03:32:31PM +0200, Jan Kara wrote:
>   I'd use dirty_expire_interval here so that we are at least tied to
> flusher thread timeout...

Makes sense, done.

> > +		/*
> > +		 * Five seconds should be enough time for a block to be
> > +		 * committed to the platter once it is sent to the HDD
> > +		 */
> > +		recentcy = 5;
>   This is completely ad-hoc and I cannot say anything about what value
> would be appropriate here. Jens told me disk can hold on sectors for
> *minutes* in their writeback caches when these blocks are unsuitably placed
> and there's enough streaming IO going on. So the question is what value do
> we want to base this on?

Yes, it is completely ad-hoc.  How long a disk will hold on to sectors
in their writeback caches really depends on its elevator algorithms;
so it is indeed completely a hueristic.  I will say though that the
workloads that allow a sector to be pinned for even seconds (let alone
minutes) are very artifical workloads and it's very unclear whether
it's realistic that they would exist on most normal productoin
servers.  The use cases for no journal mode is for places where
performance is critical, so we really don't want to send a CACHE FLUSH
command, which is really the only way you can be sure.

					- Ted
