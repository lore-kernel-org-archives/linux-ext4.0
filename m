From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Wed, 19 Dec 2012 03:05:26 +0100
Message-ID: <20121219020526.GG5987@quack.suse.cz>
References: <50D0A1FD.7040203@redhat.com>
 <20121219012710.GF5987@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Dave Wysochanski <dwysocha@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab2LSCFi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Dec 2012 21:05:38 -0500
Content-Disposition: inline
In-Reply-To: <20121219012710.GF5987@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 19-12-12 02:27:10, Jan Kara wrote:
> > With a u8 tid_t, the "else" clause from commit d9b0193 fires
> > frequently; I really think the underlying problem is that tid_geq()
> > etc does not properly handle wraparounds - if, say, target is 255
> > and j_commit_request is 0, we don't know if j_commit_request
> > is 255 tids behind, or 1 tid ahead.  I have to think about that
> > some more, unless it's obvious to someone else.
>   Well, there's no way to handle wraps better AFAICT. Tids eventually wrap
> and if someone has stored away tid of a transaction he wants committed and
> keeps it for a long time before using it, it can end up being anywhere
> before / after current j_commit_request. The hope was that it takes long
> enough to wrap around 32-bit tids. If this happens often in practice we may
> have to switch to 64-bit tids (in memory, on disk 32-bit tids are enough
> because of limited journal size).
> 
> > FWIW, some people have indeed seen that else clause fire upstream,
> > both in the case where j_commit_request is > 2^31 and the 
> > target is 0.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=46031
> > http://forums.debian.net/viewtopic.php?f=5&t=80741
>   This is actually curious. The fact that i_datasync_tid was 0 means that
> either journal was not initialized during ext3_iget() or j_commit_sequence
> was 0 during ext3_iget() - note that j_commit_sequence is initialized to
> j_transaction_sequence in journal_reset()... Hum, but in a case when
> ext3_load_journal() calls journal_wipe() and that finds j_tail != 0, we
> call journal_skip_recovery(). That ends up setting j_transaction_sequence
> to the last transaction in the log but j_commit_sequence is left at 0.
> I see that explains how we could hit the warning. I think we should
> initialize j_commit_sequence properly also when skipping recovery and that
> will solve the problem.
  Bah, I was wrong here. I misread ext3_journal_load(). We call
journal_load() after journal_wipe() and so j_transaction_sequence and
j_commit_sequence() are set properly... But then I don't see how
i_datasync_tid was zero (modulo the very unlikely event we happened to load
the inode just after wrapping tids).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
