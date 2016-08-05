From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Sleeping function called in invalid context
Date: Fri, 5 Aug 2016 10:06:57 -0700
Message-ID: <20160805170657.GB19960@birch.djwong.org>
References: <57A19B9B.60005@kyup.com>
 <20160804160550.GA12861@quack2.suse.cz>
 <20160804205845.GC10933@thunk.org>
 <57A43267.7030608@kyup.com>
 <20160805145604.GA9105@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Borisov <kernel@kyup.com>, Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42047 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbcHERHM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Aug 2016 13:07:12 -0400
Content-Disposition: inline
In-Reply-To: <20160805145604.GA9105@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 05, 2016 at 10:56:04AM -0400, Theodore Ts'o wrote:
> On Fri, Aug 05, 2016 at 09:29:59AM +0300, Nikolay Borisov wrote:
> > > The easist way to fix this is defer the ext4_commit_super() to a
> > > workqueue.  We only need this in the errors=continue case, and in that
> > > scenario we're not in a hurry when the superblock gets written out.
> > 
> > Is errors=continue the default option if nothing specifically is
> > specified at mount time, since I don't have this set explicitly:
> > 
> > /dev/vda / ext4 rw,relatime,data=ordered 0 0
> 
> Yes, it's the default.  I keep wondering whether we should change the
> default to remount-ro or even panic, since people sometimes don't
> notice that the "file system has been corrupted" messages, and then
> they can end up losing a lot more detail if we forced them to address
> the issue right away.

Yes, please. :)

(At the moment I'm also trying to sort out some ext3 bug where jbd
flushes some dirty pages to disk ahead of writing out a transaction
but the dirty page writeback fails.  Apparently the userspace program
is long gone by the time this happens (I haven't been able to verify
that they're actually calling fsync) and the FS doesn't shut down,
but a later umount/mount/reread shows old file contents.  Hence I
now know about data_err=abort.)

--D

> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
