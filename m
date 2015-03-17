From: Jan Kara <jack@suse.cz>
Subject: Re: How is e2fsck's time_fudge supposed to behave?
Date: Tue, 17 Mar 2015 18:32:27 +0100
Message-ID: <20150317173227.GB6670@quack.suse.cz>
References: <55036536.5030300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbbCQRcc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2015 13:32:32 -0400
Content-Disposition: inline
In-Reply-To: <55036536.5030300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 13-03-15 17:31:18, Eric Sandeen wrote:
> I'm a little confused by e2fsck's time fudge current behavior, vs its
> apparent intent.
> 
> We do:
> 
> 	if ( ... &&
>             fs->super->s_mtime > (__u32) ctx->now) {
>                 pctx.num = fs->super->s_mtime;
>                 problem = PR_0_FUTURE_SB_LAST_MOUNT;
>                 if (fs->super->s_mtime <= (__u32) ctx->now + ctx->time_fudge)
>                         problem = PR_0_FUTURE_SB_LAST_MOUNT_FUDGED;
>                 if (fix_problem(ctx, problem, &pctx)) {
>                         fs->super->s_mtime = ctx->now;
>                         fs->flags |= EXT2_FLAG_DIRTY;
>                 }
> 
> So if we are inside the time_fudge value we simply change the problem,
> but PR_0_FUTURE_SB_LAST_MOUNT_FUDGED behaves exactly like
> PR_0_FUTURE_SB_LAST_MOUNT, other than the message:
> 
>         /* Last mount time is in the future (fudged) */
>         { PR_0_FUTURE_SB_LAST_MOUNT_FUDGED,
>           N_("@S last mount time is in the future.\n\t(by less than a day, "
>              "probably due to the hardware clock being incorrectly set)  "),
>           PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
> 
> vs:
> 
>         /* Last mount time is in the future */
>         { PR_0_FUTURE_SB_LAST_MOUNT,
>           N_("@S last mount time (%t,\n\tnow = %T) is in the future.\n"),
>           PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
> 
> So unless I'm missing something, the whole fudge_time dance does nothing
> except change the message, and after reading lots of words in the e2fsck.conf
> manpage ;) this bit seems relevant as to the intent:
> 
> > So by default, we allow the superblock  times  to
> > be  fudged  by  up to 24 hours.
> 
> I had the impression that "allow" meant "ignore" but this still triggers
> exactly the same action and correction.  Is that as intended?
> 
> I'll send a patch do a printf and take no other action if inside the
> fudge_time window, if that seems like the right thing to do.
  The actions became the same after commit
87aca2ad028b9 (e2fsck: fix last mount time and last write time in preen
mode). Previously only fudged values were allowed to be fixed in the preen
mode. The question is whether we now want to change e2fsck to just ignore
difference within fudge or whether we just stop doing that fudge thing.
Either makes sense to me...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
