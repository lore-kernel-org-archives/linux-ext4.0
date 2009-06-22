From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [BUG] bugs in jbd2_dev_to_name() (was Re: [PATCH 00/11] [GIT
 PULL] more updates for the tag format)
Date: Mon, 22 Jun 2009 09:36:28 +0800
Message-ID: <4A3EE01C.5090600@cn.fujitsu.com>
References: <20090610092644.GA20889@elte.hu> <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com> <20090610130127.GA6647@mit.edu> <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com> <20090610160303.GA10240@mit.edu> <20090611130318.GB14220@infradead.org> <20090611154751.GD9275@mit.edu> <20090611171434.GA6011@nowhere> <20090611192037.GA5116@mit.edu> <4A3B48DF.8080300@cn.fujitsu.com> <20090619123204.GC31377@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Li Zefan <lizf@cn.fujitsu.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	I
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZFVBev (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jun 2009 21:34:51 -0400
In-Reply-To: <20090619123204.GC31377@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Jun 19, 2009 at 04:14:23PM +0800, Li Zefan wrote:
>>> 	rcu_read_lock();
>>> 	if (devcache[i] && devcache[i]->device == device) {
>>> 		ret = devcache[i]->devname;
>>> 		rcu_read_unlock();
>>> 		return ret;
>> It doesn't seem safe to dereference @ret outside rcu read section.
> 
> Note the comments at the beginning of the function:
> 

Ah, I overlooked the comments.

But the patch that adds rcu locking around trace event prints
never gets merged:

http://lkml.org/lkml/2009/4/15/549

Steven?

>     The caller should use rcu_read_lock() in order to make sure the
>     device name stays valid until its done with it.  We use
>     rcu_read_lock() as well to make sure we're safe in case the caller
>     gets sloppy, and because rcu_read_lock() is cheap and can be safely
>     nested.
> 
> I suppose I should change the wording to indicate that it adds a bit
> more safety (as in, the crash won't happen inside this function, but
> as far as the caller is concerned, all bets are off!)
> 

