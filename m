From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] jbd2: Speedup jbd2_journal_dirty_metadata()
Date: Mon, 8 Jun 2015 12:50:37 -0400
Message-ID: <20150608165037.GN19168@thunk.org>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <1427983100-29889-6-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53301 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbbFHQuj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 12:50:39 -0400
Content-Disposition: inline
In-Reply-To: <1427983100-29889-6-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2015 at 03:58:20PM +0200, Jan Kara wrote:
> It is often the case that we mark buffer as having dirty metadata when
> the buffer is already in that state (frequent for bitmaps, inode table
> blocks, superblock). Thus it is unnecessary to contend on grabbing
> journal head reference and bh_state lock. Avoid that by checking whether
> any modification to the buffer is needed before grabbing any locks or
> references.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
