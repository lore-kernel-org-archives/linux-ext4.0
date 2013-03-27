From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] jbd2: fix race between
 jbd2_journal_remove_checkpoint and ->j_commit_callback V2
Date: Wed, 27 Mar 2013 10:49:43 -0400
Message-ID: <20130327144943.GA14900@thunk.org>
References: <20130327025624.GA5861@thunk.org>
 <1364376164-31701-1-git-send-email-dmonakhov@openvz.org>
 <20130327143237.GA1771@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	wenqing.lz@taobao.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56372 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3C0Ott (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 10:49:49 -0400
Content-Disposition: inline
In-Reply-To: <20130327143237.GA1771@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 03:32:37PM +0100, Jan Kara wrote:
> > Changes since V1:
> >  - Simplify code-flow and add comments according to Jan's request
>   Looks good. Just one text correction below - Ted can you apply it please?
> ...
> > -
> > +	/* Drop all spin_locks because commit_callback may be block.
> > +	 * __journal_remove_checkpoint() can not destroy transaction
> > +	 * under us because it is marked as T_FINISHED yet */
>                                ^^^ is *not*

Nice catch.  Thanks, I've fixed up the comment.

					- Ted
