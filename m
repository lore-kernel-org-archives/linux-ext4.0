From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 2/2] ext4: ext4_discard_partial_page_buffers_no_lock() wrong parameters
Date: Mon, 12 Dec 2011 03:27:08 +0100
Message-ID: <1323656828-24465-3-git-send-email-aarcange@redhat.com>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
Cc: Theodore Tso <tytso@MIT.EDU>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab1LLC1w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Dec 2011 21:27:52 -0500
In-Reply-To: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If "copied" is zero (it can happen if the pte is unmapped before the
atomic copy_user that does the data copy runs) the "from" passed to
ext4_discard_partial_page_buffers_no_lock() points to pos-1, which
would correspond to a logical page index before the page->index
leading to ext4_discard_partial_page_buffers_no_lock() returning
-EINVAL (because index != page->index). In such a case write() returns
-EINVAL and userland gets a failure and filemap.c doesn't retry the
copy_user anymore.

I'm not certain of why exactly
ext4_discard_partial_page_buffers_no_lock() is run here, so it's hard
to tell if this is the correct fix. But it that functions clears data
starting from the "from" parameter, so regardless of the -EINVAL
retval, the right "from" to start clearing data should be pos+copied,
not pos+copied-1. If this assumption is correct, it could mean that
this bug in addition to the -EINVAL error, could also zero out 1 byte
by mistake. I'm not sure what the implications for that are (not sure
if data corruption is possible in some circumstances because of
that). I guess normally this functions runs on unmapped buffers and
the EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED makes it a noop on those.

After fixing the hang in ext4_da_should_update_i_disksize, this write
-EINVAL error becomes trivially reproducible with experimental knumad
autonuma code running at heavy frequency (not the normal case). But
like for the ext4_da_should_update_i_disksize hang, it should not be
impossible to reproduce it with legacy swapping behavior.

After dropping all caches a md5sum is successful and I can't find
errors anymore with this patch, the -EINVAL stops, but it's not
conclusive (and I haven't run e2fsck -f yet but I doubt this affects
metadata coherency, seems more like a delayalloc data issue).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 fs/ext4/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 63f9541..528c4c5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2534,11 +2534,11 @@ static int ext4_da_write_end(struct file *file,
 							page, fsdata);
 
 	page_len = PAGE_CACHE_SIZE -
-			((pos + copied - 1) & (PAGE_CACHE_SIZE - 1));
+			((pos + copied) & (PAGE_CACHE_SIZE - 1));
 
-	if (page_len > 0) {
+	if (page_len < PAGE_CACHE_SIZE) {
 		ret = ext4_discard_partial_page_buffers_no_lock(handle,
-			inode, page, pos + copied - 1, page_len,
+			inode, page, pos + copied, page_len,
 			EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED);
 	}
 
