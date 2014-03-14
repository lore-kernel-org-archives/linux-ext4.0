From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 10/30] libext2fs: define new dirent_swab interfaces
 for inline data
Date: Thu, 13 Mar 2014 22:44:13 -0400
Message-ID: <20140314024413.GB8282@thunk.org>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
 <1386323897-2354-11-git-send-email-wenqing.lz@taobao.com>
 <20140303154950.GB9620@thunk.org>
 <392DED5B-9D1A-4989-A891-D844705DCA2D@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41179 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbaCNCog (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2014 22:44:36 -0400
Content-Disposition: inline
In-Reply-To: <392DED5B-9D1A-4989-A891-D844705DCA2D@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2014 at 12:32:34PM -0400, jon ernst wrote:
> errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags)
> {
> +       return ext2fs_dirent_swab_in(fs, buf, fs->blocksize, flags);
> +}
> 
> I guess it misses "2" for function name.
> Should be:
> 
> errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags)
> {
> +       return ext2fs_dirent_swab_in2(fs, buf, fs->blocksize, flags);
> +}

Nice catch, thanks!!

					- Ted

>From f9574ad0ba655b436b3940ff1604df4d11a43115 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 13 Mar 2014 13:40:37 -0400
Subject: [PATCH] libext2fs: fix build failure on big endian systems

Fix a typo that we didn't notice because all the world's an x86.  :-)

Reported-by: jon ernst <jonernst07@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/swapfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index e3628b3..f08859b 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -363,7 +363,7 @@ void ext2fs_swap_mmp(struct mmp_struct *mmp)
 
 errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags)
 {
-	return ext2fs_dirent_swab_in(fs, buf, fs->blocksize, flags);
+	return ext2fs_dirent_swab_in2(fs, buf, fs->blocksize, flags);
 }
 
 errcode_t ext2fs_dirent_swab_in2(ext2_filsys fs, char *buf,
-- 
1.9.0

