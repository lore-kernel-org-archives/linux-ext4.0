From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] jbd: Add fixed tracepoints
Date: Mon, 23 May 2011 17:48:39 +0200
Message-ID: <20110523154839.GD4716@quack.suse.cz>
References: <1306162977-23061-1-git-send-email-lczerner@redhat.com>
 <1306162977-23061-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526Ab1EWPsl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 11:48:41 -0400
Content-Disposition: inline
In-Reply-To: <1306162977-23061-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 23-05-11 17:02:57, Lukas Czerner wrote:
> This commit adds fixed tracepoint for jbd. It has been based on fixed
> tracepoints for jbd2, however there are missing those for collecting
> statistics, since I think that it will require more intrusive patch so I
> should have its own commit, if someone decide that it is needed. Also
> there are new tracepoints in __journal_drop_transaction() and
> journal_update_superblock().
> 
> The list of jbd tracepoints:
> 
> jbd_checkpoint
> jbd_start_commit
> jbd_commit_locking
> jbd_commit_flushing
> jbd_commit_logging
> jbd_drop_transaction
> jbd_end_commit
> jbd_do_submit_data
> jbd_cleanup_journal_tail
> jbd_update_superblock_end
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
  The patch looks OK so I guess I'll take it (when that one minor thing in
the first patch is cleared up).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
