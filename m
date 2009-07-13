From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix a race between checkpointing code and
	journal_get_write_access()
Date: Mon, 13 Jul 2009 09:19:01 -0400
Message-ID: <20090713131901.GC12833@mit.edu>
References: <1245859360-5261-1-git-send-email-jack@suse.cz> <1245859360-5261-2-git-send-email-jack@suse.cz> <20090706025319.GG6706@mit.edu> <20090708223150.GB14005@mit.edu> <20090710100713.GB17524@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57405 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873AbZGMNTF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 09:19:05 -0400
Content-Disposition: inline
In-Reply-To: <20090710100713.GB17524@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 10, 2009 at 12:07:13PM +0200, Jan Kara wrote:
>   Yes, it should be "this should never happen", unless you run something
> like tune2fs while the filesystem is mounted. But looking at the code, I
> have missed that buffer could be dirty also in
> jbd2_journal_get_create_access() because jbd2_journal_forget() does not
> clear the dirty bit in case the buffer is just being committed. Attached
> patch should fix it. Thanks for report.

Thanks, added to the patch queue.

						- Ted
