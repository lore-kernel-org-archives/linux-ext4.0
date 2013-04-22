From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/5] jbd2: optimize jbd2_journal_force_commit
Date: Mon, 22 Apr 2013 12:11:11 +0400
Message-ID: <87k3nvhtnk.fsf@openvz.org>
References: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org> <1365966097-8968-2-git-send-email-dmonakhov@openvz.org> <20130415122913.GF2299@quack.suse.cz> <87vc7lsj0w.fsf@openvz.org> <20130418180727.GA14470@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:33531 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3DVILP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Apr 2013 04:11:15 -0400
Received: by mail-la0-f44.google.com with SMTP id ed20so2197540lab.17
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2013 01:11:14 -0700 (PDT)
In-Reply-To: <20130418180727.GA14470@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 18 Apr 2013 20:07:27 +0200, Jan Kara <jack@suse.cz> wrote:
> On Wed 17-04-13 11:39:27, Dmitry Monakhov wrote:
> > On Mon, 15 Apr 2013 14:29:13 +0200, Jan Kara <jack@suse.cz> wrote:
> > > On Sun 14-04-13 23:01:34, Dmitry Monakhov wrote:
> > > > Current implementation of jbd2_journal_force_commit() is suboptimal because
> > > > result in empty and useless commits. But callers just want to force and wait
> > > > any unfinished commits. We already has jbd2_journal_force_commit_nested()
> > > > which does exactly what we want, except we are guaranteed that we do not hold
> > > > journal transaction open.
> > >   Umm, I have a questions regarding this patch:
> > > Grep shows there are just two places in the code which use
> > > ext4_force_commit() (and thus jbd2_journal_force_commit()). These are
> > > ext4_write_inode() and ext4_sync_file() (in data=journal mode). The first
> > > callsite can use _nested() variant immediately as we even assert there's
> > > no handle started. The second call site can use the _nested variant as well
> > > because if we had the transaction started when entering ext4_sync_file() we
> > > would have serious problems (lock inversion, deadlocks in !data=journal
> > > modes) anyway. So IMO there's no need for !nested variant at all (at least
> > > in ext4, ocfs2 uses it as well, IMHO it can be converted as well but that's
> > > a different topic). Thoughts?
> > I'm not sure that I completely understand what you meant, but it seems
> > incorrect to use jbd2_journal_force_commit_nested() in 
> > ext4_write_inode() and ext4_sync_file(). Because nested variant has
> > probabilistic behavior, It may skip real transaction commit if we hold
> > a transaction running.  ext4_write_inode() and ext4_sync_file() 
> > are the functions where we demand deterministic behavior. If we silently
> > miss real transaction commit because current->journal_info != NULL (due
> > to some bugs) this breaks data integrity assumptions and it is better to
> > make it loud and trigger a BUGON.
>   I see. I was confused by the fact that 'nested' argument got used only in
> the assertion but now I see why that is.
Do you give me your ACK/Reviewed  signature?
> 
> 									Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
