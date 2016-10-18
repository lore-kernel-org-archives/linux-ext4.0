From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: sleeping function called in atomic
Date: Tue, 18 Oct 2016 10:12:31 -0400
Message-ID: <20161018141231.5tmxeua23u3fqeh7@thunk.org>
References: <5806168F.2010708@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44256 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755723AbcJROMv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Oct 2016 10:12:51 -0400
Content-Disposition: inline
In-Reply-To: <5806168F.2010708@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 18, 2016 at 03:33:19PM +0300, Nikolay Borisov wrote:
> Hello, 
> 
> I've been seeing the following splat ever since 4.8-rc1: 
> 
> [    2.795057] BUG: sleeping function called from invalid context at ./include/linux/buffer_head.h:358
> [    2.796742] in_atomic(): 1, irqs_disabled(): 0, pid: 993, name: mount
> [    2.797966] CPU: 0 PID: 993 Comm: mount Not tainted 4.9.0-rc1-clouder1 #62
> [    2.798952] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
> [    2.798952]  ffff880006423548 ffffffff81318c89 ffffffff819ecdd0 0000000000000166
> [    2.798952]  ffff880006423558 ffffffff810810b0 ffff880006423580 ffffffff81081153
> [    2.798952]  ffff880006e5a1a0 ffff88000690e400 0000000000000000 ffff8800064235c0
> [    2.798952] Call Trace:
> [    2.798952]  [<ffffffff81318c89>] dump_stack+0x67/0x9e
> [    2.798952]  [<ffffffff810810b0>] ___might_sleep+0xf0/0x140
> [    2.798952]  [<ffffffff81081153>] __might_sleep+0x53/0xb0
> [    2.798952]  [<ffffffff8126c1dc>] ext4_commit_super+0x19c/0x290
> [    2.798952]  [<ffffffff8126e61a>] __ext4_grp_locked_error+0x14a/0x230
> [    2.798952]  [<ffffffff81081153>] ? __might_sleep+0x53/0xb0
> [    2.798952]  [<ffffffff812822be>] ext4_mb_generate_buddy+0x1de/0x320

What's going on is that your file system is corrupted;
ext4_mb_generate_buddy() noticed that the number of free blocks as
claimed by the block group descriptors doesn't match with with the
number of free blocks as found in the allocation bitmap.  It calls
ext4_grp_locked_error() as a result, and in ext4_commit_super(), the
commit 4743f8399061: "ext4: Fix WARN_ON_ONCE in ext4_commit_super()"
we started taking a lock even when ext4_commit_super() is called with
sync == 0, which causes the lockdep complaint.

Thanks for reporting the problem.  I'll get a fix for 4.9, but note
that if you're seeing it a lot, you may want to take a look at when
your file system is getting corrupted when you run under KVM.  Perhaps
the writeback / caching policy which you're using is dangerous?

    	      		       	     	    	  - Ted
