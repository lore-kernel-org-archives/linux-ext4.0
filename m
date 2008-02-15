From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: Fix circular locking dependency with fallocate
	and touch.
Date: Fri, 15 Feb 2008 12:52:29 -0500
Message-ID: <20080215175229.GA30741@mit.edu>
References: <1202807735-22670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55886 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757594AbYBPAIM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Feb 2008 19:08:12 -0500
Content-Disposition: inline
In-Reply-To: <1202807735-22670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2008 at 02:45:35PM +0530, Aneesh Kumar K.V wrote:
> In order to prevent a circular locking dependency when an ext4_create
> operation is racing with an ext4_fallocate, we acquire and release
> i_data_sem for each multiblock request and use i_mutex to
> prevent writes and truncates during the complete fallocate operation.
> 
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.25-rc1 #4
> -------------------------------------------------------
> touch/2347 is trying to acquire lock:
>  (&ei->i_data_sem){----}, at: [<c01cffed>] ext4_get_blocks_wrap+0x21/0xca
> 
> but task is already holding lock:
>  (jbd2_handle){--..}, at: [<c01ee43c>] jbd2_journal_start+0xce/0xf0
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> ...

I replaced the patch description with a more succint and to-the-point
changelog message:

   ext4_fallocate() was trying to acquire i_data_sem outside of
   jbd2_start_transaction/jbd2_journal_stop, which violates ext4's locking
   hierarchy.  So we take i_mutex to prevent writes and truncates during
   the complete fallocate operation, and use ext4_get_block_wrap() which
   acquires and releases i_data_sem for each block allocation.

BTW, a good thing for us to do would be to document our current
locking hierarchy: what each lock protects, and in what order locks
should be taken.  

This makes it easier for people to notice problems by reviewing code
(as opposed to trusting that lockdep will turn up problems).  It also
is a good idea so that as we start to do performance testing and start
noticing inappropriate lock hold times, we can look at our locking
hierarchy design and see if it makes sense, and how to change it to
improve performance.

Regards,

						- Ted
