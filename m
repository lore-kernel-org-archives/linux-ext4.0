From: Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: Re: + ext2-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesys
 tems.patch added to -mm tree
Date: Thu, 12 Feb 2009 14:27:50 +0800
Message-ID: <4993C166.6020905@cn.fujitsu.com>
References: <200902102257.n1AMvwKl006860@imap1.linux-foundation.org> <20090211150227.GI29220@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZBLG2M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 01:28:12 -0500
In-Reply-To: <20090211150227.GI29220@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Feb 10, 2009 at 02:57:58PM -0800, akpm@linux-foundation.org wrote:
>   
>> The patch titled
>>      ext2: fix support for empty directory blocks in 64k blocksize filesystems
>> has been added to the -mm tree.  Its filename is
>>      ext2-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesystems.patch
>>     
>
> NACK.  The commit description is incomplete, we need to discuss more
> what's the best way of handling this.  See the discussion around the
> ext4 patch on linux-ext4 for more details.
>
> This patch is entirely moot for ext2 in any case, since
> EXT2_MAX_BLOCK_SIZE was never changed from 4096.
>   

Hi,  Ted

If you are right, I think this patch is necessary.

[PATCH] ext2: Fix to check unsupported filesystem blocksize

EXT2-fs defined that the max blocksize is:
        #define EXT2_MAX_BLOCK_SIZE	4960
and the min blocksize is:
        #define EXT2_MIN_BLOCK_SIZE	1024

But never check this in ext2_fill_super(). So mount will
always success even if the block size is larger than 4096.

This patch fixed the problem.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 fs/ext2/super.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index da8bdea..36cdfd6 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -873,6 +873,14 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
+	if (blocksize < EXT2_MIN_BLOCK_SIZE ||
+	    blocksize > EXT2_MAX_BLOCK_SIZE) {
+		printk(KERN_ERR
+		       "EXT2-fs: Unsupported filesystem blocksize %d on %s.\n",
+		       blocksize, sb->s_id);
+		goto failed_mount;
+	}
+
 	if (ext2_use_xip(sb) && blocksize != PAGE_SIZE) {
 		if (!silent)
 			printk("XIP: Unsupported blocksize\n");
-- 
1.5.3.8




