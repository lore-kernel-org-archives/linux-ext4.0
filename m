From: Jan Kara <jack@suse.cz>
Subject: Re: quota locking inversion with ext2
Date: Mon, 31 May 2010 19:29:40 +0200
Message-ID: <20100531172939.GB5334@quack.suse.cz>
References: <20100531094704.GB10283@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab0EaR3w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 13:29:52 -0400
Content-Disposition: inline
In-Reply-To: <20100531094704.GB10283@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 31-05-10 11:47:04, Christoph Hellwig wrote:
> ext2 + quota isn't too happy during xfstests 230:
  Hmm, this looks new. At least I haven't seen such lockdep trace last
week. Thanks for sending it to me.
  Looking at the lockdep trace is seems that tty->atomic_write_lock can be
held while we take page fault. So effectively it depends on the filesystem.
But quota (if you have CONFIG_PRINT_QUOTA_WARNING enabled, which is
obsolete by now) has to print quota warning to console so somewhere deep
inside the filesystem we have to take tty->atomic_write_lock.
  I currently don't know how to get rid of this dependency :( and I'm not
sure how much effort should we put into solving this when it's an obsolete
way of doing things...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
