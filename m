From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/6] jbd2: optimize jbd2_journal_force_commit
Date: Mon, 10 Jun 2013 17:18:19 +0400
Message-ID: <87ehcaw1d0.fsf@openvz.org>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org> <1369732741-26070-2-git-send-email-dmonakhov@openvz.org> <20130528212205.GB16408@quack.suse.cz> <87ppw3fnqh.fsf@openvz.org> <20130610130730.GA23051@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:39607 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3FJNSZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jun 2013 09:18:25 -0400
Received: by mail-la0-f44.google.com with SMTP id er20so5757812lab.17
        for <linux-ext4@vger.kernel.org>; Mon, 10 Jun 2013 06:18:23 -0700 (PDT)
In-Reply-To: <20130610130730.GA23051@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 10 Jun 2013 09:07:30 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 03, 2013 at 03:16:38PM +0400, Dmitry Monakhov wrote:
> > Ok, sound reasonable. In fact __jbd2_journal_force_commit() should be
> > static so misuse is no likely to happen.
> >
> > >   Also if we move the WARN_ON(!current->journal_info) here, we can remove
> > > the 'nested' argument.
> > Also agree. Will send you with updated version soon.
> 
> Hi Dmitry,
> 
> Have you had a chance to work on an updated version of this series
> with Jan's requested changes?
Yes. It is ready, but since Jan is on vacations till 20'th I thought
it is useless to send it before that date. Am I right?
> 
> Thanks,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
