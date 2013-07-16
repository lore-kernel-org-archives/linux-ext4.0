From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: block direct I/O writes during ext4_truncate
Date: Tue, 16 Jul 2013 12:49:42 -0400
Message-ID: <20130716164942.GA6002@thunk.org>
References: <1373861479-15136-1-git-send-email-tytso@mit.edu>
 <20130716154658.GE25632@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38307 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889Ab3GPQtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jul 2013 12:49:46 -0400
Content-Disposition: inline
In-Reply-To: <20130716154658.GE25632@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 16, 2013 at 05:46:58PM +0200, Jan Kara wrote:
> and ext4_setattr() does (again under i_mutex):
>                                         ext4_inode_block_unlocked_dio(inode);
>                                         inode_dio_wait(inode);
>                                         ext4_inode_resume_unlocked_dio(inode);

Ah, I missed this; thanks for pointing this out.

> So either DIO gets i_mutex first and then ext4_setattr() waits for it to
> complete, or truncate completes before unlocked DIO is able to get & drop
> i_mutex.
> 
> OTOH unlocked DIO *read* might be vulnerable to a race with truncate. That
> never acquires i_mutex so if the DIO read arrives after ext4_setattr() goes
> through inode_dio_wait(), we can have the read and truncate racing and read
> possibly submitting read of a just truncated block (which can get
> reallocated in theory while the IO is running).
> 
> So something like what you do in the patch is likely needed, just the
> justification is somewhat different and you should also rip out / adjust
> the other synchronizations we have in ext4_setattr(), ext4_ext_direct_IO()
> and ext4_ind_direct_IO().

Ok, I'll drop my current patch for now, and revisit this when I have a
bit more time.  I agree with your analysis, but fortunately it sounds
like this race is going to be pretty hard to hit in practice ---
especially, since with the journal enabled, we won't allow the block
to get reused until the next commit boundary.  The situation where we
would need to worry would be dioread_nolock combined with no journal
mode.

						- Ted
