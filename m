From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix oops in jbd2_journal_remove_journal_head()
Date: Sun, 12 Jun 2011 17:41:13 -0400
Message-ID: <20110612214113.GD2662@thunk.org>
References: <1306768378-27748-1-git-send-email-jack@suse.cz>
 <20110606141630.GK7180@thunk.org>
 <20110608193142.GH5361@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56628 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab1FLVlR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Jun 2011 17:41:17 -0400
Content-Disposition: inline
In-Reply-To: <20110608193142.GH5361@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 08, 2011 at 09:31:42PM +0200, Jan Kara wrote:
> On Mon 06-06-11 10:16:30, Ted Tso wrote:
> > On Mon, May 30, 2011 at 05:12:58PM +0200, Jan Kara wrote:
> > >  /*
> > > - * For the unlocked version of this call, also make sure that any
> > > - * hanging journal_head is cleaned up if necessary.
> > > + * For the unlocked version of this call, also drop buffer_head reference.
> > >   *
> > >   * __jbd2_journal_refile_buffer is usually called as part of a single locked
> >      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Doesn't this paragraph refer to jbd2_journal_refile_buffer(), not
> > __jbd2_journal_refile_buffer()?  Or am I missing something?
>   Hmm, the comment seems to be wrong. The comment about buffer_head
> reference does not apply anymore. I'll fix that.


Are you going to be sending me a new version of this patch with this
comment fixed?  Or should I just remove it?

Thanks,

						- Ted
