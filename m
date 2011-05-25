From: Ted Ts'o <tytso@mit.edu>
Subject: [mkatiyar@gmail.com: [PATCH 2/3] jbd2 : Fix journal start by
 passing a parameter to specify if the caller can deal with ENOMEM]
Date: Wed, 25 May 2011 09:52:10 -0400
Message-ID: <20110525135210.GD8476@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Cc: mkatiyar@gmail.com, linux-ext4@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59226 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab1EYNwP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 09:52:15 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Manish,

For changes that affect non-ext4 code (in this case, ocfs2), in the
future, please cc the maintainers of said code, so they have a heads
up about the proposed change.  You can look that information up in the
MAINTAINERS file in the top level of the Linux source tree.  (In this
case, it's Mark and Joel.)

Thanks, regards,

						- Ted

--EeQfGwPcQSOJBaQU
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <mkatiyar@gmail.com>
Received: from po14.mit.edu ([unix socket])
	by po14.mit.edu (Cyrus v2.1.5) with LMTP; Wed, 25 May 2011 03:26:20 -0400
X-Sieve: CMU Sieve 2.2
Received: from mit-mailsec-scanner-2.mit.edu by po14.mit.edu (8.13.6/4.7) id p4P7QKLI023569; Wed, 25 May 2011 03:26:20 -0400 (EDT)
Received: from mailhub-dmz-4.mit.edu ( [18.7.62.38])
	by mit-mailsec-scanner-2.mit.edu (Symantec Messaging Gateway) with SMTP id 31.AC.02541.1EFACDD4; Wed, 25 May 2011 03:29:38 -0400 (EDT)
Received: from dmz-mailsec-scanner-1.mit.edu (DMZ-MAILSEC-SCANNER-1.MIT.EDU [18.9.25.12])
	by mailhub-dmz-4.mit.edu (8.13.8/8.9.2) with ESMTP id p4P7QBle019740
	for <tytso@mit.edu>; Wed, 25 May 2011 03:26:19 -0400
X-AuditID: 12074f0d-b7b62ae0000009ed-4c-4ddcafe1221b
Authentication-Results: symauth.service.identifier
Received: from mail-pw0-f49.google.com (mail-pw0-f49.google.com [209.85.160.49])
	by dmz-mailsec-scanner-1.mit.edu (Symantec Messaging Gateway) with SMTP id 18.3B.04476.22FACDD4; Wed, 25 May 2011 03:26:27 -0400 (EDT)
Received: by pwi8 with SMTP id 8so3844355pwi.36
        for <tytso@mit.edu>; Wed, 25 May 2011 00:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:message-id:date:from:user-agent:mime-version:to
         :cc:subject:content-type:content-transfer-encoding;
        bh=c9/O5+hJALsYriMRArFkjDzI0ik+N9h4AqlxX7D5Aws=;
        b=ZlSTN2DSg2HS+RZArDV/5GNgoXoV6Vb9VEh8jDXFEM0Hxq18a4fBBmSJAxMg/jKvCW
         3y6eskLbp0ChbXkt+07m3Q13zHWchS6L4qjxZz++iidmQKnBn58wNT891CBQOCPiIMZw
         zeL/i6Rf7onzMnfkuUeCSGRaFuvrJQH1Y8p0A=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gPKnTAb1MVI5kJLc8xyr4gsYiEipQw1UWpwqKMroIhjfjsGzhN9Uxa+x5RJVfzH619
         ACRw2CuFfbrgTqZslW8ZbhPa+2123vt7TeW7ZUwKTCUoflFSyEL/uPkySm9V7Fv0cJE6
         C3/WHkwDKm13YWtwfOIt+Fgm0A27LdhtPgENY=
Received: by 10.143.66.17 with SMTP id t17mr148857wfk.334.1306308378639;
        Wed, 25 May 2011 00:26:18 -0700 (PDT)
Received: from [10.58.54.96] (nat-198-95-226-230.netapp.com [198.95.226.230])
        by mx.google.com with ESMTPS id w14sm7433273wfh.20.2011.05.25.00.26.17
        (version=SSLv3 cipher=OTHER);
        Wed, 25 May 2011 00:26:18 -0700 (PDT)
Message-ID: <4DDCAF18.8030809@gmail.com>
Date: Wed, 25 May 2011 00:26:16 -0700
From: Manish Katiyar <mkatiyar@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: tytso@mit.edu, jack@suse.cz
CC: linux-ext4@vger.kernel.org
Subject: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to specify
 if the caller can deal with ENOMEM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRWlGSWpSXmKPExsUixG6npvto/R1fg32dbBatPT/ZHRg9ms4c
	ZQ5gjOKySUnNySxLLdK3S+DKuPDSpOCUYcWSY2sZGxgXaXYxcnJICJhIzG7axwhhi0lcuLee
	rYuRi0NIYC+jxKEDxxkhnOuMEhd/32KC6WievY8FxGYUMJLYfe4VK0TRTUaJtdf6wBJCAsUS
	/b3zwbpZBF4yS9zd/5INwulnllh57h4zRFW5xJTt06B2fGaU+DW3jxUkwSugITHl9BuwfSwC
	qhLPp7wHG8smoClx6PRvoAYODlGBIokVXwwhygUlTs58AlYiIiAvsXTvPHYQm1lATuLy2gdg
	u4QFSiR+9axhgYjrSLzrg4gzA9VvfzuHGeQGCYG5HBK3TzximsAoPgvJ3FlIemYh6VnAyLyK
	UTY3s0Q3NzEzpzg1Wbc4OTEvL7VI10gPKKqXmlK6iREcQ/68OxiPN8gdYhTgYFTi4V1x+bav
	EGtiWXFl7iFGSQ4mJVFeibV3fIX4kvJTKjMSizPii0pzUosPMUpwMCuJ8DZIAOV4UxIrq1KL
	8mFSMhwcShK8nuuAUoJFqempFWmZOcBEAZNm4uAEaecBaq8BqeEtLkjMLc5Mh8ifYrTkOPjw
	xwFGjn9zfwPJqZ+ApBBLXn5eqpQ470SQBgGQhozSPLiZoLRW/////0uMslLCvIwMDAxCPAWp
	RUCPIuQvhi4wfMQoyPGSXYiNiyk1T0BRCmzoK0ZxoMeFeatBJvNk5pXAXfIK6EgmoCMl/t4E
	ObIkESEl1cAozXhooX6upu7Dhy1LbzlMZ4stuPXy1Z171SfWxG3cv4TT+enVBSmRV867z3u/
	MOv17vatwfOWfMnV/fV5qXv82aW1E71tZ53U9+2qSNT6re7133K23QVJJmOVHRezvSbw5F7v
	D2RZc1f37S3uF87/lu2tX/t6Q22F2S6JNh3OInVX6YNbBdWylFiKMxINtZiLihMB2gQZLXoD
	AAA=

Pass extra bool parameter in journal routines to specify if its ok to
fail in the journal start. Passing true means caller is
ok with journal start failures and can handle ENOMEM. Update ocfs2 and ext4
routines to pass false for the updated journal interface by default to
retain the existing behavior.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.h   |    2 +-
 fs/ext4/super.c       |    2 +-
 fs/jbd2/transaction.c |   26 +++++++-------------------
 fs/ocfs2/journal.c    |    6 +++---
 include/linux/jbd2.h  |    6 ++----
 5 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index d0f5353..0abee1b 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -225,7 +225,7 @@ static inline int ext4_journal_extend(handle_t *handle, int nblocks)
 static inline int ext4_journal_restart(handle_t *handle, int nblocks)
 {
 	if (ext4_handle_valid(handle))
-		return jbd2_journal_restart(handle, nblocks);
+		return jbd2_journal_restart(handle, nblocks, false);
 	return 0;
 }

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8553dfb..4e4c17f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -279,7 +279,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 		ext4_abort(sb, "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
-	return jbd2_journal_start(journal, nblocks);
+	return jbd2_journal_start(journal, nblocks, false);
 }

 /*
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..248a7b6 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -308,6 +308,8 @@ static handle_t *new_handle(int nblocks)
  * handle_t *jbd2_journal_start() - Obtain a new handle.
  * @journal: Journal to start transaction on.
  * @nblocks: number of block buffer we might modify
+ * @errok:  True if the callers can handle ENOMEM failures from
+ *	    this routine, false otherwise
  *
  * We make sure that the transaction can guarantee at least nblocks of
  * modified buffers in the log.  We block until the log can guarantee
@@ -318,7 +320,7 @@ static handle_t *new_handle(int nblocks)
  *
  * Return a pointer to a newly allocated handle, or NULL on failure
  */
-handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
+handle_t *jbd2_journal_start(journal_t *journal, int nblocks, bool errok)
 {
 	handle_t *handle = journal_current_handle();
 	int err;
@@ -338,7 +340,7 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)

 	current->journal_info = handle;

-	err = start_this_handle(journal, handle, gfp_mask);
+	err = start_this_handle(journal, handle, GFP_NOFS);
 	if (err < 0) {
 		jbd2_free_handle(handle);
 		current->journal_info = NULL;
@@ -346,13 +348,6 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
 	}
 	return handle;
 }
