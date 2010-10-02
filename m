From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6 v4] Lazy itable initialization for Ext4
Date: Sat, 2 Oct 2010 15:55:35 -0400
Message-ID: <20101002195535.GM21129@thunk.org>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
 <20100928040142.GA7865@thunk.org>
 <alpine.LFD.2.00.1009291516270.2982@dhcp-lab-213.englab.brq.redhat.com>
 <alpine.LFD.2.00.1010011752280.2854@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33831 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab0JBTzm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Oct 2010 15:55:42 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010011752280.2854@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 01, 2010 at 05:58:52PM +0200, Lukas Czerner wrote:
> 
> After extensive xfstest-ing I have not been able to reproduce it.
> However, after a while hammering it with other stress test (the one
> I have proposed to test batched discard implementation with) I have
> got a panic due to not up-to-date buffer_head in submit_bh() :
> kernel BUG at fs/buffer.c:2910! - I have been able to reproduce it
> every time (on different BUG_ON sometimes)

I found it --- or at least I found one of the problems.

The call to ext4_unregister_li_request(sb) comes *after* the call to
jbd2_journal_destroy().  If while we are destroying the journal, we
get unlucky and call ext4_init_inode_table(), then we end up creating
a handle after the journal thread is shutdown, during the final call
to jbd2_journal_commit_transaction(), but before
jbd2_journal_destroy() calls jbd2_log_do_checkpoint(), then we end up
waiting forever in jbd2_log_wait_commit().

This shouldn't however lock up the system tight enough that it doesn't
respond to magic sysrq, but I haven't seen that problem since I moved
from 2.6.36-rc3 to 2.6.36-rc6.  I do see this problem, which is
definitely a bug.

I am getting a lot of warnings from fs/writeback.c:76 (Dirtiable inode
bdi block != sb bdi block) which I have been commenting out for now,
since it seems to be noisy but otherwise relatively harmless.

I also found a bug in ext4_init_inode_table() where you compare 
(num > EXT4_INODES_PER_GROUP(sb)) in ext4_init_inode_table(), which
I'm pretty sure should be (num > sbi->s_itb_per_group) instead.

Regards,

							- Ted
