From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Test generic/299 stalling forever
Date: Wed, 12 Oct 2016 22:15:52 -0400
Message-ID: <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard>
 <20160929043722.ypf3tnxsl6ovt653@thunk.org>
 <20161012211407.GL23194@dastard>
 <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org, tarasov@vasily.name
To: Jens Axboe <axboe@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56156 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933475AbcJMCQc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Oct 2016 22:16:32 -0400
Content-Disposition: inline
In-Reply-To: <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 12, 2016 at 03:19:25PM -0600, Jens Axboe wrote:
> 
> FWIW, this is the commit that fixes it:
> 
> commit 39d13e67ef1f4b327c68431f8daf033a03920117
> Author: Jens Axboe <axboe@fb.com>
> Date:   Fri Aug 26 14:39:30 2016 -0600
> 
>     backend: check if we need to update rusage stats, if stat_mutex is busy
> 
> 2.14 and newer should not have the problem, but earlier versions may
> depending on how old...

Unfortunately, I'm still seeing hangs in generic/299 with the latest version of fio:

fio 	  fio-2.14-10-g0a301e9 (Fri, 23 Sep 2016 11:57:00 -0600)

If I use an older fio, it reliably does not hang.  What can I do to
help debug this?

As I said, I can attach to the hanging fio using a gdb and give you
stackdumps for all of the threads if that would be helpful.

	       	      	  	     - Ted


