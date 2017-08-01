From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck on encrypted directories
Date: Tue, 1 Aug 2017 10:33:43 -0400
Message-ID: <20170801143343.7kphdxfvw7qzth3z@thunk.org>
References: <23b72f10-bbe6-1e7d-89b6-7b8bebab8d13@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sahitya Tummala <stummala@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53758 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbdHAOdq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 1 Aug 2017 10:33:46 -0400
Content-Disposition: inline
In-Reply-To: <23b72f10-bbe6-1e7d-89b6-7b8bebab8d13@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 28, 2017 at 03:32:24PM +0530, Sahitya Tummala wrote:
> Hi Ted,
> 
> I got a question on usage of e2fsck with -D option on EXT4 FS, where
> file based encryption is enabled. Is this option supposed to work on
> encrypted directories?
> 
> I have encountered a case where e2fsck gets stuck
> in duplicate_search_and_fix() due to strncmp checks done in this function
> on encrypted file names, which may contain NUL characters.
> 
> Also, even without -D option passed, there can be a case of duplicate
> entries (i.e.,
> ctx->dirs_to_hash is not NULL). In this case too we may see the same issue
> in duplicate_search_and_fix() if the directory is encrypted.
> Is my understanding correct? Please share your comments.

Thanks, your understanding is indeed correct.  Thanks for pointing
this out.  The following patch should fix the problem; can you
confirm, if you have a convenient test case?

					- Ted

>From 5b8d7c51e51aef7879150b07f3967da4028862f3 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 1 Aug 2017 10:26:11 -0400
Subject: [PATCH] e2fsck: fix e2fsck -D for encrypted directories

If the directory entry is encrypted there may be embedded NUL
characters; hence, we should use memcmp instead of strncmp when
comparing strings.  Otherwise, e2fsck can erroneously report that a
directory have duplicant entries when doing an e2fsck -D check.

Reported-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/rehash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 22a58f333..77129e50d 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -219,7 +219,7 @@ static EXT2_QSORT_TYPE name_cmp(const void *a, const void *b)
 	if (min_len > he_b_len)
 		min_len = he_b_len;
 
-	ret = strncmp(he_a->dir->name, he_b->dir->name, min_len);
+	ret = memcmp(he_a->dir->name, he_b->dir->name, min_len);
 	if (ret == 0) {
 		if (he_a_len > he_b_len)
 			ret = 1;
@@ -386,7 +386,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 		if (!ent->dir->inode ||
 		    (ext2fs_dirent_name_len(ent->dir) !=
 		     ext2fs_dirent_name_len(prev->dir)) ||
-		    strncmp(ent->dir->name, prev->dir->name,
+		    memcmp(ent->dir->name, prev->dir->name,
 			     ext2fs_dirent_name_len(ent->dir)))
 			continue;
 		pctx.dirent = ent->dir;
@@ -404,7 +404,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 			if ((i==j) ||
 			    (new_len !=
 			     (unsigned) ext2fs_dirent_name_len(fd->harray[j].dir)) ||
-			    strncmp(new_name, fd->harray[j].dir->name, new_len))
+			    memcmp(new_name, fd->harray[j].dir->name, new_len))
 				continue;
 			mutate_name(new_name, &new_len);
 
-- 
2.11.0.rc0.7.gbe5a750
