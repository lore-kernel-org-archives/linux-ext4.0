From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Fix last mount time and last write time in preen
 mode
Date: Fri, 4 Jul 2014 16:32:04 -0400
Message-ID: <20140704203204.GD11103@thunk.org>
References: <1400596186-4228-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45829 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030502AbaGDUcH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jul 2014 16:32:07 -0400
Content-Disposition: inline
In-Reply-To: <1400596186-4228-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 20, 2014 at 04:29:46PM +0200, Jan Kara wrote:
> Fixing last mount time and last write time is safe - there's no risk of
> loosing any important information or making corruption significantly
> worse even if we get it wrong. So let's just fix these times in preen
> mode. This allows initrd to automatically check and mount root
> filesystem in case system clock is wrong without having to manually set
> broken_system_clock variable (openSUSE uses broken_system_clock by default
> to avoid these problems during boot but this disables time-based checks
> even on systems where clock is fine so that's not ideal either).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I've accepted this change.  Note that the most common case where the
system clock is wrong, which is when the time gets reliably stuck in
the 1970's, immediately after the system boots, we end up declaring
the system clock "insane", and so we end up skipping the time-based
checks anyway.

I guess I've gotten more soft in my old age about wanting to guarantee
that time-based checks happen when they should.  If you have crappy
hardware that corrupts data blocks, or buggy kernels, time-based
checks aren't really going to save you, especially given that most
people aren't rebooting their systems all that often anyway.  Getting
people to run a script out of crontab which takes read-only snapshots
and runs fsck on those snapshots is much more likely to protect
against these sorts of issues.

Cheers,

					- Ted
