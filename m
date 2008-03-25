From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH, RFC] jbd2: Add commit time into the commit block
Date: Tue, 25 Mar 2008 11:57:49 -0700
Message-ID: <1206471469.3617.5.camel@localhost.localdomain>
References: <1205629144-25994-1-git-send-email-tytso@mit.edu>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60526 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYCYS5y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Mar 2008 14:57:54 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2PIvrOg007893
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 14:57:53 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2PIvrDk255102
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 14:57:53 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2PIvq7m012994
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 14:57:53 -0400
In-Reply-To: <1205629144-25994-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2008-03-15 at 20:59 -0400, Theodore Ts'o wrote:
> Carlo Wood has demonstrated that it's possible to recover deleted
> files from the journal.  Something that will make this easier is if we
> can put the time of the commit into commit block.
> 
Sounds good. Added to the patch queue after fix the compile error.

Shouldn't this a JBD2 INCOMPAT feature?

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/jbd2/commit.c     |    3 +++
>  include/linux/jbd2.h |    2 ++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index e013978..7c5fbd5 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -112,6 +112,7 @@ static int journal_submit_commit_record(journal_t *journal,
>  	struct buffer_head *bh;
>  	int ret;
>  	int barrier_done = 0;
> +	struct timespec now = current_kernel_time();
> 
>  	if (is_journal_aborted(journal))
>  		return 0;
> @@ -126,6 +127,8 @@ static int journal_submit_commit_record(journal_t *journal,
>  	tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
>  	tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
>  	tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
> +	tmp->h_commit_sec = cpu_to_be32(now->tv_sec);
> +	tmp->h_commit_nsec = cpu_to_be32(now->tv_nsec);
					~~~~~~~~~~~~~~
					Should be now.ntv_sec, 

Attached is the updated patch.


Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/commit.c     |    3 +++
 include/linux/jbd2.h |    2 ++
 2 files changed, 5 insertions(+)

Index: linux-2.6.25-rc6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.25-rc6.orig/fs/jbd2/commit.c	2008-03-25 11:36:37.000000000 -0700
+++ linux-2.6.25-rc6/fs/jbd2/commit.c	2008-03-25 11:50:08.000000000 -0700
@@ -112,6 +112,7 @@ static int journal_submit_commit_record(
 	struct buffer_head *bh;
 	int ret;
 	int barrier_done = 0;
+	struct timespec now = current_kernel_time();
 
 	if (is_journal_aborted(journal))
 		return 0;
@@ -126,6 +127,8 @@ static int journal_submit_commit_record(
 	tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
 	tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
 	tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
+	tmp->h_commit_sec = cpu_to_be32(now.tv_sec);
+	tmp->h_commit_nsec = cpu_to_be32(now.tv_nsec);
 
 	if (JBD2_HAS_COMPAT_FEATURE(journal,
 				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
Index: linux-2.6.25-rc6/include/linux/jbd2.h
===================================================================
--- linux-2.6.25-rc6.orig/include/linux/jbd2.h	2008-03-16 16:32:14.000000000 -0700
+++ linux-2.6.25-rc6/include/linux/jbd2.h	2008-03-25 11:46:46.000000000 -0700
@@ -170,6 +170,8 @@ struct commit_header {
 	unsigned char   h_chksum_size;
 	unsigned char 	h_padding[2];
 	__be32 		h_chksum[JBD2_CHECKSUM_BYTES];
+	__be32		h_commit_sec;
+	__be32		h_commit_nsec;
 };
 
 /*



