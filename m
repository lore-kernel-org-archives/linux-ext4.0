From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4] jbd: abort when failed to log metadata buffers
	(rebased)
Date: Mon, 19 May 2008 05:14:31 +0200
Message-ID: <20080519031431.GC10233@duck.suse.cz>
References: <482A6E00.6080303@hitachi.com> <482A6F6F.20002@hitachi.com> <20080514131505.GE24363@duck.suse.cz> <482D6171.1090209@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Josef Bacik <jbacik@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41101 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750968AbYESDOd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 May 2008 23:14:33 -0400
Content-Disposition: inline
In-Reply-To: <482D6171.1090209@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 16-05-08 19:26:57, Hidehiro Kawai wrote:
> Jan Kara wrote:
> 
> > On Wed 14-05-08 13:49:51, Hidehiro Kawai wrote:
> > 
> >>Subject: [PATCH 3/4] jbd: abort when failed to log metadata buffers
> >>
> >>If we failed to write metadata buffers to the journal space and
> >>succeeded to write the commit record, stale data can be written
> >>back to the filesystem as metadata in the recovery phase.
> >>
> >>To avoid this, when we failed to write out metadata buffers,
> >>abort the journal before writing the commit record.
> >>
> >>Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> >>---
> >> fs/jbd/commit.c |    3 +++
> >> 1 file changed, 3 insertions(+)
> >>
> >>Index: linux-2.6.26-rc2/fs/jbd/commit.c
> >>===================================================================
> >>--- linux-2.6.26-rc2.orig/fs/jbd/commit.c
> >>+++ linux-2.6.26-rc2/fs/jbd/commit.c
> >>@@ -703,6 +703,9 @@ wait_for_iobuf:
> >> 		__brelse(bh);
> >> 	}
> >> 
> >>+	if (err)
> >>+		journal_abort(journal, err);
> >>+
> >> 	J_ASSERT (commit_transaction->t_shadow_list == NULL);
> > 
> >   Shouldn't this rather be further just before
> > journal_write_commit_record()? We should abort also if writing revoke
> > records etc. failed, shouldn't we?
> 
> Unlike metadata blocks, each revoke block has a descriptor with the
> sequence number of the commiting transaction.  If we failed to write
> a revoke block, there should be an old control block, metadata block,
> or zero-filled block where we tried to write the revoke block.
> In the recovery process, this old invalid block is detected by
> checking its magic number and sequence number, then the transaction
> is ignored even if we have succeeded to write the commit record.
> So I think we don't need to check for errors just after writing
> revoke records.
  Yes, I agree that not doing such check will not cause data corruption but
still I think that in case we fail to properly commit a transaction, we
should detect the error and abort the journal...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
