From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Tue, 23 Nov 2010 14:18:57 +0100
Message-ID: <20101123131857.GG6113@quack.suse.cz>
References: <20101123100239.GA4232@amd>
 <20101123101149.GB4232@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab0KWNS7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 08:18:59 -0500
Content-Disposition: inline
In-Reply-To: <20101123101149.GB4232@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 23-11-10 21:11:49, Nick Piggin wrote:
> The issue of writeback_inodes_sb being synchronous so far as it has to
> wait until the work has been dequeued is another subtlety. That is a
> funny interface though, really. It has 3 callers, sync, quota, and
> ubifs. From a quick look, quota and ubifs seem to think it is some kind
> of synchronous writeout API.
  Yes, they expect it and it used to be the case before per-bdi flusher
threads existed (because the function submitted IO on its own). Then it
was changed to an async interface in per-bdi flusher thread patches and
then back again to a synchronous one... Sad history...

> It also really sucks that it can get deadlocked behind an unrelated item
> in a workqueue. I think it should just get converted over to the
> async-submission style as well.
  Here I don't quite agree. After my patches (currently in -mm tree) all
work items have reasonably well defined lifetime so no livelocks should
occur. After all writeback thread is doing its best to do as much IO as
possible (and hopefully saturates the storage) so given all the IO work
items we cannot do much better. Where I see a room for improvement is
that work items usually try to achieve a common goal - for example when we
get two items "write all dirty pages", we have mostly fulfilled the second
one after finishing the first one but we start from the beginning when
processing the second request. But it seems non-trivial to do this request
merging especially for different types of requests...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
