From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] Fix filesystem freezing
Date: Thu, 12 Jan 2012 12:30:31 +0100
Message-ID: <20120112113031.GA8778@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
 <20120112024841.GB2806@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2ALLae (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 06:30:34 -0500
Content-Disposition: inline
In-Reply-To: <20120112024841.GB2806@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-01-12 13:48:41, Dave Chinner wrote:
> On Thu, Jan 12, 2012 at 02:20:49AM +0100, Jan Kara wrote:
> > 
> >   Hello,
> > 
> >   filesystem freezing is currently racy and thus we can end up with dirty data
> > on frozen filesystem (see changelog of the first patch for detailed race
> > description and proposed fix). This patch series aims at fixing this.
> 
> It only fixes the dirty data race (i.e. SB_FREEZE_WRITE). The same
> race conditions exist for SB_FREEZE_TRANS on XFS, and so need the
> same fix. That race has had one previous attempt at fixing it in
> XFS but that's not possible:
> 
> b2ce397 Revert "xfs: fix filesystsem freeze race in xfs_trans_alloc"
> 7a249cf xfs: fix filesystsem freeze race in xfs_trans_alloc
> 
> It was looking at that problem earlier today that lead to the
> solution Eric proposed. Essentially the method in these patches
> needs to replace the xfs specifc m_active_trans counter and delay
> during ->fs_freeze to prevent that race condition....
  OK, I see. I just checked ext4 to make sure and ext4 seems to get this
right. Looking into Christoph's original patch it shouldn't be hard to fix
it. Instead of:
        atomic_inc(&mp->m_active_trans);
 
        if (wait_for_freeze)
              xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);

we just need to do a bit more elaborate

retry:
        if (wait_for_freeze)
              xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
        atomic_inc(&mp->m_active_trans);
	if (wait_for_freeze && mp->m_super->s_frozen >= SB_FREEZE_TRANS) {
        	atomic_dec(&mp->m_active_trans);
		goto retry;
	}

Or does XFS support nested transactions (i.e. a thread already holding a
running transaction can call into xfs_trans_alloc() again)?
That would make things more complicated...

Using sb_start_write() instead of m_active_trans won't be that easy because
it can create A-A deadlocks (e.g. we do sb_start_write in
block_page_mkwrite() and then xfs_get_blocks() decides to start a
transaction and calls sb_start_write() again which might block if
filesystem freezing started in the mean time).

So it's up to XFS maintainers to decide what's best but I'd take
Christoph's patch with above fixup. I guess I'll put it in this series and
see what people say.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
