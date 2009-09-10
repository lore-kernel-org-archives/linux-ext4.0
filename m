From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Make non-journal fsync work properly.
Date: Thu, 10 Sep 2009 15:45:42 -0400
Message-ID: <20090910194542.GH23700@mit.edu>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com> <20090910065747.GC8690@skywalker.linux.vnet.ibm.com> <1252596786.2130.6.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48282 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbZIJTpq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 15:45:46 -0400
Content-Disposition: inline
In-Reply-To: <1252596786.2130.6.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 08:33:06AM -0700, Frank Mayhar wrote:
> 
> I've been following the other thread as well.  I think I'm beginning to
> get a handle on just how the buffer_heads and ext4 inodes work but I
> still have some learning to do.  That having been said, however, it's
> clear that this change does make things work much, much better, as seen
> by the improvement in our power-fail tests.  One way or another, the
> inodes are getting flushed.  After reading the other thread, I'm
> beginning to suspect that it's more as a side effect of the current
> tangle rather than because of it.  I'll have to look further to
> understand just why it's working, though.
> 
> In any event, I think this change does the right thing or is at least a
> step in the right direction.

Could you also test and give feedback for my patch, "ext4: Assure that
metadata blocks are written during fsync in no journal mode"?  I'm not
sure how much your workloads care about fsync() working correctly, but
it's something we should get right for no-journal mode.

Thanks,

						- Ted
