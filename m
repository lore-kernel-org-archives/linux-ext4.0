From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Thu, 25 Nov 2010 14:52:45 +1100
Message-ID: <20101125035245.GB3359@amd>
References: <20101123100239.GA4232@amd>
 <20101123101149.GB4232@amd>
 <20101123131857.GG6113@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101123131857.GG6113@quack.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 23, 2010 at 02:18:57PM +0100, Jan Kara wrote:
> On Tue 23-11-10 21:11:49, Nick Piggin wrote:
> > The issue of writeback_inodes_sb being synchronous so far as it has to
> > wait until the work has been dequeued is another subtlety. That is a
> > funny interface though, really. It has 3 callers, sync, quota, and
> > ubifs. From a quick look, quota and ubifs seem to think it is some kind
> > of synchronous writeout API.
>   Yes, they expect it and it used to be the case before per-bdi flusher
> threads existed (because the function submitted IO on its own). Then it
> was changed to an async interface in per-bdi flusher thread patches and
> then back again to a synchronous one... Sad history...
> 
> > It also really sucks that it can get deadlocked behind an unrelated item
> > in a workqueue. I think it should just get converted over to the
> > async-submission style as well.
>   Here I don't quite agree. After my patches (currently in -mm tree) all
> work items have reasonably well defined lifetime so no livelocks should
> occur.

It was actually a deadlock, and it was due to workqueue item for
writeback submission being held up behind item for completion, where
former is holding i_mutex and latter trying to acquire.

I haven't studied the patches in -mm, do they solve this problem?

> After all writeback thread is doing its best to do as much IO as
> possible (and hopefully saturates the storage) so given all the IO work
> items we cannot do much better. Where I see a room for improvement is
> that work items usually try to achieve a common goal - for example when we
> get two items "write all dirty pages", we have mostly fulfilled the second
> one after finishing the first one but we start from the beginning when
> processing the second request. But it seems non-trivial to do this request
> merging especially for different types of requests...

Well the request is still going via normal writeback submission. The
difference in my patch is that we just dynamically allocate it and don't
pass a pointer to sb, so we don't have to wait.

