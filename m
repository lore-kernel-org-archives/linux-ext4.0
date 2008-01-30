From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Fw: [Bugme-new] [Bug 9849] New: NULL pointer deref in
	journal_wait_on_commit_record
Date: Wed, 30 Jan 2008 15:17:57 -0800
Message-ID: <1201735077.3873.22.camel@localhost.localdomain>
References: <20080130120055.7dc3331b.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@sgi.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Girish Shilamkar <girish@clusterfs.com>, snakebyte@gmx.de
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50127 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYA3XSI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 18:18:08 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0UNI0sn025292
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 18:18:00 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0UNI0FI249852
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 18:18:00 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0UNHx7b022293
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 18:18:00 -0500
In-Reply-To: <20080130120055.7dc3331b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-01-30 at 12:00 -0800, Andrew Morton wrote:
> 
> Begin forwarded message:
> 
> Date: Wed, 30 Jan 2008 03:24:08 -0800 (PST)
> From: bugme-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 9849] New: NULL pointer deref in journal_wait_on_commit_record
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9849
> 
>            Summary: NULL pointer deref in journal_wait_on_commit_record
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.24-03997-g85004cc
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext4
>         AssignedTo: fs_ext4@kernel-bugs.osdl.org
>         ReportedBy: snakebyte@gmx.de
> 
> 
> Latest working kernel version: -
> Earliest failing kernel version: 2.6.24-03863-g0ba6c33
> Distribution: Ubuntu
> Problem Description:
> 
> using a corrupted image causes an oops in unmount, seems as if
> journal_wait_on_commit_record() gets passed a NULL pointer
> 

The buufer head pointer passed to journal_wait_on_commit_record() could
be NULL if the previous journal_submit_commit_record() failed or journal
has already aborted.

Looking at the jbd2 debug messages, before the oops happen, the jbd2 is
aborted due to trying to access the next log block beyond the end of
device. This might be caused by using a corrupted image.

We need to check the error returns from journal_submit_commit_record()
and avoid calling journal_wait_on_commit_record() in the failure case.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
The buufer head pointer passed to journal_wait_on_commit_record()
could be NULL if the previous journal_submit_commit_record() failed
or journal has already aborted.

We need to check the error returns from journal_submit_commit_record()
and avoid calling journal_wait_on_commit_record() in the failure case.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/jbd2/commit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc8/fs/jbd2/commit.c
===================================================================
--- linux-2.6.24-rc8.orig/fs/jbd2/commit.c	2008-01-30 14:12:10.000000000 -0800
+++ linux-2.6.24-rc8/fs/jbd2/commit.c	2008-01-30 15:09:50.000000000 -0800
@@ -872,7 +872,8 @@ wait_for_iobuf:
 		if (err)
 			__jbd2_journal_abort_hard(journal);
 	}
-	err = journal_wait_on_commit_record(cbh);
+	if (!err && !is_journal_aborted(journal))
+		err = journal_wait_on_commit_record(cbh);
 
 	if (err)
 		jbd2_journal_abort(journal, err);
