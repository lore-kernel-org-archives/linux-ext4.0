From: Jan Kara <jack@suse.cz>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Fri, 24 Jun 2011 15:46:59 +0200
Message-ID: <20110624134659.GB26380@quack.suse.cz>
References: <20110301165239.3310.43806.reportbug@support.exmeritus.com>
 <15E8241A-37A0-4438-849E-A157A376C7F1@boeing.com>
 <8658F8EE-A52D-4405-A1F3-C0247AB3EA6D@boeing.com>
 <26AE8923-4DEA-43FF-8F79-1D5AA665A344@boeing.com>
 <20110405230538.GH2832@thunk.org>
 <FD93E462-D97B-411B-BF09-9A64670AC5C2@boeing.com>
 <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
 <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+HP7ph2BbKc20aGI"
Cc: Sean Ryle <seanbo@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab1FXNrD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jun 2011 09:47:03 -0400
Content-Disposition: inline
In-Reply-To: <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 23-06-11 16:19:08, Moffett, Kyle D wrote:
> On Jun 23, 2011, at 16:55, Sean Ryle wrote:
> > Maybe I am wrong here, but shouldn't the cast be to (unsigned long) or to (sector_t)?
> > 
> > Line 534 of commit.c:
> >                         jbd_debug(4, "JBD: got buffer %llu (%p)\n",
> >                                 (unsigned long long)bh->b_blocknr, bh->b_data);
> 
> No, that printk() is fine, the format string says "%llu" so the cast is
> unsigned long long.
> 
> Besides which, line 534 in the Debian 2.6.32 kernel I am using is this
> one:
> 
>   J_ASSERT(commit_transaction->t_nr_buffers <=
>            commit_transaction->t_outstanding_credits);
  Hmm, OK, so we've used more metadata buffers than we told JBD2 to
reserve. I suppose you are not using data=journal mode and the filesystem
was created as ext4 (i.e. not converted from ext3), right? Are you using
quotas?

> If somebody can tell me what information would help to debug this I'd be
> more than happy to throw a whole bunch of debug printks under that error
> condition and try to trigger the crash with that.
> 
> Alternatively I could remove that J_ASSERT() and instead add some debug
> further down around the "commit_transaction->t_outstanding_credits--;"
> to try to see exactly what IO it's handling when it runs out of credits.
  The trouble is that the problem is likely in some journal list shuffling
code because if just some operation wrongly estimated the number of needed
buffers, we'd fail the assertion in jbd2_journal_dirty_metadata():
J_ASSERT_JH(jh, handle->h_buffer_credits > 0);

The patch below might catch the problem closer to the place where it
happens...

Also possibly you can try current kernel whether the bug happens with it or
not.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--+HP7ph2BbKc20aGI
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="jbd2-credits-debug.diff"

diff -rupX /crypted/home/jack/.kerndiffexclude linux-2.6.32-SLE11-SP1/fs/jbd2/transaction.c linux-2.6.32-SLE11-SP1-1-jbd2-credits-bug//fs/jbd2/transaction.c
--- linux-2.6.32-SLE11-SP1/fs/jbd2/transaction.c	2011-06-23 23:01:55.600988795 +0200
+++ linux-2.6.32-SLE11-SP1-1-jbd2-credits-bug//fs/jbd2/transaction.c	2011-06-24 15:43:40.569213743 +0200
@@ -416,6 +416,7 @@ int jbd2_journal_restart(handle_t *handl
 	spin_lock(&journal->j_state_lock);
 	spin_lock(&transaction->t_handle_lock);
 	transaction->t_outstanding_credits -= handle->h_buffer_credits;
+	WARN_ON(transaction->t_outstanding_credits < transaction->t_nr_buffers);
 	transaction->t_updates--;
 
 	if (!transaction->t_updates)
@@ -1317,6 +1318,7 @@ int jbd2_journal_stop(handle_t *handle)
 	spin_lock(&journal->j_state_lock);
 	spin_lock(&transaction->t_handle_lock);
 	transaction->t_outstanding_credits -= handle->h_buffer_credits;
+	WARN_ON(transaction->t_outstanding_credits < transaction->t_nr_buffers);
 	transaction->t_updates--;
 	if (!transaction->t_updates) {
 		wake_up(&journal->j_wait_updates);
@@ -1924,6 +1926,7 @@ void __jbd2_journal_file_buffer(struct j
 		return;
 	case BJ_Metadata:
 		transaction->t_nr_buffers++;
+		WARN_ON(transaction->t_outstanding_credits < transaction->t_nr_buffers);
 		list = &transaction->t_buffers;
 		break;
 	case BJ_Forget:

--+HP7ph2BbKc20aGI--
