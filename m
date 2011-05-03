From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Strange behavior when attempting to convert a file to extents
 using chattr
Date: Tue, 3 May 2011 09:35:08 -0400
Message-ID: <20110503133508.GA6462@thunk.org>
References: <BANLkTikHomLCTM307W0ergoOX8PH5x_JBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peter Uchno <peter.uchno@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36008 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1ECNfM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 09:35:12 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikHomLCTM307W0ergoOX8PH5x_JBA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 28, 2011 at 04:14:59PM -0400, Peter Uchno wrote:
> I recently converted an ext3 filesystem to ext4 in the hopes of
> performance increases. However, I ran into a snag:
> 
> In theory, chattr can be used to convert a file to extents using
> "chattr +e foo". However, on my system (Archlinux, kernel 2.6.37.4),
> the behavior of this command is unexpected. Given a file baz created
> when the filesystem was still ext3 (and thus not using extents),
> "chattr +e baz" returns zero but "lsattr baz" reveals the file is not
> using extents. 

I found the problem; we were failing to set the extents flag at the
conclusion of the migration run.  The following patch should fix
things.  Thanks for reporting the problem, and my apologies for not
catching this further.  (/me makes a mental note to create an xfstests
test for this case.)

						- Ted

>From 74e4e6db38918620bdf8a46e94982ead2b228d43 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 3 May 2011 09:34:42 -0400
Subject: [PATCH] ext4: set extents flag when migrating file to use extents

Fix a typo that was introduced in commit 07a038245b (in 2.6.36) which
caused the extents flag not to be set at the conclusion of converting
an inode to use extents.

Reported-by: Peter Uchno <peter.uchno@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 92816b4..b57b98f 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -376,7 +376,7 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	 * We have the extent map build with the tmp inode.
 	 * Now copy the i_data across
 	 */
-	ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS);
+	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
 	memcpy(ei->i_data, tmp_ei->i_data, sizeof(ei->i_data));
 
 	/*
-- 
1.7.3.1

