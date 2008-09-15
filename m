From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH] Filesystem Journal Notifications
Date: Mon, 15 Sep 2008 16:37:40 -0700
Message-ID: <20080915233740.GF3241@webber.adilger.int>
References: <20080912220649.GB26999@apaithan-desktop.sanmateo.corp.akamai.com>
 <20080915023126.GF4090@webber.adilger.int>
 <20080915053937.GG4090@webber.adilger.int>
 <20080915193648.GC31055@apaithan-desktop.sanmateo.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jamie Lokier <jamie@shareable.org>,
	Dave Chinner <david@fromorbit.com>
To: Abhijit Paithankar <apaithan@akamai.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54997 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbYIOXiQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 19:38:16 -0400
In-reply-to: <20080915193648.GC31055@apaithan-desktop.sanmateo.corp.akamai.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 15, 2008  12:36 -0700, Abhijit Paithankar wrote:
> In this version of the patch I've done away with most of the file-system
> specific changes. The file system now only needs to send out a journal
> commit notification.

Is there a reason NOT to use the journal commit callback mechanism that
I posted?  This would only require registering a single callback for
each transaction for the inotify, but has the benefit of being completely
generic and can be used for other commit notifiers in the future.

Most of the rest of my comments are related to following the Linux
coding style.  Please also generate your patch with "diff -up" so
that the context includes the function name.

> +void journal_notify_commit (journal_t *journal)
> +{

No space between the function name and the '(', journal_notify_commit(

> +	struct super_block *sb = journal->j_private;
> +	if (sb->s_priv_inode && sb->s_journal_cookie)
> +		fsnotify_journal_commit(sb);
> +}

Please add an empty line between variable declarations and the code.

> +void jbd2_journal_notify_commit (journal_t *journal)
> +{
> +	struct super_block *sb = journal->j_private;
> +	if (sb->s_priv_inode && sb->s_journal_cookie)
> +		fsnotify_journal_commit(sb);
> +}

Same comments as above.

> +		if (journal_cookie) {
> +			size_t len, rem, event_size = sizeof(struct inotify_event);

Wrap at 80 columns, likely putting "size_t event_size = ..." on a new line.

>  static void inotify_dev_queue_event(struct inotify_watch *w, u32 wd, u32 mask,
> +	if (mask & IN_JOURNAL_COMMIT) {
> +		if (!(w->inode) || !(w->inode->i_sb)
> +			|| !(w->inode->i_sb->s_priv_inode)
> +			|| !(w->inode->i_sb->s_journal_cookie))
> +			goto out;
> +	}

Operators like "||" should go at the end of the line, and the new line
should be aligned with the opening parenthesis:

		if (!(w->inode) || !(w->inode->i_sb) ||
		    !(w->inode->i_sb->s_priv_inode) ||
		    !(w->inode->i_sb->s_journal_cookie))

> +	journal_notify_commit(journal);
>  	jbd_debug(1, "JBD: commit %d complete, head %d\n",
>  		  journal->j_commit_sequence, journal->j_tail_sequence);

Note that this is also a "late" notification.  At phase 7 the transaction
is complete and committed to disk, the rest of journal_commit_transaction()
is just doing cleanup and background processing.

> +/* This is a journal commit event for file systems. These events are sent
> + * from a journaling filesystem or the journal itself.
> + *
> + * IN_JOURNAL_COMMIT is special in that only one file per journaling
> + * filesystem partition (super-block) is allowed. Registering for this
> + * event with multiple files will overwrite previous registrations.

This is a major limitation of your implementation - what if 2 applications
want to be notified of this event?  Using the journal_callback_set() API
in the patch I sent out would allow an arbitrary number of applications
to monitor the commit.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

