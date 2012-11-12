From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: mke2fs -O 64bit -E resize=<anything> divides by 0
Date: Sun, 11 Nov 2012 18:54:27 -0700
Message-ID: <FF74F654-B6E0-4BF9-A3FC-C2077275B542@dilger.ca>
References: <20121111222716.11311.qmail@science.horizon.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: "George Spelvin" <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:23542 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2KLByL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Nov 2012 20:54:11 -0500
In-Reply-To: <20121111222716.11311.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-11-11, at 3:27 PM, George Spelvin wrote:
> I'm using v1.43-WIP-2012-09-22-10-g41bf599, last commit Oct. 14.
> 
> I'm trying to create a file system with 64bit support and specify a
> maximum resize limit of 64 TiB = 2^34 blocks = 17179869184.
> 
> (gdb) run -n -t ext4 -O 64bit -E resize=4294967296 /dev/md1
> Starting program: /root/e2fsprogs/misc/mke2fs -n -t ext4 -O 64bit -E resize=4294967295 /dev/md1
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
> mke2fs 1.43-WIP (22-Sep-2012)
> 
> Program received signal SIGFPE, Arithmetic exception.
> 0x0000000000405f5a in parse_extended_opts (opts=<optimized out>, 
>   param=0x64e200) at mke2fs.c:800
> 800                             gdpb = EXT2_DESC_PER_BLOCK(param);

This is definitely a bug in the code to do a divide-by-zero.

However, it should be pointed out that the "resize" option does not
make sense for filesystems larger than 16TB.  The mechanism used for
resizing beyond 16TB is different and does not need to reserve blocks.

Cheers, Andreas.

> The issue is that 
> 
> #define EXT2_DESC_PER_BLOCK(s)          (EXT2_BLOCK_SIZE(s) / EXT2_DESC_SIZE(s))
> #define EXT2_DESC_SIZE(s)                                                \
>      ((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
>       (s)->s_desc_size : EXT2_MIN_DESC_SIZE)
> 
> and s_desc_size is 0 because parse_extended_opts is called from PRS which
> is called very early in main() at line 2320, while s_desc_size is set up
> in ext2fs_initialize, which is not called from main() until mke2fs.c:2353.
> 
> As a temporary workaround, I notice that ext2fs_initialize sets s_desc_size to
> the fixed value EXT2_MIN_DESC_SIZE_64BIT, so I changed the #define as follows:
> 
> #define EXT2_DESC_SIZE(s)                                                \
>      ((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
>       (s)->s_desc_size ?: EXT2_MIN_DESC_SIZE_64BIT : EXT2_MIN_DESC_SIZE)
> 
> ... which seems to work.
> 
> 
> (One point that occurred to me while wrestling with this is that the
> default resize limit of initial size * 1000 should perhaps be clamped
> to 2^32 if 64bit is not enabled.)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





