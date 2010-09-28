From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6 v4] Lazy itable initialization for Ext4
Date: Tue, 28 Sep 2010 00:01:42 -0400
Message-ID: <20100928040142.GA7865@thunk.org>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51479 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab0I1EBp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Sep 2010 00:01:45 -0400
Content-Disposition: inline
In-Reply-To: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 16, 2010 at 02:47:25PM +0200, Lukas Czerner wrote:
> 
> as Mike suggested I have rebased the patch #1 against Jens'
> linux-2.6-block.git 'for-next' branch and changed sb_issue_zeroout()
> to cope with the new blkdev_issue_zeroout(), and changed
> sb_issue_zeroout() to the new syntax everywhere I am using it.
> Also some typos gets fixed.

We may have a problem with the lazy_itable patches.  I've tried
running the XFSTESTS three times now.  This was with a system where
mke2fs was setup (via /etc/mke2fs.conf) to always format the file
system using lazy_itable_init.  This meant that any of the xfstests
which reformated the scratch partition and then started a stress test
would stress the newly added itable initialization code.
Unfortunately the results weren't good.

The first time, I got the following soft lockup warning:

[ 2520.528745] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2520.531445]  ef2b8e44 00000046 00000007 e29c1500 e29c1500 e29c1760 e29c175c c0b55500
[ 2520.534983]  c0b55500 e29c175c c0b55500 c0b55500 c0b55500 32423426 00000224 00000000
[ 2520.538270]  00000224 e29c1500 00000001 ef205000 00000005 ef2b8e74 ef2b8e80 c026eb2c
[ 2520.541743] Call Trace:
[ 2520.542742]  [<c026eb2c>] jbd2_log_wait_commit+0x103/0x14f
[ 2520.544291]  [<c01711dc>] ? autoremove_wake_function+0x0/0x34
[ 2520.545816]  [<c026bf95>] jbd2_log_do_checkpoint+0x1a8/0x458
[ 2520.547431]  [<c026f4ed>] jbd2_journal_destroy+0x107/0x1d3
[ 2520.549602]  [<c01711dc>] ? autoremove_wake_function+0x0/0x34
[ 2520.551100]  [<c0252bef>] ext4_put_super+0x78/0x2f7
[ 2520.552798]  [<c01f3c3c>] generic_shutdown_super+0x47/0xb8
[ 2520.554692]  [<c01f3ccf>] kill_block_super+0x22/0x36
[ 2520.556470]  [<c01f3816>] deactivate_locked_super+0x22/0x3e
[ 2520.558372]  [<c01f3bf1>] deactivate_super+0x3d/0x41
[ 2520.560138]  [<c02057a9>] mntput_no_expire+0xb5/0xd8
[ 2520.561880]  [<c0206609>] sys_umount+0x273/0x298
[ 2520.563358]  [<c0206640>] sys_oldumount+0x12/0x14
[ 2520.564952]  [<c0646715>] syscall_call+0x7/0xb
[ 2520.566596] 3 locks held by umount/15126:
[ 2520.568121]  #0:  (&type->s_umount_key#20){++++..}, at: [<c01f3bea>] deactivate_super+0x36/0x41
[ 2520.571819]  #1:  (&type->s_lock_key#2){+.+...}, at: [<c01f3096>] lock_super+0x20/0x22
[ 2520.574788]  #2:  (&journal->j_checkpoint_mutex){+.+...}, at: [<c026f4e6>] jbd2_journal_destroy+0x100/0x1d3

In addition, there were these mysterious error messages:

[ 2542.026996] ata1: lost interrupt (Status 0x50)
[ 2542.029750] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 2542.032656] ata1.00: failed command: WRITE DMA
[ 2542.034312] ata1.00: cmd ca/00:10:00:00:00/00:00:00:00:00/e0 tag 0 dma 8192 out
[ 2542.034313]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 2542.039892] ata1.00: status: { DRDY }

Why are they strange?  Because this was running under KVM, and there
were no underlying hardware problems in the host OS.

The other two times I got a hard hang at XFStests 219 and 83, and the
system was caught in such a type look that magic-sysrq wasn't working
correctly.

I've XFStests in this setup before applying these patches, and things
worked fine.  I'm currently rolling back the patches and trying
another xfstests runs just to make sure the problem wasn't introduced
by some patch, but for now, it looks there might be a problem
somewhere.  And unfortunately, since it's not happening in a regular
location or test, and the system is so badly locked up sysrq doesn't
work, finding it may be intersting....

					- Ted
