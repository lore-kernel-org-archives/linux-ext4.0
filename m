From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Speedup jbd2_journal_dirty_metadata()
Date: Sun, 5 Jul 2015 21:54:45 -0400
Message-ID: <20150706015445.GK8628@thunk.org>
References: <1435945032-17253-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
	Jan Kara <jack@suse.cz>
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40875 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbbGFByv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jul 2015 21:54:51 -0400
Content-Disposition: inline
In-Reply-To: <1435945032-17253-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 03, 2015 at 07:37:12PM +0200, Jan Kara wrote:
> From: Jan Kara <jack@suse.cz>
> 
> It is often the case that we mark buffer as having dirty metadata when
> the buffer is already in that state (frequent for bitmaps, inode table
> blocks, superblock). Thus it is unnecessary to contend on grabbing
> journal head reference and bh_state lock. Avoid that by checking whether
> any modification to the buffer is needed before grabbing any locks or
> references.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
