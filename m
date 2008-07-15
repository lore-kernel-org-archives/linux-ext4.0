From: Andreas Dilger <adilger@sun.com>
Subject: Re: transaction batching performance & multi-threaded synchronous
	writers
Date: Tue, 15 Jul 2008 01:58:32 -0600
Message-ID: <20080715075832.GD6239@webber.adilger.int>
References: <487B7B9B.3020001@gmail.com>
 <20080714165858.GA10268@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ric Wheeler <ricwheeler@gmail.com>, linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46034 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYGOH6g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 03:58:36 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6F7wYKB027365
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 00:58:35 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4100B01FCMZA00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 15 Jul 2008 00:58:34 -0700 (PDT)
In-reply-to: <20080714165858.GA10268@unused.rdu.redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 14, 2008  12:58 -0400, Josef Bacik wrote:
> Perhaps we track the average time a commit takes to occur, and then if
> the current transaction start time is < than the avg commit time we sleep
> and wait for more things to join the transaction, and then we commit.
> How does that idea sound?  Thanks,

The drawback of this approach is that if the thread waits an extra "average
transaction time" for the transaction to commit then this will increase the
average transaction time each time, and it still won't tell you if there
needs to be a wait at all.

What might be more interesting is tracking how many processes had sync
handles on the previous transaction(s), and once that number of processes
have done that work, or the timeout reached, the transaction is committed.

While this might seem like a hack for the particular benchmark, this
will also optimize real-world workloads like mailserver, NFS/fileserver,
http where the number of threads running at one time is generally fixed.

The best way to do that would be to keep a field in the task struct to
track whether a given thread has participated in transaction "T" when
it starts a new handle, and if not then increment the "number of sync
threads on this transaction" counter.

In journal_stop() if t_num_sync_thr >= prev num_sync_thr then
the transaction can be committed earlier, and if not then it does a
wait_event_interruptible_timeout(cur_num_sync_thr >= prev_num_sync_thr, 1).

While the number of sync threads is growing or constant the commits will 
be rapid, and any "slow" threads will block on the next transaction and
increment its num_sync_thr until the thread count stabilizes (i.e. a small
number of transactions at startup).  After that the wait will be exactly
as long as needed for each thread to participate.  If some threads are
too slow, or stop processing then there will be a single sleep and the
next transaction will wait for fewer threads the next time.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

