From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] jbd2: optimize jbd2_journal_force_commit
Date: Mon, 10 Jun 2013 09:07:30 -0400
Message-ID: <20130610130730.GA23051@thunk.org>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
 <1369732741-26070-2-git-send-email-dmonakhov@openvz.org>
 <20130528212205.GB16408@quack.suse.cz>
 <87ppw3fnqh.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56584 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab3FJNHg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jun 2013 09:07:36 -0400
Content-Disposition: inline
In-Reply-To: <87ppw3fnqh.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 03, 2013 at 03:16:38PM +0400, Dmitry Monakhov wrote:
> Ok, sound reasonable. In fact __jbd2_journal_force_commit() should be
> static so misuse is no likely to happen.
>
> >   Also if we move the WARN_ON(!current->journal_info) here, we can remove
> > the 'nested' argument.
> Also agree. Will send you with updated version soon.

Hi Dmitry,

Have you had a chance to work on an updated version of this series
with Jan's requested changes?

Thanks,

					- Ted
