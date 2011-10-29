From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: let AGGRESSIVE_TEST brace code only related
 to itself
Date: Sat, 29 Oct 2011 09:30:13 -0400
Message-ID: <20111029133013.GG19536@thunk.org>
References: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
 <1319613112-16807-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40630 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029Ab1J2SMj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Oct 2011 14:12:39 -0400
Content-Disposition: inline
In-Reply-To: <1319613112-16807-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 26, 2011 at 03:11:51PM +0800, Yongqiang Yang wrote:
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Applied, with a minor tweak --- this *is* a place where folding two
nested if statements is a good idea (and reduces ext4's lines of code
count :-).

					- Ted

commit 2a83a909eab183807ca3ccbb2559e22611131336
Author: Yongqiang Yang <xiaoqiangnk@gmail.com>
Date:   Sat Oct 29 09:29:11 2011 -0400

    ext4: clean up AGGRESSIVE_TEST code
    
    Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 73823d5..b66cef0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -181,12 +181,10 @@ static inline int ext4_ext_space_block(struct inode *inode, int check)
 
 	size = (inode->i_sb->s_blocksize - sizeof(struct ext4_extent_header))
 			/ sizeof(struct ext4_extent);
-	if (!check) {
 #ifdef AGGRESSIVE_TEST
-		if (size > 6)
-			size = 6;
+	if (!check && size > 6)
+		size = 6;
 #endif
-	}
 	return size;
 }
 
@@ -196,12 +194,10 @@ static inline int ext4_ext_space_block_idx(struct inode *inode, int check)
 
 	size = (inode->i_sb->s_blocksize - sizeof(struct ext4_extent_header))
 			/ sizeof(struct ext4_extent_idx);
-	if (!check) {
 #ifdef AGGRESSIVE_TEST
-		if (size > 5)
-			size = 5;
+	if (!check && size > 5)
+		size = 5;
 #endif
-	}
 	return size;
 }
 
@@ -212,12 +208,10 @@ static inline int ext4_ext_space_root(struct inode *inode, int check)
 	size = sizeof(EXT4_I(inode)->i_data);
 	size -= sizeof(struct ext4_extent_header);
 	size /= sizeof(struct ext4_extent);
-	if (!check) {
 #ifdef AGGRESSIVE_TEST
-		if (size > 3)
-			size = 3;
+	if (!check && size > 3)
+		size = 3;
 #endif
-	}
 	return size;
 }
 
@@ -228,12 +222,10 @@ static inline int ext4_ext_space_root_idx(struct inode *inode, int check)
 	size = sizeof(EXT4_I(inode)->i_data);
 	size -= sizeof(struct ext4_extent_header);
 	size /= sizeof(struct ext4_extent_idx);
-	if (!check) {
 #ifdef AGGRESSIVE_TEST
-		if (size > 4)
-			size = 4;
+	if (!check && size > 4)
+		size = 4;
 #endif
-	}
 	return size;
 }
 
