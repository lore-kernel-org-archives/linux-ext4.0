From: tytso@mit.edu
Subject: Re: [PATCH, RFC] ext4: Store basic fs error information in the
 superblock
Date: Thu, 24 Jun 2010 09:27:45 -0400
Message-ID: <20100624132745.GH6843@thunk.org>
References: <AANLkTikT18i8QAWassSdBBqps-nheNdwRNcmLfqtzDAr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57931 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab0FXN1r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jun 2010 09:27:47 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTikT18i8QAWassSdBBqps-nheNdwRNcmLfqtzDAr@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 24, 2010 at 03:09:16PM +0300, Amir G. wrote:
> Hi Ted,
> 
> I saw your patch to store fs error information in the superblock.
> I think it is a very useful feature and I have implemented something similar in
> next3_snapshot_journal_error.patch and e2fs_next3_message_buffer.patch
> (attached).
> 
> There is one big problem I encountered with this feature:
> If the file system error behavior is set to "abort" or "remount-ro",
> the journal recovery on the next mount will most likely write over the
> superblock with the errors information.

True, thanks for pointing that out; the simplest way to solve this for
my purposes is to snapshot those superblock fields and restore them
after replaying the journal.

> To solve this problem I stored the errors message buffer in the
> journal superblock
> and copied the message buffer to the filesystem superblock on journal
> recovery (both on mount and fsck).
> fsck also displays the errors buffer and clears it.

That's an interesting approach, although as you point out it only
works on file systems with a 4k block size.  Your design seems to be
focused on recording only the most recent logs, which makes sense in a
debugging environment.  My assumption was that the most recent
problems would probably be recorded in /var/log/messages, although if
the problem occurred on a single-disk system, that assumption probably
wouldn't hold true.  I wonder if the a better solution for this
particular use case is much larger ring buffer, and a hook into the
printk system which is guaranteed to record *everything*, even after a
panic or after the journal has been aborted and the file system has
been remounted read-only.

For the patch I wrote, my intention was as a supplement to
/var/log/messages --- where s_first_error_time might be from long
after /var/log/messages had rolled over.  So I was trying to solve a
somewhat different problem.  (Hmm, actually, it would probably be good
to save both details about the first as well as the most recent error.)

   	     	     	       	     	     - Ted
