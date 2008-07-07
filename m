From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
Date: Mon, 7 Jul 2008 12:07:05 +0200
Message-ID: <20080707100705.GA3593@duck.suse.cz>
References: <20080602124409.GL30613@duck.suse.cz> <4844CB39.6060409@hitachi.com> <20080603080219.GA17936@duck.suse.cz> <485F85AE.1010704@hitachi.com> <20080623122240.GJ26743@duck.suse.cz> <4860E01B.8010806@hitachi.com> <20080624133309.GG9959@duck.suse.cz> <48649FA0.70303@hitachi.com> <20080627102419.GC3602@duck.suse.cz> <48686A75.9010809@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54629 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751908AbYGGKHH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2008 06:07:07 -0400
Content-Disposition: inline
In-Reply-To: <48686A75.9010809@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Mon 30-06-08 14:09:09, Hidehiro Kawai wrote:
> Jan Kara wrote:
> 
> > On Fri 27-06-08 17:06:56, Hidehiro Kawai wrote:
> > 
> >>Jan Kara wrote:
> >>
> >>
> >>>On Tue 24-06-08 20:52:59, Hidehiro Kawai wrote:
> >>
> >>>>>>3. is implemented as described below.
> >>>>>>(1) if log_do_checkpoint() detects an I/O error during
> >>>>>>    checkpointing, it calls journal_abort() to abort the journal
> >>>>>>(2) if the journal has aborted, don't update s_start and s_sequence
> >>>>>>    in the on-disk journal superblock
> >>>>>>
> >>>>>>So, if the journal aborts, journaled data will be replayed on the
> >>>>>>next mount.
> >>>>>>
> >>>>>>Now, please remember that some dirty metadata buffers are written
> >>>>>>back to the filesystem without journaling if the journal aborted.
> >>>>>>We are happy if all dirty metadata buffers are written to the disk,
> >>>>>>the integrity of the filesystem will be kept.  However, replaying
> >>>>>>the journaled data can overwrite the latest on-disk metadata blocks
> >>>>>>partly with old data.  It would break the filesystem.
> >>>>>
> >>>>> Yes, it would. But how do you think it can happen that a metadata buffer
> >>>>>will be written back to the filesystem when it is a part of running
> >>>>>transaction? Note that checkpointing code specifically checks whether the
> >>>>>buffer being written back is part of a running transaction and if so, it
> >>>>>waits for commit before writing back the buffer. So I don't think this can
> >>>>>happen but maybe I miss something...
> >>>>
> >>>>Checkpointing code checks it and may call log_wait_commit(), but this
> >>>>problem is caused by transactions which have not started checkpointing.
> >>>>
> >>>>For example, the tail transaction has an old update for block_B and
> >>>>the running transaction has a new update for block_B.  Then, the
> >>>>committing transaction fails to write the commit record, it aborts the
> >>>>journal, and new block_B will be written back to the file system without
> >>>>journaling.  Because this patch doesn't separate between normal abort
> >>>>and checkpointing related abort, the tail transaction is left in the
> >>>>journal space.  So by replaying the tail transaction, new block_B is
> >>>>overwritten with old one.
> >>>
> >>>  Yes, and this is expected an correct. When we cannot properly finish a
> >>>transaction, we have to discard everything in it. A bug would be (and I
> >>>think it could currently happen) if we already checkpointed the previous
> >>>transaction and then written over block_B new data from the uncommitted
> >>>transaction. I think we have to avoid that - i.e., in case we abort the
> >>>journal we should not mark buffers dirty when processing the forget loop.
> >>
> >>Yes.
> >>
> >>
> >>>But this is not too serious since fsck has to be run anyway and it will
> >>>fix the problems.
> >>
> >>Yes.  The filesystem should be marked with an error, so fsck will check
> >>and recover the filesystem on boot.  But this means the filesystem loses
> >>some latest updates even if it was cleanly unmounted (although some file
> >>data has been lost.)  I'm a bit afraid that some people would think of
> >>this as a regression due to this PATCH 4/5.  At least, to avoid
> >>undesirable replay, we had better keep journaled data only when the
> >>journal has been aborted for checkpointing related reason.
> > 
> >   I don't think this makes any difference. Look: We have transaction A
> > modifying block B fully committed to the journal. Now there is a running
> > (or committing, it does not really matter) transaction R also modifying block
> > B. Until R gets fully committed, no block modified by R is checkpointed
> > to the device - checkpointing code takes care of that and it must be so
> > to satisfy journaling guarantees.
> >   So if we abort journal (for whatever reason) before R is fully committed,
> > no change in R will be seen on the filesystem regardless whether you
> > cleanup the journal or not.
> 
> No, changes in R will be seen on the filesystem.
> The metadata buffer for block B is marked as dirty when it is unfiled
> whether the journal has aborted or not.  Eventually the buffer will be
> written-back to the filesystem by pdflush.  Actually I have confirmed
> this behavior by using SystemTap.  So if both journal abort and
> system crash happen at the same time, the filesystem would become
> inconsistent state.  As I stated, replaying the journaled block B in
> transaction A may also corrupt the filesystem, because changes in
> transaction R are reflected halfway.  That is why I sent a patch to
> prevent metadata buffers from being dirtied on abort.
  Ah, ok. Thanks for explanation. Yes, we should not mark buffers dirty
when journal is aborted and we unfile them. That should fix the whole
problem.
								Bye
									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
