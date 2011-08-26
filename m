From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in
 ext4_evict_inode()
Date: Fri, 26 Aug 2011 16:22:51 -0400
Message-ID: <20110826202251.GD5176@thunk.org>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com>
 <20110826073507.GZ3162@dastard>
 <20110826084403.GA3162@dastard>
 <4E576152.9060405@tao.ma>
 <20110826092426.GB3162@dastard>
 <4E57670B.6070205@tao.ma>
 <20110826155234.GC5176@thunk.org>
 <CAFgt=MBAGurdr6Cce9zZ5sWX=BQz4RXJ4HHVWuUvM+gPcgpkFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, Dave Chinner <david@fromorbit.com>,
	linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40097 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab1HZUW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Aug 2011 16:22:57 -0400
Content-Disposition: inline
In-Reply-To: <CAFgt=MBAGurdr6Cce9zZ5sWX=BQz4RXJ4HHVWuUvM+gPcgpkFg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 26, 2011 at 09:58:45AM -0700, Jiaying Zhang wrote:
> Now thinking about an alternative approach to resolve the deadlock
> mentioned above, maybe we can use mutex_trylock() in
> ext4_end_io_work() and if we can't grab the mutex lock for an inode,
> just requeue the work to the end of workqueue?

Good idea!  That should speed up work queue processing in general, I
think.

The downside is that inodes that currently locked might take longer to
complete.  In the case of fsync() we'll just force the I/O completion
to happen in the context of the fsync'ing process, so I don't think it
should be a problem in practice I think.

					- Ted
