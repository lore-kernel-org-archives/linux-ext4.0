From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e2fsprogs: fix data lost with mke2fs -S
Date: Mon, 27 Feb 2012 00:54:35 -0500
Message-ID: <20120227055435.GC9881@thunk.org>
References: <4EF2EA9E.9080500@rs.jp.nec.com>
 <20120217042038.GA9319@thunk.org>
 <4F434328.2000409@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52947 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2B0Fyk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 00:54:40 -0500
Content-Disposition: inline
In-Reply-To: <4F434328.2000409@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 21, 2012 at 04:09:28PM +0900, Akira Fujita wrote:
> 
> I tried to mkfs -S and e2fsck to salvage file
> with e2fsprogs 1.42.1 (commit: 5ab348723247).  
> But it seemed that the file was removed after e2fsck.

Oops, sorry.  I made a stupid mistake in my mke2fs patch.  This should
fix things so that your script works correctly.

					- Ted

commit 30ac1ce7df719e40b0c3c612696ada7c9ebbaed2
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Feb 27 00:51:39 2012 -0500

    mke2fs: make sure bg 0's unused inode count field is zero'ed for mke2fs -S
    
    There was a bug/typo in commit ba9e0afc5 which caused the first block
    group (bg #0) to not have its unused inode count field to get set to
    zero in the case of mke2fs -S.  This caused inodes in the first block
    group to not be recoverable via mke2fs -S.  Oops.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index c70c1b4..51435d2 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2442,7 +2442,7 @@ int main (int argc, char *argv[])
 		 */
 		if (fs->super->s_feature_ro_compat &
 		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
-			for (i = 1; i < fs->group_desc_count; i++)
+			for (i = 0; i < fs->group_desc_count; i++)
 				ext2fs_bg_itable_unused_set(fs, i, 0);
 		}
 	} else {
