From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext3: Fix not initialized hash info in ext3_dx_find_entry()
Date: Thu, 30 Aug 2007 11:29:49 -0400
Message-ID: <20070830152949.GE10160@thunk.org>
References: <00ee01c7eb14$051e3ed0$0201a8c0@pinkpig>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Wang Chen <wangchen@cn.fujitsu.com>
To: Wang Chen <ellre923@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43146 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbXH3P3w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2007 11:29:52 -0400
Content-Disposition: inline
In-Reply-To: <00ee01c7eb14$051e3ed0$0201a8c0@pinkpig>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 30, 2007 at 10:42:33PM +0800, Wang Chen wrote:
> +               if (dentry){
> +                       ext3fs_dirhash(dentry->d_name.name, 
> dentry->d_name.len,
> +                                      &hinfo);
> +               } else {
> +                       return NULL;
> +               }

It's really not necessary to call ext3fs_dirhash(), since we don't
need the hash value for the '.' and '..' case.  So here's a better
patch....

     	      	    	    	- Ted

>From c2ff518e6f529f1d8b627f0e8be5d6f8af32747f Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 30 Aug 2007 11:26:24 -0400
Subject: [PATCH] ext3: Fix use of uninitialized variable in ext3_dx_find_entry()

In the case where we are looking up '.' and '..', those files are
always in the first directory block, so we don't need worry about the
hash value.  This avoids a lint warning message, as a minor cleanup.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext3/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 1586807..c278fc7 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -932,7 +932,7 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 {
 	struct super_block * sb;
 	struct dx_hash_info	hinfo;
-	u32 hash;
+	u32 hash = 0;
 	struct dx_frame frames[2], *frame;
 	struct ext3_dir_entry_2 *de, *top;
 	struct buffer_head *bh;
@@ -947,13 +947,13 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 	if (namelen > 2 || name[0] != '.'||(name[1] != '.' && name[1] != '\0')){
 		if (!(frame = dx_probe(dentry, NULL, &hinfo, frames, err)))
 			return NULL;
+		hash = hinfo.hash;
 	} else {
 		frame = frames;
 		frame->bh = NULL;			/* for dx_release() */
 		frame->at = (struct dx_entry *)frames;	/* hack for zero entry*/
 		dx_set_block(frame->at, 0);		/* dx_root block is 0 */
 	}
-	hash = hinfo.hash;
 	do {
 		block = dx_get_block(frame->at);
 		if (!(bh = ext3_bread (NULL,dir, block, 0, err)))
-- 
1.5.3.rc6.23.g0058
