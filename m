From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in
 start_this_handle() to control allocation flags.
Date: Tue, 31 May 2011 13:22:53 +0200
Message-ID: <20110531112253.GD5614@quack.suse.cz>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab1EaLWz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2011 07:22:55 -0400
Content-Disposition: inline
In-Reply-To: <1306563657-4334-1-git-send-email-mkatiyar@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 27-05-11 23:20:57, Manish Katiyar wrote:
> changes from v1 -> v2 :
> *) Update start_this_handle to take extra parameter to specify whether
> to retry the allocation or not.
> *) Added jbd allocation flags for callers to control the transaction allocation
> behavior. Callers can pass JBD2_TOPLEVEL if allocation needs to be done using GFP_KERNEL.
  The above changelog should be below where (*) is.

Also - this is mainly for Ted: I've looked at where we JBD2_TOPLEVEL could
actually be enabled and the results are: Pretty much nowhere.

The problem is that with ext4, we need i_mutex in io completion path to
end page writeback. So we cannot do GFP_KERNEL allocation whenever we hold
i_mutex because mm might wait in direct reclaim for IO to complete and that
cannot happen until we release i_mutex. And pretty much every write path in
ext4 holds i_mutex.

So JBD2_TOPLEVEL looks like a useless excercise to me and I'd just don't do
it.

> Pass extra flags in journal routines to specify if its ok to
> fail in the journal transaction allocation. Passing JBD2_FAIL_OK means caller is
> ok with journal start failures and can handle ENOMEM.
> 
> Update ocfs2 and ext4 routines to pass JBD2_NO_FAIL for the updated journal
> interface by default, to retain the existing behavior.
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/ext4_jbd2.h   |    2 +-
>  fs/ext4/super.c       |    2 +-
>  fs/jbd2/transaction.c |   44 ++++++++++++++++----------------------------
>  fs/ocfs2/journal.c    |    8 ++++----
>  include/linux/jbd2.h  |   13 +++++++++----
>  5 files changed, 31 insertions(+), 38 deletions(-)
  (*) HERE


> +/* JBD2 transaction allocation flags */
> +#define JBD2_NO_FAIL	0x00000001
> +#define JBD2_FAIL_OK	0x00000002
> +#define JBD2_TOPLEVEL	0x00000004
> +
  I guess there's no need for JBD2_FAIL_OK - if NOFAIL is not set, we can
fail. Otherwise the patch looks OK.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
