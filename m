From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Fw: [Bugme-new] [Bug 9849] New: NULL pointer deref in
	journal_wait_on_commit_record
Date: Mon, 4 Feb 2008 15:17:58 +0530
Message-ID: <20080204094758.GF7494@skywalker>
References: <20080130120055.7dc3331b.akpm@linux-foundation.org> <1201735077.3873.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Girish Shilamkar <girish@clusterfs.com>
To: Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:49217 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYBDJsI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 04:48:08 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m149lZS6014757
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 20:47:35 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m149m6Zl3805396
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 20:48:06 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m149m6jK030224
	for <linux-ext4@vger.kernel.org>; Mon, 4 Feb 2008 20:48:06 +1100
Content-Disposition: inline
In-Reply-To: <1201735077.3873.22.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 30, 2008 at 03:17:57PM -0800, Mingming Cao wrote:
> 
> The buufer head pointer passed to journal_wait_on_commit_record() could
> be NULL if the previous journal_submit_commit_record() failed or journal
> has already aborted.
> 
> Looking at the jbd2 debug messages, before the oops happen, the jbd2 is
> aborted due to trying to access the next log block beyond the end of
> device. This might be caused by using a corrupted image.
> 
> We need to check the error returns from journal_submit_commit_record()
> and avoid calling journal_wait_on_commit_record() in the failure case.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> The buufer head pointer passed to journal_wait_on_commit_record()
> could be NULL if the previous journal_submit_commit_record() failed
> or journal has already aborted.
> 
> We need to check the error returns from journal_submit_commit_record()
> and avoid calling journal_wait_on_commit_record() in the failure case.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/jbd2/commit.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.24-rc8/fs/jbd2/commit.c
> ===================================================================
> --- linux-2.6.24-rc8.orig/fs/jbd2/commit.c	2008-01-30 14:12:10.000000000 -0800
> +++ linux-2.6.24-rc8/fs/jbd2/commit.c	2008-01-30 15:09:50.000000000 -0800
> @@ -872,7 +872,8 @@ wait_for_iobuf:
>  		if (err)
>  			__jbd2_journal_abort_hard(journal);
>  	}
> -	err = journal_wait_on_commit_record(cbh);
> +	if (!err && !is_journal_aborted(journal))
> +		err = journal_wait_on_commit_record(cbh);
> 
>  	if (err)
>  		jbd2_journal_abort(journal, err);
> 
> 

Needs the below small change also. I don't see this patch in the patch
queue. So i guess we can add the below diff to the same. The change was
suggested by Girish. Before journal checksum changes sync_dirty_buffer
did the get_bh.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index da8d0eb..2b88ab0 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -136,7 +136,7 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
 	lock_buffer(bh);
-
+	get_bh(bh);
 	set_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
 	bh->b_end_io = journal_end_buffer_io_sync;
