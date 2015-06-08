From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] jbd2: Simplify error path on allocation failure in
 do_get_write_access()
Date: Mon, 8 Jun 2015 12:42:11 -0400
Message-ID: <20150608164211.GK19168@thunk.org>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <1427983100-29889-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53272 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbbFHQmO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 12:42:14 -0400
Content-Disposition: inline
In-Reply-To: <1427983100-29889-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2015 at 03:58:17PM +0200, Jan Kara wrote:
> We were acquiring bh_state_lock when allocation of buffer failed in
> do_get_write_access() only to be able to jump to a label that releases
> the lock and does all other checks that don't make sense for this error
> path. Just jump into the right label instead.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
