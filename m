From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: Disallow tune2fs to set inode size larger than
 block size
Date: Sun, 21 Apr 2013 23:17:20 -0400
Message-ID: <20130422031720.GA12221@thunk.org>
References: <516FAA7E.3040604@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43347 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab3DVDRX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Apr 2013 23:17:23 -0400
Content-Disposition: inline
In-Reply-To: <516FAA7E.3040604@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 18, 2013 at 05:10:38PM +0900, Akira Fujita wrote:
> Disallow tune2fs command to set inode size larger than
> block size to ext3 and ext4 (^flex_bg).
> Without this patch, tune2fs makes FS unmountable.
> 
> Steps to reproduce:
> 
> 1.Create ext4 without flex_bg (or just create ext3)
>   # mke2fs -t ext4 -O ^flex_bg DEV
> 
> 2.Set inode size larger than block size
>   # tune2fs -I 8192 DEV
>   
> 3. We failed to mount FS
>   # mount DEV MP
>     mount: wrong fs type, bad option, bad superblock on /dev/sda7,
>            missing codepage or helper program, or other error
>            In some cases useful info is found in syslog - try
>            dmesg | tail  or so
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Thanks for reporting this.  Although at the moment we don't support
changing the inode size for flex_bg file systems, we may at some point
in the future --- and the inode size can never be larger than the
block size.  So I simplified your change by removing the ^flex_bg check.

      	     	  	     	  	- Ted

>From fab0d286ec8539988551271c5faa864ea38dc4d4 Mon Sep 17 00:00:00 2001
From: Akira Fujita <a-fujita@rs.jp.nec.com>
Date: Sun, 21 Apr 2013 23:14:28 -0400
Subject: [PATCH] tune2fs: disallow tune2fs to set inode size larger than
 block size

Disallow tune2fs command to set the inode size to be larger than the
block size.  Without this patch, tune2fs makes the file system to be
unmountable.

Steps to reproduce:

1.Create ext4 without flex_bg (or just create ext3)
  # mke2fs -t ext4 -O ^flex_bg DEV

2.Set inode size larger than block size
  # tune2fs -I 8192 DEV

3. We failed to mount FS
  # mount DEV MP
    mount: wrong fs type, bad option, bad superblock on /dev/sda7,
           missing codepage or helper program, or other error
           In some cases useful info is found in syslog - try
           dmesg | tail  or so

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/tune2fs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 849f3a0..47a7711 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1944,6 +1944,12 @@ retry_open:
 			rc = 1;
 			goto closefs;
 		}
+		if (new_inode_size > fs->blocksize) {
+			fprintf(stderr, _("Invalid inode size %lu (max %d)\n"),
+				new_inode_size, fs->blocksize);
+			rc = 1;
+			goto closefs;
+		}
 
 		/*
 		 * If inode resize is requested use the
-- 
1.7.12.rc0.22.gcdd159b

