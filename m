From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: release ->i_mutex and resume unlocked dio in
 swap_inode_boot_loader() (Re: mutex_unlock is missed ...)
Date: Sun, 9 Feb 2014 20:27:45 +0800
Message-ID: <20140209122745.GA12554@gmail.com>
References: <CAFZT-j+KqKfx5sEr3G9JbesUNgp60vi9Zn_tT=78S-WrVmmxKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63419 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBIMWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Feb 2014 07:22:47 -0500
Received: by mail-pb0-f45.google.com with SMTP id un15so5095434pbc.18
        for <linux-ext4@vger.kernel.org>; Sun, 09 Feb 2014 04:22:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAFZT-j+KqKfx5sEr3G9JbesUNgp60vi9Zn_tT=78S-WrVmmxKw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ahmed,

On Wed, Feb 05, 2014 at 01:39:06PM -0600, Ahmed Tamrawi wrote:
> Hi there!
> 
> Bug Report Filed: https://bugzilla.kernel.org/show_bug.cgi?id=70091
> Linux Version [3.13]
> Configuration: Default configuration for x86
> 
> 
> In function (swap_inode_boot_loader) in file (linux-3.13/fs/ext4/ioctl.c):
> 
> The structures: (inode->i_mutex) and (inode_bl->i_mutex) gets
> successfully locked at line (133) by (lock_two_nondirectories(inode,
> inode_bl), but both are not unlocked when the function returns after
> line (147), however they got unlocked only at line (208) by
> (unlock_two_nondirectories(inode, inode_bl)).
> 
> A possible solution is to call (unlock_two_nondirectories(inode,
> inode_bl)) before line (147).

Thanks for reporting this issue.  I believe the following patch that can
fix the issue.

Regards,
                                                - Zheng

Subject: [PATCH] ext4: release ->i_mutex and resume unlocked dio in swap_inode_boot_loader()

From: Zheng Liu <wenqing.lz@taobao.com>

In swap_inode_boot_loader() we forgot to release ->i_mutex and resume
unlocked dio for inode and inode_bl.  This commit fixes this issue.

Reported-by: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dr. Tilmann Bubeck <t.bubeck@reinform.de>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 6bea806..a2a837f 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -140,7 +140,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	handle = ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS, 2);
 	if (IS_ERR(handle)) {
 		err = -EINVAL;
-		goto swap_boot_out;
+		goto journal_err_out;
 	}
 
 	/* Protect extent tree against block allocations via delalloc */
@@ -198,6 +198,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
+journal_err_out:
 	ext4_inode_resume_unlocked_dio(inode);
 	ext4_inode_resume_unlocked_dio(inode_bl);
 
-- 
1.7.9.7