-EXPORT_SYMBOL(jbd2__journal_start);
-
-
-handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
-{
-	return jbd2__journal_start(journal, nblocks, GFP_NOFS);
-}
 EXPORT_SYMBOL(jbd2_journal_start);


@@ -441,7 +436,7 @@ out:
  * transaction capabable of guaranteeing the requested number of
  * credits.
  */
-int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)
+int jbd2_journal_restart(handle_t *handle, int nblocks, bool errok)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
@@ -477,16 +472,9 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)

 	lock_map_release(&handle->h_lockdep_map);
 	handle->h_buffer_credits = nblocks;
-	ret = start_this_handle(journal, handle, gfp_mask);
+	ret = start_this_handle(journal, handle, GFP_NOFS);
 	return ret;
 }
-EXPORT_SYMBOL(jbd2__journal_restart);
-
-
-int jbd2_journal_restart(handle_t *handle, int nblocks)
-{
-	return jbd2__journal_restart(handle, nblocks, GFP_NOFS);
-}
 EXPORT_SYMBOL(jbd2_journal_restart);

 /**
@@ -1436,7 +1424,7 @@ int jbd2_journal_force_commit(journal_t *journal)
 	handle_t *handle;
 	int ret;

-	handle = jbd2_journal_start(journal, 1);
+	handle = jbd2_journal_start(journal, 1, false);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 	} else {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 295d564..bff51c0 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -353,11 +353,11 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)

 	/* Nested transaction? Just return the handle... */
 	if (journal_current_handle())
