From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH,RFC 7/7] ext4: move ext4_journal_start/stop to
 mpage_da_map_and_submit()
Date: Thu, 17 Feb 2011 23:23:53 -0500
Message-ID: <20110218042353.GA4923@thunk.org>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu>
 <1297556157-21559-8-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47545 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab1BREXz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Feb 2011 23:23:55 -0500
Content-Disposition: inline
In-Reply-To: <1297556157-21559-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 12, 2011 at 07:15:57PM -0500, Theodore Ts'o wrote:
> Previously, ext4_da_writepages() was responsible for calling
> ext4_journal_start() and ext4_journal_stop().  If the blocks had
> already been allocated (we don't support journal=data in
> ext4_da_writepages), then there's no need to start a new journal
> handle.
> 
> By moving ext4_journal_start/stop calls to mpage_da_map_and_submit()
> we should significantly reduce the cpu usage (and cache line bouncing)
> if the journal is enabled.  This should (hopefully!) be especially
> noticeable on large SMP systems.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Argh, it turns out this doesn't work.  I was getting sporadic
deadlocks and I finally figured out the problem.  If a process is
holding page locks, it can't call ext4_journal_start() safely in
data=ordered, since there's a chance that there won't be enough
transaction credits and a new transaction will be started.  And at
that point, in data=ordered mode, we may end up calling
journal_submit_inode_data_buffers(), which could try to write back the
inode pages in question --- which are already locked.

This means that we need to start the journal handle long before we
know whether or not we really need it.  Boo, hiss!

The only way to solve this problem is to do what I've been planning
all for a while, which is to add support in ext4_map_blocks() for a
mode where it will allocate a region of blocks, but *not* update the
extent map.  It will have to store the allocation in an in-memory
cache, so that if other CPU's try to request a logical block, it will
get the right answer.  However, the actual on-disk extent map can't be
updated until *after* the data is safely written on disk (and the
pages can thus be unlocked).

Once we do that, we'll also be able to ditch ordered mode for good,
since it means that there won't be any chance of stale data being
revealed, without any of performance disasters involved with
data=ordered mode.

I have no idea what these changes will do to Amir's snapshot plans,
but sorry, getting this right is going to be higher priority.

I may end up submitting the rest of this patch series without this
last patch, since it does clean up the code paths a lot, and it should
result in a few small performance improvements --- the big performance
improvement, found in this patch, we'll have to skip until we can fix
up the writeback submission.

		     	      	       - Ted
