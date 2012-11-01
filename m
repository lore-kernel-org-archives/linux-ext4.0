From: "George Spelvin" <linux@horizon.com>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: 1 Nov 2012 02:12:12 -0400
Message-ID: <20121101061212.16497.qmail@science.horizon.com>
References: <20121101015015.GA28919@thunk.org>
Cc: linux-ext4@vger.kernel.org, linux@horizon.com, tm@tao.ma
To: darrick.wong@oracle.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:16372 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751312Ab2KAGMN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2012 02:12:13 -0400
In-Reply-To: <20121101015015.GA28919@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> This one was cc'ed to stable@vger.kernel.org.  But when you said "I
> notice, that neither of thse have made it into 2.6.5", I assume you
> meant 3.5?

Whoops, typo!  I meant 3.6.5, the very latest just-out-today stable
kernel.

Quite a few 3.6.x kernels have come out since that patch was Cc'ed,
and it keeps not being included.  So I wondered.

> So that means it should eventually make it to the 3.4.x and 3.6.x
> kernels.

That's what I thought, but I didn't want to pester Greg until I was sure
of your intentions.

> At this point I'll just include it in the patches to be sent to Linus
> at the next merge window, mainly because I don't have the time to run
> a separate regression test run just for this patch, and it's only a
> cosmetic issue, right?

Well, it causes the file system to be marked dirty and unnecessarily
checked on reboot, which I contend is a bug, but it's not a data-loss
bug.

I do worry that it could cause file lookup to fail when it shouldn't,
which *is* effectively a data-loss bug, even if the data reappears
on reboot.  But I'd have to understand the problem and fix better to
know if that actually happens; I haven't observed it.
