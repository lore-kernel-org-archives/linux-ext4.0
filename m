From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal, take 2.
Date: Sun, 16 Nov 2008 18:04:45 -0600
Message-ID: <20081117000445.GA3436@webber.adilger.int>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
 <1226431111.4444.41.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63700 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYKQAFO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 19:05:14 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAH05Bcq017671
	for <linux-ext4@vger.kernel.org>; Sun, 16 Nov 2008 16:05:13 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAG00601APF0500@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 16 Nov 2008 16:05:11 -0800 (PST)
In-reply-to: <1226431111.4444.41.camel@bobble.smo.corp.google.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  11:18 -0800, Frank Mayhar wrote:
> +static inline int ext4_handle_valid(handle_t *handle)
> +{
> +	if (!handle)
> +		return 0;

My preference is to use "if (handle == NULL)", because handle is not a
boolean.

> +	if (handle->h_transaction == NULL)
> +		return 0;

Does this ever happen?  Ah, is this the case where the handle is pointing
to the ext4_sb_info()?  I think I'd prefer to have a magic value here,
so that it isn't possible to accidentally dereference a pointer that
happens to have NULL data in it.

> +static inline int ext4_handle_dirty_metadata(handle_t *handle,
> +				struct inode *inode, struct buffer_head *bh)
> +{
> +	int err = 0;
> +
> +	if (ext4_handle_valid(handle)) {
> +		err = __ext4_journal_dirty_metadata(__func__, handle, bh);
> +	} else {
> +		err = __ext4_write_dirty_metadata(inode, bh);
> +	}

You don't need to initialize "err = 0" here.

>  struct ext4_sb_info {
> +	int *s_nojournal_flag;		/* Null to indicate "not a handle" */

I don't really see where and how this is used.

> @@ -97,6 +97,8 @@
>  {

Please, in the future use "diff -up" so that it includes the function
names in the patch context.  Without the function names it is difficult
to know what is being changed by the patch.

> @@ -4657,7 +4659,7 @@
> -	if (metadata) {
> +	if (ext4_handle_valid(handle) && metadata) {

It is probably a tiny bit more efficient to check "metadata" first.

> @@ -136,13 +136,16 @@
> +	if (journal) {
> +		if (is_journal_aborted(journal)) {
> +			ext4_abort(sb, __func__,
> +				   "Detected aborted journal");
> +			return ERR_PTR(-EROFS);
> +		}
> +		return jbd2_journal_start(journal, nblocks);
>  	}
> +	current->journal_info = (handle_t *)EXT4_SB(sb);
> +	return current->journal_info;

So, this appears to be the place where ext4_sb_info->s_nojournal_flag is
actually used.  To make this more clear, it would be better to do actually
reference this variable here so that it is easier for the reader to follow.

	current->journal_info = &EXT4_SB(sb)->s_nojournal_flag;

> @@ -588,7 +599,8 @@
>  	}
>  #endif
>  	ext4_discard_preallocations(inode);
> +	if (EXT4_SB(inode->i_sb)->s_journal)

I think this is the same thing as EXT4_JOURNAL(inode)?

>  static void ext4_write_super(struct super_block *sb)
>  {
> +	if (EXT4_SB(sb)->s_journal) {
> +		if (mutex_trylock(&sb->s_lock) != 0)
> +			BUG();
> +		sb->s_dirt = 0;
> +	}
> +	else
> +		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);

This should be "} else { ... }"

> +			/*
> +			 * We don't want to clear needs_recovery flag when we failed
> +			 * to flush the journal.
> +			 */
> +			if (jbd2_journal_flush(journal) < 0)
> +				return;

This comment needs to be wrapped at 80 columns.


I like this patch a lot better than the previous one.  It remains very
readable, and isn't too intrusive to the code.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

