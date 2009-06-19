From: Theodore Tso <tytso@mit.edu>
Subject: Re: [BUG] bugs in jbd2_dev_to_name() (was Re: [PATCH 00/11] [GIT
	PULL] more updates for the tag format)
Date: Fri, 19 Jun 2009 08:32:04 -0400
Message-ID: <20090619123204.GC31377@mit.edu>
References: <20090610092644.GA20889@elte.hu> <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com> <20090610130127.GA6647@mit.edu> <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com> <20090610160303.GA10240@mit.edu> <20090611130318.GB14220@infradead.org> <20090611154751.GD9275@mit.edu> <20090611171434.GA6011@nowhere> <20090611192037.GA5116@mit.edu> <4A3B48DF.8080300@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41556 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbZFSMcd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jun 2009 08:32:33 -0400
Content-Disposition: inline
In-Reply-To: <4A3B48DF.8080300@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 19, 2009 at 04:14:23PM +0800, Li Zefan wrote:
> > 	rcu_read_lock();
> > 	if (devcache[i] && devcache[i]->device == device) {
> > 		ret = devcache[i]->devname;
> > 		rcu_read_unlock();
> > 		return ret;
> 
> It doesn't seem safe to dereference @ret outside rcu read section.

Note the comments at the beginning of the function:

    The caller should use rcu_read_lock() in order to make sure the
    device name stays valid until its done with it.  We use
    rcu_read_lock() as well to make sure we're safe in case the caller
    gets sloppy, and because rcu_read_lock() is cheap and can be safely
    nested.

I suppose I should change the wording to indicate that it adds a bit
more safety (as in, the crash won't happen inside this function, but
as far as the caller is concerned, all bets are off!)

> > 	spin_lock(&devname_cache_lock);
> > 	if (devcache[i]) {
> > 		if (devcache[i]->device == device) {
> > 			ret = devcache[i]->devname;
> > 			spin_unlock(&devname_cache_lock);
> > 			return ret;
> > 		}
> > 		call_rcu(&devcache[i]->rcu, free_devcache);
> > 	}
> > 	devcache[i] = kmalloc(sizeof(struct devname_cache), GFP_KERNEL);
> 
> kmalloc(GFP_KERNEL) called with spin_lock held..

Good catch, thanks.  I'll get a patch in to fix this.

							- Ted
