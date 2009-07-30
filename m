From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] JBD2: round commit timer up to avoid uncommitted
	transaction
Date: Thu, 30 Jul 2009 12:00:35 -0600
Message-ID: <20090730180035.GC4231@webber.adilger.int>
References: <20090727202209.GU4231@webber.adilger.int>
 <20090730174710.GB9223@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Alex Zhuravlev <Alex.Zhuravlev@sun.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62389 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZG3SBO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jul 2009 14:01:14 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6UI18c2002534
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2009 11:01:08 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KNL00H00WNIIA00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 30 Jul 2009 11:01:08 -0700 (PDT)
In-reply-to: <20090730174710.GB9223@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 30, 2009  19:47 +0200, Jan Kara wrote:
> > jbd and jbd2 fixes: fix jiffie rounding in jbd commit timer setup code.
> > Rounding down could cause the timer to be fired before the corresponding
> > transaction has expired.  That transaction can stay not committed forever if
> > no new transaction is created or expicit sync/umount happens.
> > 
> > Signed-off-by: Alex Zhuravlev (Tomas) <alex.zhuravlev@sun.com>
> > Signed-off-by: Andreas Dilger <adilger@sun.com>
>
>   Looks fine. You can add:
> Acked-by: Jan Kara <jack@suse.cz>
>   How about a similar JBD fix?

Index: linux-2.6.27.21-0.1/fs/jbd/transaction.c
===================================================================
--- linux-2.6.27.21-0.1.orig/fs/jbd/transaction.c	2009-06-10 11:11:41.000000000 -0600
+++ linux-2.6.27.21-0.1/fs/jbd/transaction.c	2009-06-10 11:12:32.000000000 -0600
@@ -54,7 +54,7 @@
 	spin_lock_init(&transaction->t_inode_list);
 
 	/* Set up the commit timer for the new transaction. */
-	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
+	journal->j_commit_timer.expires = round_jiffies_up(transaction->t_expires);
 	add_timer(&journal->j_commit_timer);
 
 	J_ASSERT(journal->j_running_transaction == NULL);

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

