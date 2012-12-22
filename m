From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fix deadlock in journal_unmap_buffer()
Date: Fri, 21 Dec 2012 22:52:51 -0500
Message-ID: <20121222035251.GA5778@thunk.org>
References: <1355345416-13565-1-git-send-email-jack@suse.cz>
 <1355345416-13565-2-git-send-email-jack@suse.cz>
 <20121221195220.GF31731@thunk.org>
 <20121221230347.GB23652@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39849 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab2LVDxB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Dec 2012 22:53:01 -0500
Content-Disposition: inline
In-Reply-To: <20121221230347.GB23652@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 22, 2012 at 12:03:47AM +0100, Jan Kara wrote:
>   I should have commented on this in the changelog :).
> jbd2_journal_invalidatepage() gets called only for file pagecache pages.
> Because ocfs2 doesn't do data journalling it never sees buffers that are
> part of a transaction in jbd2_journal_invalidatepage() (similarly to ext4
> except for data=journal case). I'll send a patch to just stop calling
> jbd2_journal_invalidatepage() for ocfs2... But you are safe to merge this
> patch in the mean time.

Ok, so if ocfs2 never tries journalling data blocks, then buffer_jbd()
will always be NULL, which reduces jbd2_journal_invalidate() to be
equivalent in functionality to block_invalidatepage(), and so it will
never abort and return EBUSY.
  
Thanks for the explanation, I'll apply the patch.

						- Ted
