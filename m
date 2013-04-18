From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] jbd2: optimize jbd2_journal_force_commit
Date: Thu, 18 Apr 2013 20:07:27 +0200
Message-ID: <20130418180727.GA14470@quack.suse.cz>
References: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
 <1365966097-8968-2-git-send-email-dmonakhov@openvz.org>
 <20130415122913.GF2299@quack.suse.cz>
 <87vc7lsj0w.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab3DRSHb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Apr 2013 14:07:31 -0400
Content-Disposition: inline
In-Reply-To: <87vc7lsj0w.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 17-04-13 11:39:27, Dmitry Monakhov wrote:
> On Mon, 15 Apr 2013 14:29:13 +0200, Jan Kara <jack@suse.cz> wrote:
> > On Sun 14-04-13 23:01:34, Dmitry Monakhov wrote:
> > > Current implementation of jbd2_journal_force_commit() is suboptimal because
> > > result in empty and useless commits. But callers just want to force and wait
> > > any unfinished commits. We already has jbd2_journal_force_commit_nested()
> > > which does exactly what we want, except we are guaranteed that we do not hold
> > > journal transaction open.
> >   Umm, I have a questions regarding this patch:
> > Grep shows there are just two places in the code which use
> > ext4_force_commit() (and thus jbd2_journal_force_commit()). These are
> > ext4_write_inode() and ext4_sync_file() (in data=journal mode). The first
> > callsite can use _nested() variant immediately as we even assert there's
> > no handle started. The second call site can use the _nested variant as well
> > because if we had the transaction started when entering ext4_sync_file() we
> > would have serious problems (lock inversion, deadlocks in !data=journal
> > modes) anyway. So IMO there's no need for !nested variant at all (at least
> > in ext4, ocfs2 uses it as well, IMHO it can be converted as well but that's
> > a different topic). Thoughts?
> I'm not sure that I completely understand what you meant, but it seems
> incorrect to use jbd2_journal_force_commit_nested() in 
> ext4_write_inode() and ext4_sync_file(). Because nested variant has
> probabilistic behavior, It may skip real transaction commit if we hold
> a transaction running.  ext4_write_inode() and ext4_sync_file() 
> are the functions where we demand deterministic behavior. If we silently
> miss real transaction commit because current->journal_info != NULL (due
> to some bugs) this breaks data integrity assumptions and it is better to
> make it loud and trigger a BUGON.
  I see. I was confused by the fact that 'nested' argument got used only in
the assertion but now I see why that is.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
