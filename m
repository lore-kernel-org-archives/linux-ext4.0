From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Fix a race between checkpointing code and
	journal_get_write_access()
Date: Mon, 13 Jul 2009 15:29:58 +0200
Message-ID: <20090713132958.GC12293@duck.suse.cz>
References: <1245859360-5261-1-git-send-email-jack@suse.cz> <1245859360-5261-2-git-send-email-jack@suse.cz> <20090706025319.GG6706@mit.edu> <20090708223150.GB14005@mit.edu> <20090710100713.GB17524@duck.suse.cz> <20090713131901.GC12833@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbZGMNaA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 09:30:00 -0400
Content-Disposition: inline
In-Reply-To: <20090713131901.GC12833@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 13-07-09 09:19:01, Theodore Tso wrote:
> On Fri, Jul 10, 2009 at 12:07:13PM +0200, Jan Kara wrote:
> >   Yes, it should be "this should never happen", unless you run something
> > like tune2fs while the filesystem is mounted. But looking at the code, I
> > have missed that buffer could be dirty also in
> > jbd2_journal_get_create_access() because jbd2_journal_forget() does not
> > clear the dirty bit in case the buffer is just being committed. Attached
> > patch should fix it. Thanks for report.
> 
> Thanks, added to the patch queue.
  I've been doing some more tests here and there's one more path which emits
the warning when deleting symlinks (falsely this time). I'll send you the fix
when I verify that I cannot trigger the warning anymore.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
