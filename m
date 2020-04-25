Return-Path: <SRS0=2QqD=6J=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BD6C55186
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Apr 2020 11:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30CA2206A2
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Apr 2020 11:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgDYLwH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 25 Apr 2020 07:52:07 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:47882 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDYLwH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 25 Apr 2020 07:52:07 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id DA4A818014A21;
        Sat, 25 Apr 2020 11:43:35 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 0343D62C4;
        Sat, 25 Apr 2020 11:43:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: quiet09_1d6cd28fe21e
X-Filterd-Recvd-Size: 4666
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Apr 2020 11:43:32 +0000 (UTC)
Message-ID: <326458310dc7c982d2f2210e057f69d6bc0169c7.camel@perches.com>
Subject: Re: [PATCH 4.4 091/100] ext2: fix empty body warnings when -Wextra
 is used
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Date:   Sat, 25 Apr 2020 04:43:31 -0700
In-Reply-To: <20200422095039.371486451@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
         <20200422095039.371486451@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, 2020-04-22 at 11:57 +0200, Greg Kroah-Hartman wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> [ Upstream commit 44a52022e7f15cbaab957df1c14f7a4f527ef7cf ]
> 
> When EXT2_ATTR_DEBUG is not defined, modify the 2 debug macros
> to use the no_printk() macro instead of <nothing>.
> This fixes gcc warnings when -Wextra is used:
> 
> ../fs/ext2/xattr.c:252:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> ../fs/ext2/xattr.c:258:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> ../fs/ext2/xattr.c:330:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> ../fs/ext2/xattr.c:872:45: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
> 
> I have verified that the only object code change (with gcc 7.5.0) is
> the reversal of some instructions from 'cmp a,b' to 'cmp b,a'.

It'd be better to use the ext4 style defines:

fs/ext4/xattr.c:# define ea_idebug(inode, fmt, ...)                                     \
fs/ext4/xattr.c-        printk(KERN_DEBUG "inode %s:%lu: " fmt "\n",                    \
fs/ext4/xattr.c-               inode->i_sb->s_id, inode->i_ino, ##__VA_ARGS__)
fs/ext4/xattr.c:# define ea_bdebug(bh, fmt, ...)                                        \
fs/ext4/xattr.c-        printk(KERN_DEBUG "block %pg:%lu: " fmt "\n",                   \
fs/ext4/xattr.c-               bh->b_bdev, (unsigned long)bh->b_blocknr, ##__VA_ARGS__)
--
fs/ext4/xattr.c:# define ea_idebug(inode, fmt, ...)     no_printk(fmt, ##__VA_ARGS__)
fs/ext4/xattr.c:# define ea_bdebug(bh, fmt, ...)        no_printk(fmt, ##__VA_ARGS__)

So the output logging won't be split across multiple lines.

> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
[]
> @@ -55,6 +55,7 @@
>  
>  #include <linux/buffer_head.h>
>  #include <linux/init.h>
> +#include <linux/printk.h>
>  #include <linux/slab.h>
>  #include <linux/mbcache.h>
>  #include <linux/quotaops.h>
> @@ -85,8 +86,8 @@
>  		printk("\n"); \
>  	} while (0)
>  #else
> -# define ea_idebug(f...)
> -# define ea_bdebug(f...)
> +# define ea_idebug(inode, f...)	no_printk(f)
> +# define ea_bdebug(bh, f...)	no_printk(f)
>  #endif
>  
>  static int ext2_xattr_set2(struct inode *, struct buffer_head *,

---
 fs/ext2/xattr.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 943cc46..7740582 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -72,21 +72,15 @@
 #define IS_LAST_ENTRY(entry) (*(__u32 *)(entry) == 0)
 
 #ifdef EXT2_XATTR_DEBUG
-# define ea_idebug(inode, f...) do { \
-		printk(KERN_DEBUG "inode %s:%ld: ", \
-			inode->i_sb->s_id, inode->i_ino); \
-		printk(f); \
-		printk("\n"); \
-	} while (0)
-# define ea_bdebug(bh, f...) do { \
-		printk(KERN_DEBUG "block %pg:%lu: ", \
-			bh->b_bdev, (unsigned long) bh->b_blocknr); \
-		printk(f); \
-		printk("\n"); \
-	} while (0)
+# define ea_idebug(inode, fmt, ...)					\
+	printk(KERN_DEBUG "inode %s:%lu: " fmt "\n",			\
+	       inode->i_sb->s_id, inode->i_ino, ##__VA_ARGS__)
+# define ea_bdebug(bh, fmt, ...)					\
+	printk(KERN_DEBUG "block %pg:%lu: " fmt "\n",			\
+	       bh->b_bdev, (unsigned long)bh->b_blocknr, ##__VA_ARGS__)
 #else
-# define ea_idebug(inode, f...)	no_printk(f)
-# define ea_bdebug(bh, f...)	no_printk(f)
+# define ea_idebug(inode, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
+# define ea_bdebug(bh, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 static int ext2_xattr_set2(struct inode *, struct buffer_head *,


