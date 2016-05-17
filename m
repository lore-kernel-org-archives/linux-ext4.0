From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add lazyinit stats support
Date: Tue, 17 May 2016 00:45:07 -0400
Message-ID: <20160517044507.GW7799@thunk.org>
References: <1463456488-93466-1-git-send-email-wangshilong1991@gmail.com>
 <e7de9f2f-6a12-026c-c9fb-2e676fdc37e4@redhat.com>
 <CAP9B-Q=7BUzkODy_PAsWi3YT3pYBcqMDWPR6kR6pCqFMDa_tzA@mail.gmail.com>
 <43a7d624-5fd1-a3a5-5f18-a84ebde86f1f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Shilong <wangshilong1991@gmail.com>,
	linux-ext4@vger.kernel.org, adilger@dilger.ca,
	Shuichi Ihara <sihara@ddn.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32860 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbcEQEpO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2016 00:45:14 -0400
Content-Disposition: inline
In-Reply-To: <43a7d624-5fd1-a3a5-5f18-a84ebde86f1f@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2016 at 11:22:35PM -0500, Eric Sandeen wrote:
> 
> Sure thing; I'm still on the fence about usefulness, because if
> anyone really cares to wait for it to hit zero, they probably
> should have just changed their mkfs options to disable lazyinit.

Indeed, if you're going to stall your test startup until lazyinit is
done, it will be faster to let mke2fs initialize the inode table
blocks, since lazyinit deliberately rate limits how much I/O it sends
down to the disk in order to avoid impacting user latencies.  So i'd
recommend "mke2fs -E lazy_itable_init=0,lazy_journal_init=0" instead
of patching the kernel and then waiting for lazy itable init to
complete.  I think you'll be happier with how long this takes.

BTW, if you care about 99.9 percentile (long tail) latency as a
performance metric, it's a good idea to disable lazy inode table init
and just let mke2fs take its own sweet time.  This is what we do
inside Google, since we care very much about long tail latencies on a
number of our workloads.

Cheers,

						- Ted
