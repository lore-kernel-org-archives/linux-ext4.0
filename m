From: Andreas Dilger <adilger@sun.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 15:28:40 -0600
Message-ID: <20090824212840.GN5931@webber.adilger.int>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com>
 <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int>
 <20090824201027.GC17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41152 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZHXV2f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Aug 2009 17:28:35 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7OLSaAT008755
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2009 14:28:36 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KOW00500GU2M500@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 24 Aug 2009 14:28:36 -0700 (PDT)
In-reply-to: <20090824201027.GC17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 24, 2009  16:10 -0400, Theodore Ts'o wrote:
> However, even if we add even if we add per-block checksums, there is
> still the problem that there is logic in the jbd layer where we avoid
> reusing certain blocks until we are sure the transaction has
> committed.  With asynchronous commits, there is no way of knowing when
> it is safe to reuse those blocks.  

AFAIK, "async commits" are not wholly async.  There is still a wait
for the transaction commit block to hit the disk before calling the
transaction committed.  The main improvement with "async commits" is
that JBD only waits ONCE for both the transaction data blocks and the
commit block (which are submitted at the same time).  In particular
note that there is an unconditional wait on the commit block for
every transaction commit.

JBD currently submits the transaction data and waits once for them
to complete, and then submits the commit block and waits a second time
for it to complete, which is 2x latency for every transaction.


> Looking at the code, the best we can do in the short-term is to write
> the commit record where we do, but do so with a barrier requested, and
> then wait for the commit block where we do.  This will provide some
> performance improvement, since we won't wait for all of the journal
> blocks to be sent to disk before writing the commit record.

The big problem with Linux "barriers" is that they are actually cache
flushes, so are worse than just having the original code that waits
for completion of the actual journal blocks, because the "barrier"
will force all kids of unrelated blocks to disk as well.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

