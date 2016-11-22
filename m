From: Jan Kara <jack@suse.cz>
Subject: Re: [ext4:dev 21/26] file.c:undefined reference to `dax_iomap_fault'
Date: Tue, 22 Nov 2016 13:08:05 +0100
Message-ID: <20161122120805.GE3973@quack2.suse.cz>
References: <201611220402.CuudYzqp%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57401 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753000AbcKVMIO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Nov 2016 07:08:14 -0500
Content-Disposition: inline
In-Reply-To: <201611220402.CuudYzqp%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 22-11-16 04:17:11, Wu Fengguang wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> head:   19b29dca7eef735531a2448e692bb1658c351887
> commit: 8b72e1435cd73926cba767fba3e957807a97069c [21/26] ext4: convert DAX faults to iomap infrastructure
> config: i386-randconfig-sb0-11212318 (attached as .config)
> compiler: gcc-5 (Debian 5.4.1-2) 5.4.1 20160904
> reproduce:
>         git checkout 8b72e1435cd73926cba767fba3e957807a97069c
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    fs/built-in.o: In function `ext4_dax_fault':
> >> file.c:(.text+0x529f3): undefined reference to `dax_iomap_fault'
>    fs/built-in.o: In function `ext4_file_read_iter':
>    file.c:(.text+0x52bab): undefined reference to `dax_iomap_rw'
>    fs/built-in.o: In function `ext4_file_write_iter':
>    file.c:(.text+0x52dff): undefined reference to `dax_iomap_rw'
>    fs/built-in.o: In function `ext4_block_zero_page_range':
>    inode.c:(.text+0x57c8e): undefined reference to `iomap_zero_range'

Ah, I forgot to select FS_IOMAP when DAX was enabled and having ext2
enabled in my test builds has hidden this problem. Attached patch fixes the
build failure for me. Ted, please add this fix to your tree. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--qMm9M+Fa2AknHoGS
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Add-select-for-CONFIG_FS_IOMAP.patch"

>From 5954709eacfc3fd14b7109b01f5ee6e0a3f3874e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 22 Nov 2016 12:51:36 +0100
Subject: [PATCH] ext4: Add select for CONFIG_FS_IOMAP

When ext4 is compiled with DAX support, it now needs the iomap code. Add
appropriate select to Kconfig.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index e38039fd96ff..7b90691e98c4 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -37,6 +37,7 @@ config EXT4_FS
 	select CRC16
 	select CRYPTO
 	select CRYPTO_CRC32C
+	select FS_IOMAP if FS_DAX
 	help
 	  This is the next generation of the ext3 filesystem.
 
-- 
2.6.6


--qMm9M+Fa2AknHoGS--
