From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Null pointer deref in do_aio_submit
Date: Fri, 10 Feb 2012 13:06:32 -0500
Message-ID: <x49zkcqo95j.fsf@segfault.boston.devel.redhat.com>
References: <Pine.LNX.4.64.1202100921580.1530@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab2BJSGe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 13:06:34 -0500
In-Reply-To: <Pine.LNX.4.64.1202100921580.1530@cobra.newdream.net> (Sage
	Weil's message of "Fri, 10 Feb 2012 09:27:51 -0800 (PST)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sage Weil <sage@newdream.net> writes:

> I hit the following under a reasonable simple aio workload:
>
>  - reasonably heavy load
>  - lots of threads doing buffered io to random files
>  - one thread submitting O_DIRECT aio to a single file (journal), all 
>    sequential (wrapping), 100MB
>  - probably somewhere between 1 and 50 aios outstanding at any point in 
>    time.
>
> The kernel was v3.2 mainline, plus unrelated btrfs and ceph patches.
>
> Is this a known issue?  Any other information that would be helpful?

I don't know for sure, but could you test with the following commit?
69e4747ee9727d660b88d7e1efe0f4afcb35db1b

Also, I'll note that it looks like you are doing O_SYNC + O_DIRECT AIO.
I'm curious to know what apps use that particular combination.  Is this
just a test case, or do you have an app which does this in production?

Cheers,
Jeff
