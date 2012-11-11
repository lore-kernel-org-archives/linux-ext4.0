From: "George Spelvin" <linux@horizon.com>
Subject: mke2fs -O 64bit -E resize=<anything> divides by 0
Date: 11 Nov 2012 17:27:16 -0500
Message-ID: <20121111222716.11311.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:19296 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751959Ab2KKW1S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Nov 2012 17:27:18 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm using v1.43-WIP-2012-09-22-10-g41bf599, last commit Oct. 14.

I'm trying to create a file system with 64bit support and specify a
maximum resize limit of 64 TiB = 2^34 blocks = 17179869184.

(gdb) run -n -t ext4 -O 64bit -E resize=4294967296 /dev/md1
Starting program: /root/e2fsprogs/misc/mke2fs -n -t ext4 -O 64bit -E resize=4294967295 /dev/md1
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
mke2fs 1.43-WIP (22-Sep-2012)

Program received signal SIGFPE, Arithmetic exception.
0x0000000000405f5a in parse_extended_opts (opts=<optimized out>, 
    param=0x64e200) at mke2fs.c:800
800                             gdpb = EXT2_DESC_PER_BLOCK(param);

The issue is that 

#define EXT2_DESC_PER_BLOCK(s)          (EXT2_BLOCK_SIZE(s) / EXT2_DESC_SIZE(s))
#define EXT2_DESC_SIZE(s)                                                \
       ((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
        (s)->s_desc_size : EXT2_MIN_DESC_SIZE)

and s_desc_size is 0 because parse_extended_opts is called from PRS which
is called very early in main() at line 2320, while s_desc_size is set up
in ext2fs_initialize, which is not called from main() until mke2fs.c:2353.

As a temporary workaround, I notice that ext2fs_initialize sets s_desc_size to
the fixed value EXT2_MIN_DESC_SIZE_64BIT, so I changed the #define as follows:

#define EXT2_DESC_SIZE(s)                                                \
       ((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
        (s)->s_desc_size ?: EXT2_MIN_DESC_SIZE_64BIT : EXT2_MIN_DESC_SIZE)

... which seems to work.


(One point that occurred to me while wrestling with this is that the
default resize limit of initial size * 1000 should perhaps be clamped
to 2^32 if 64bit is not enabled.)
