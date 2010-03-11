From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix io-barrier logic for external journal case
Date: Thu, 11 Mar 2010 17:27:08 +0100
Message-ID: <20100311162707.GB19923@atrey.karlin.mff.cuni.cz>
References: <87wrxij28h.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38955 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751599Ab0CKQ1K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 11:27:10 -0500
Content-Disposition: inline
In-Reply-To: <87wrxij28h.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> We have to submit barrier before we start journal commit process.
> otherwise transaction may be committed before data flushed to disk.
> There is no difference from performance of view, but definitely
> fsync becomes more correct.
> 
> If jbd2_log_start_commit return 0 then it means that transaction
> was already committed. So we don't have to issue barrier for
> ordered mode, because it was already done during commit.
  Umm, we have to - when a file has just been rewritten (i.e. no block
allocation), then i_datasync_tid is not updated and thus we won't commit
any transaction as a part of fdatasync (and that is correct because there
are no metadata that need to be written for that fdatasync). But we still
have to flush disk caches with data submitted by filemap_fdatawrite_and_wait.

> By unknown reason we ignored ret val from jbd2_log_wait_commit()
> so even in case of EIO fsync will succeed.
  I just forgot jbd2_log_wait_commit can return a failure...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
