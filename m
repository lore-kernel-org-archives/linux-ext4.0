From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: check missed return value ext4_sync_file
Date: Wed, 17 Mar 2010 12:23:00 +0100
Message-ID: <20100317112300.GA6352@atrey.karlin.mff.cuni.cz>
References: <87wrxij28h.fsf@openvz.org> <20100311162707.GB19923@atrey.karlin.mff.cuni.cz> <87y6hy9bqg.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56128 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754403Ab0CQLXD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Mar 2010 07:23:03 -0400
Content-Disposition: inline
In-Reply-To: <87y6hy9bqg.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Jan Kara <jack@suse.cz> writes:
> >> 
> >> If jbd2_log_start_commit return 0 then it means that transaction
> >> was already committed. So we don't have to issue barrier for
> >> ordered mode, because it was already done during commit.
> >   Umm, we have to - when a file has just been rewritten (i.e. no block
> > allocation), then i_datasync_tid is not updated and thus we won't commit
> > any transaction as a part of fdatasync (and that is correct because there
> > are no metadata that need to be written for that fdatasync). But we still
> > have to flush disk caches with data submitted by filemap_fdatawrite_and_wait.
> Yepp. I've missed that. i thought that transaction id updated even in that
> case.  The most unpleasant part in ext4_sync_file implementation is that
> barrier is issued on each fsync() call.  So some bad user may perform:
> while(1) fsync(fd); which result in bad system performance. And since barrier
> request is empty it is hard to detect the reason of troubles.
  Actually, you'll be able to see the barrier requests in the blktrace dump
so it won't be that hard to detect.

> Off course we may solve it by introducing some sort of dirty flag which is
> set in write_page, and clear in fsync. But it looks as ugly workaround.
  I agree that sending barrier request on each fsync isn't very nice but
in common case, I'd assume that an application calls fsync only if it has
written something to the file previously. So I wouldn't invest much into
solving this until I see a realistic use case where it matters...

> >> By unknown reason we ignored ret val from jbd2_log_wait_commit()
> >> so even in case of EIO fsync will succeed.
> >   I just forgot jbd2_log_wait_commit can return a failure...
> In respect to previous comments the patch reduced to simple missed
> error check fix.
  I guess you can resend the fix to Ted directly to catch his attention.

> BTW: While investigating similar code in ext3 i've found what fsync is broken
> in case of external journal.
  Yes, I've noticed this recently as well. So will you send a fix or should
I go and backport ext4 fixes of this?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
