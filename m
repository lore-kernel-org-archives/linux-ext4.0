From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 deadlock (+lockdep splat) during rsync
Date: Thu, 19 Jan 2017 18:19:31 -0500
Message-ID: <20170119231931.bxnltnlwinjdzvxa@thunk.org>
References: <20170108224114.27157.qmail@ns.sciencehorizons.net>
 <20170119173707.GA11602@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@sciencehorizons.net>,
        linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35358 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdASXU0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 19 Jan 2017 18:20:26 -0500
Content-Disposition: inline
In-Reply-To: <20170119173707.GA11602@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 19, 2017 at 06:37:07PM +0100, Jan Kara wrote:
> OK, the problem is that we call ext4_mark_inode_dirty() while holding
> xattr_sem and that recurses into ext4_expand_extra_isize_ea() which tries
> to grab it again. This may happen in several place in inline.c, generally
> when handling inline directories. I'll try to craft a fix tomorrow...

I think the inline_data patches I posted should have taken care of
George's initial set of bug reports?

(And George, the reason why you're seeing lots of problems is because
inline_data isn't enabled by default yet, and as the old joke goes,
the Early Christians get the best Lions.  :-)

						- Ted
