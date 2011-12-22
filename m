From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Don't warn from writepage when readonly inode is
 spotted after error
Date: Thu, 22 Dec 2011 17:18:52 +0100
Message-ID: <20111222161852.GB5639@quack.suse.cz>
References: <1324569415-9824-1-git-send-email-jack@suse.cz>
 <4EF356B8.5010605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab1LVQTO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Dec 2011 11:19:14 -0500
Content-Disposition: inline
In-Reply-To: <4EF356B8.5010605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 22-12-11 10:11:36, Eric Sandeen wrote:
> On 12/22/11 9:56 AM, Jan Kara wrote:
> > WARN_ON_ONCE(IS_RDONLY(inode)) tends to trip when filesystem hits error and is
> > remounted read-only. This unnecessarily scares users (well, they should be
> > scared because of filesystem error, but the stack trace distracts them from the
> > right source of their fear ;-). We could as well just remove the WARN_ON but
> > it's not hard to fix it to not trip on filesystem with errors and not use more
> > cycles in the common case so that's what we do.
> 
> I've seen that too and it is distracting.
> 
> Looks good to me, aside from the rather long lines ;)
  Ah, right. My internal style checker had a coffee break I assume ;).
Below is a version with long lines fixed.

									Honza

>From 0588350bf10c8dad70cc299971dfdeec10754b29 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 22 Dec 2011 16:49:05 +0100
Subject: [PATCH] ext3: Don't warn from writepage when readonly inode is spotted after error

WARN_ON_ONCE(IS_RDONLY(inode)) tends to trip when filesystem hits error and is
remounted read-only. This unnecessarily scares users (well, they should be
scared because of filesystem error, but the stack trace distracts them from the
right source of their fear ;-). We could as well just remove the WARN_ON but
it's not hard to fix it to not trip on filesystem with errors and not use more
cycles in the common case so that's what we do.

CC: stable@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index a8d3217..fbf6599 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1623,7 +1623,13 @@ static int ext3_ordered_writepage(struct page *page,
 	int err;
 
 	J_ASSERT(PageLocked(page));
-	WARN_ON_ONCE(IS_RDONLY(inode));
+	/*
+	 * We don't want to warn for emergency remount. The condition is
+	 * ordered to avoid dereferencing inode->i_sb in non-error case to
+	 * avoid slow-downs.
+	 */
+	WARN_ON_ONCE(IS_RDONLY(inode) &&
+		     !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
 	/*
 	 * We give up here if we're reentered, because it might be for a
@@ -1698,7 +1704,13 @@ static int ext3_writeback_writepage(struct page *page,
 	int err;
 
 	J_ASSERT(PageLocked(page));
-	WARN_ON_ONCE(IS_RDONLY(inode));
+	/*
+	 * We don't want to warn for emergency remount. The condition is
+	 * ordered to avoid dereferencing inode->i_sb in non-error case to
+	 * avoid slow-downs.
+	 */
+	WARN_ON_ONCE(IS_RDONLY(inode) &&
+		     !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
 	if (ext3_journal_current_handle())
 		goto out_fail;
@@ -1741,7 +1753,13 @@ static int ext3_journalled_writepage(struct page *page,
 	int err;
 
 	J_ASSERT(PageLocked(page));
-	WARN_ON_ONCE(IS_RDONLY(inode));
+	/*
+	 * We don't want to warn for emergency remount. The condition is
+	 * ordered to avoid dereferencing inode->i_sb in non-error case to
+	 * avoid slow-downs.
+	 */
+	WARN_ON_ONCE(IS_RDONLY(inode) &&
+		     !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
 	if (ext3_journal_current_handle())
 		goto no_write;
-- 
1.7.1

