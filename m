From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC V2] ext4: flush delalloc blocks when space is low
Date: Thu, 5 Nov 2009 17:05:39 +0100
Message-ID: <20091105160539.GE17008@atrey.karlin.mff.cuni.cz>
References: <4ADE24CF.1080906@redhat.com> <4ADF6628.9080105@redhat.com> <20091105140913.GD17008@atrey.karlin.mff.cuni.cz> <4AF2F327.7090402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37610 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZKEQFe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2009 11:05:34 -0500
Content-Disposition: inline
In-Reply-To: <4AF2F327.7090402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Jan Kara wrote:
> ...
> 
> >> +	/* try a sync to flush delalloc space & free resvd metadata */
> >> +	if (!ext4_has_free_blocks(EXT4_SB(sb), 1) && dirtyblocks) {
> >> +		if (!ext4_journal_current_handle()) {
> >> +			down_read(&sb->s_umount);
> >> +			sync_inodes_sb(sb);
> >> +			up_read(&sb->s_umount);
> >   ext4_should_retry_alloc() is called quite deep from the filesystem. In
> > particular we can hold i_mutex of some inodes etc. So I'd almost bet
> > that taking s_umount sem here violates lock ranking in some code paths
> > (an easy check would be to enable lockdep and stress the filesystem a
> > bit).
> >   Also calling sync_inodes_sb() with i_mutex held just seems as a bad
> > thing to do although I don't see where it could deadlock and so it's
> > probably just a matter of taste...
> 
> Well, to be honest I agree with you ;)  It does still feel like a hack.
> 
> >   If we start writeback from ext4_nonda_switch as you do below, I think
> > that we should get decent results even without synchronous writeback in
> > the allocation path (maybe we'd need to tweak a bit the logic in
> > ext4_nonda_switch to provide more time for writeback thread to catchup).
> 
> I think starting writeback helps a lot, but it seems that in the end we
> still need a synchronous attempt when we hit a real enocpc... after I
> finish dealing with this corruption thing I'll come back and look at this.
  Without the synchronous attempt, it will never be perfect, that is
correct. But it could be quite close to perfect...

> Maybe we should put the writeback in for now, and worry about the
> synchronous sync-up later?
  Yes, I'd do that for now.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