-		return jbd2_journal_start(journal, max_buffs);
+		return jbd2_journal_start(journal, max_buffs, false);

 	down_read(&osb->journal->j_trans_barrier);

-	handle = jbd2_journal_start(journal, max_buffs);
+	handle = jbd2_journal_start(journal, max_buffs, false);
 	if (IS_ERR(handle)) {
 		up_read(&osb->journal->j_trans_barrier);

@@ -438,7 +438,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 	if (status > 0) {
 		trace_ocfs2_extend_trans_restart(old_nblocks + nblocks);
 		status = jbd2_journal_restart(handle,
-					      old_nblocks + nblocks);
+					      old_nblocks + nblocks, false);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a32dcae..67f0f4f 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1103,10 +1103,8 @@ static inline handle_t *journal_current_handle(void)
  * Register buffer modifications against the current transaction.
  */

-extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
-extern handle_t *jbd2__journal_start(journal_t *, int nblocks, int gfp_mask);
-extern int	 jbd2_journal_restart(handle_t *, int nblocks);
-extern int	 jbd2__journal_restart(handle_t *, int nblocks, int gfp_mask);
+extern handle_t *jbd2_journal_start(journal_t *, int nblocks, bool errok);
+extern int	 jbd2_journal_restart(handle_t *, int nblocks, bool errok);
 extern int	 jbd2_journal_extend (handle_t *, int nblocks);
 extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_create_access (handle_t *, struct buffer_head *);
-- 
1.7.4.1

-- 
Thanks -
Manish

--EeQfGwPcQSOJBaQU--
