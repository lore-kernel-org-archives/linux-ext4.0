From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] jbd2: optimize jbd2_journal_force_commit
Date: Mon, 10 Jun 2013 09:53:57 -0400
Message-ID: <20130610135357.GC23051@thunk.org>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
 <1369732741-26070-2-git-send-email-dmonakhov@openvz.org>
 <20130528212205.GB16408@quack.suse.cz>
 <87ppw3fnqh.fsf@openvz.org>
 <20130610130730.GA23051@thunk.org>
 <87ehcaw1d0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56603 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab3FJNyC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jun 2013 09:54:02 -0400
Content-Disposition: inline
In-Reply-To: <87ehcaw1d0.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 10, 2013 at 05:18:19PM +0400, Dmitry Monakhov wrote:
> > Have you had a chance to work on an updated version of this series
> > with Jan's requested changes?
> Yes. It is ready, but since Jan is on vacations till 20'th I thought
> it is useless to send it before that date. Am I right?

Please send it now; other folks, including myself, can review it.
Since we are already at 3.10-rc5, I'd get the ext4/jbd2-related
patches reviewed and in the ext4 tree sooner rather than later.

Many thanks!!

					- Ted
