From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Ordered mode rewrite patch
Date: Fri, 25 Apr 2008 11:23:21 -0300
Message-ID: <20080425142321.GA6843@dmt>
References: <20080408121149.GB6901@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nathan Grennan <jack@cygnusx-1.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653AbYDYOUa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 10:20:30 -0400
Content-Disposition: inline
In-Reply-To: <20080408121149.GB6901@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

On Tue, Apr 08, 2008 at 02:11:49PM +0200, Jan Kara wrote:
>   Hello,
> 
>   attached is a jumbo patch that reverses locking order of transaction
> start and page lock in ext3 and rewrites handling of ordered data mode in
> JBD and ext3. Note that the patch will break compilation of ext4 and OCFS2.
> The patch survives LTP run on my test machine so it shouldn't eat your data
> immediately but bugs are of course possible...
>   I'm very interested in any results (both positive and negative) you could
> get with it :). Thanks for testing it.
> 
> 									Honza
> 
> PS: CCing also linux-ext4 list in case there are some other interested
> testers. Next on my todo list is to port this for ext4...

No luck for my testcase, similar fsync behaviour taking several seconds:

vim           D 0000000000000000     0  4088   4036
 ffff81017a143da8 0000000000000086 0000000000000000 ffffffff80236808
 ffff81022f272830 ffff81022f1ca730 ffff81022f272a70 0000000600000001
 00000000ffffffff 0000000000000003 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff80236808>] lock_timer_base+0x26/0x4b
 [<ffffffff802f8c00>] log_wait_commit+0x9f/0xed
 [<ffffffff8023f7b1>] autoremove_wake_function+0x0/0x2e
 [<ffffffff802f4dbf>] journal_stop+0x165/0x18d
 [<ffffffff8029a7d9>] __writeback_single_inode+0x17f/0x29d
 [<ffffffff8023f7b1>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8029b10a>] sync_inode+0x24/0x32
 [<ffffffff802e5602>] ext3_sync_file+0x8a/0x9c
 [<ffffffff8029d532>] do_fsync+0x52/0xa4
 [<ffffffff8029d5a7>] __do_fsync+0x23/0x36
 [<ffffffff8020b0ab>] system_call_after_swapgs+0x7b/0x80

