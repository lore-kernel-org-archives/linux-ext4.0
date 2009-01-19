From: Andreas Dilger <adilger@sun.com>
Subject: Re: The meaning of data=ordered as it relates to delayed allocation
Date: Tue, 20 Jan 2009 03:10:41 +0800
Message-ID: <20090119191041.GA3286@webber.adilger.int>
References: <E1LOiN8-0001Cj-91@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58084 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbZASTLE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2009 14:11:04 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n0JJAmFu004822
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 11:11:02 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KDQ00501FTQZF00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 19 Jan 2009 11:10:48 -0800 (PST)
In-reply-to: <E1LOiN8-0001Cj-91@closure.thunk.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 18, 2009  19:52 -0500, Theodore Ts'o wrote:
> An Ubuntu user recently complained about a large number of recently
> updated files which were zero-length after an crash.  I started looking
> more closely at that, and it's because we have an interesting
> interpretation of data=ordered.  It applies for blocks which are already
> allocated, but not for blocks which haven't been allocated yet.  This
> can be surprising for users; and indeed, for many workloads where you
> aren't using berk_db some other database, all of the files written will 
> be newly created files (or files which are getting rewritten after
> opening with O_TRUNC), so there won't be any difference between
> data=writeback and data=ordered.
> 
> So I wonder if we should either:
> 
> (a) make data=ordered force block allocation and writeback --- which
>     should just be a matter of disabling the
>     redirty_page_for_writepage() code path in ext4_da_writepage()

That would re-introduce the "Firefox" problem where fsync of one file forces
all other files being written to flush their data blocks to disk.

> (b) add a new mount option, call it data=delalloc-ordered which is (a)

I'd prefer a better name, like "flushall-ordered" or similar, because to
me "delalloc-ordered" would imply the current behaviour.

> (c) change the default mount option to be data=writeback

That can expose garbage data to the user, which the current behaviour
does not do.

> (d) Do (b) and make it the default
> 
> (e) Keep things the way they are
> 
> Thoughts, comments?   My personal favorite is (b).   This allows users
> who want something that works functionally much more like ext3 to get
> that, while giving us the current speed advantages of a more aggressive
> delayed allocation.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

