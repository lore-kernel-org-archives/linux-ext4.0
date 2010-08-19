From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix oops in ext4_mb_release_group_pa tracing
Date: Thu, 19 Aug 2010 12:59:50 -0500
Message-ID: <4C6D7116.2080905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <josef@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab0HSR7x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Aug 2010 13:59:53 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7JHxqnK010647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 19 Aug 2010 13:59:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Our QA reported an oops in the ext4_mb_release_group_pa tracing,
and Josef Bacik pointed out that it was because we may have a
non-null but uninitialized ac_inode in the allocation context.

I can reproduce it when running xfstests with ext4 tracepoints on, 
on a CONFIG_SLAB_DEBUG kernel.

We call trace_ext4_mb_release_group_pa from 2 places, 
ext4_mb_discard_group_preallocations and 
ext4_mb_discard_lg_preallocations

In both cases we allocate an ac as a container just for tracing (!)
and never fill in the ac_inode.  There's no reason to be assigning,
testing, or printing it as far as I can see, so just remove it from
the tracepoint.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 01e9e00..e352c77 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -432,7 +432,6 @@ TRACE_EVENT(ext4_mb_release_group_pa,
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
-		__field(	ino_t,	ino			)
 		__field(	__u64,	pa_pstart		)
 		__field(	__u32,	pa_len			)
 
@@ -440,8 +439,6 @@ TRACE_EVENT(ext4_mb_release_group_pa,
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
-		__entry->ino		= (ac && ac->ac_inode) ?
-						ac->ac_inode->i_ino : 0;
 		__entry->pa_pstart	= pa->pa_pstart;
 		__entry->pa_len		= pa->pa_len;
 	),

