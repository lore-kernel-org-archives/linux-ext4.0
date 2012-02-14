From: Jan Kara <jack@suse.cz>
Subject: Re: [Bug 42763] directory access hangs without error
Date: Tue, 14 Feb 2012 15:22:31 +0100
Message-ID: <20120214142231.GF1934@quack.suse.cz>
References: <bug-42763-13602@https.bugzilla.kernel.org/>
 <201202131830.q1DIUSQv024633@bugzilla.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	Dave Chinner <dchinner@redhat.com>
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab2BNOWd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Feb 2012 09:22:33 -0500
Content-Disposition: inline
In-Reply-To: <201202131830.q1DIUSQv024633@bugzilla.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 13-02-12 18:30:28, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=42763
> --- Comment #6 from Eric Buddington <ebuddington@wesleyan.edu>  2012-02-13 18:30:27 ---
> The stuck threads look like this:
> 
> edu             D c023a2f4     0  9912      1 0x00000004
> f50b2b80 00000086 00000000 c023a2f4 f7b2b400 d5350000 c09f6d80 00000000
> c09f6d80 c1c5f500 0000000a c33dbee0 c023f172 00000000 d53515cc c33dbee0
> 000015cc d5352000 c8c4b4a4 c33dbee0 c1c5f500 f0e05dac c01558a1 00000246
> Call Trace:
> [<c023a2f4>] ? ext4_getblk+0x8b/0x13d
> [<c023f172>] ? search_dirblock+0x76/0xaf
> [<c01558a1>] ? arch_local_irq_save+0xf/0x14
> [<c0651740>] ? _raw_spin_lock_irqsave+0x8/0x2c
> [<c01c2cc3>] ? inode_wait+0x5/0x8
> [<c0650c36>] ? __wait_on_bit+0x2f/0x54
> [<c01c2cbe>] ? inode_owner_or_capable+0x30/0x30
> [<c0650cba>] ? out_of_line_wait_on_bit+0x5f/0x67
> [<c01c2cbe>] ? inode_owner_or_capable+0x30/0x30
> [<c014532b>] ? autoremove_wake_function+0x2f/0x2f
> [<c01c3610>] ? wait_on_bit.constprop.13+0x22/0x25
> [<c01c3c8b>] ? iget_locked+0x42/0xc5
> [<c023aad8>] ? ext4_iget+0x24/0x5be
  ...
  Interesting. So this isn't ext4 related at all. Rather it's a generic bug
in VFS's I_NEW handling introduced by 250df6ed (adding Dave and Al to CC).
That commit removed wake_up_inode() (in particular a memory barrier before
wake_up_bit()) on the basis that i_state transitions are protected by
i_lock. That would be fine if all the readers of i_state were using i_lock
as well. But they don't - in particular wait_on_inode() from
include/linux/writeback.h does not. So that commit opened a reordering
possibility where __I_NEW can be cleared *after* wake_up_bit() in
unlock_new_inode() happens and so wait_on_bit() in wait_on_inode() goes
to sleep indefinitely.

It seems to me the intent was that wait_on_inode() should use i_lock as
well so it would opencode bit waiting similarly to
__wait_on_freeing_inode(). Am I right? Alternatively, we'd have to back out
changes of unlock_new_inode() and wake_up_inode()... 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
