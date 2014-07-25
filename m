From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: radically reduce memory utilization by using
 rbtree bitmaps
Date: Fri, 25 Jul 2014 14:14:31 -0400
Message-ID: <20140725181431.GA6725@thunk.org>
References: <1406310671-10784-1-git-send-email-tytso@mit.edu>
 <53D29DDE.805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57090 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaGYSOd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 14:14:33 -0400
Content-Disposition: inline
In-Reply-To: <53D29DDE.805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 01:11:42PM -0500, Eric Sandeen wrote:
> On 7/25/14, 12:51 PM, Theodore Ts'o wrote:
> > When resizing an empty 21T file system to 28T, resize2fs was using
> > this much CPU time and memory:
> > 
> > 216.98user 19.77system 4:02.92elapsed 97%CPU (0avgtext+0avgdata 4485664maxresident)k
> > 8inputs+1068680outputs (0major+800745minor)pagefaults 0swaps
> > 
> > After this one-line change:
> > 
> > 222.29user 0.49system 3:48.79elapsed 97%CPU (0avgtext+0avgdata 30080maxresident)k
> > 8inputs+1068552outputs (0major+2497minor)pagefaults 0swaps
> > 
> > An extra 14 seconds (+6%) of elapsed time to reduce the memory
> > utilization from 4.2GB to 29MB seems like a fair trade.  :-)
> 
> especially when it actually looks like 14 *fewer* seconds (-6%) ?

Yeah, I was initially looking at the increase in user time, and then
didn't notice that this was more than compensated by the decrease in
system time (probably due to all of the page faults when dealing with
traditional bitmaps).  Oops.

I'll adjust the comments appropriately.

							- Ted
