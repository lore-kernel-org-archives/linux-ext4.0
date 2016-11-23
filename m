From: Jan Kara <jack@suse.cz>
Subject: Re: [ext4:dev 21/26] file.c:undefined reference to `dax_iomap_fault'
Date: Wed, 23 Nov 2016 09:14:43 +0100
Message-ID: <20161123081443.GG3973@quack2.suse.cz>
References: <201611220402.CuudYzqp%fengguang.wu@intel.com>
 <20161122120805.GE3973@quack2.suse.cz>
 <20161122213316.GN28177@dastard>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3siQDZowHQqNOShm"
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932861AbcKWIPh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Nov 2016 03:15:37 -0500
Content-Disposition: inline
In-Reply-To: <20161122213316.GN28177@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 23-11-16 08:33:16, Dave Chinner wrote:
> > diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> > index e38039fd96ff..7b90691e98c4 100644
> > --- a/fs/ext4/Kconfig
> > +++ b/fs/ext4/Kconfig
> > @@ -37,6 +37,7 @@ config EXT4_FS
> >  	select CRC16
> >  	select CRYPTO
> >  	select CRYPTO_CRC32C
> > +	select FS_IOMAP if FS_DAX
> 
> Shouldn't the FS_DAX config select FS_IOMAP unconditionally because
> it is now a hard config dependency in the DAX subsystem?

Yeah, that would be even better. Ted, can you add this cleanup patch as
well (attached)? Possibly also just ditch my previous ext4-specific patch
and remove relevant hunk from the attached one. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--3siQDZowHQqNOShm
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-Select-CONFIG_FS_IOMAP.patch"

>From 829feb225913597bac6cbbe5c80bd1eaa99cd74d Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 23 Nov 2016 09:09:14 +0100
Subject: [PATCH] dax: Select CONFIG_FS_IOMAP

After ditching get_block based functions, every filesystem implementing
DAX needs to use iomap variants. Make CONFIG_FS_DAX select
CONFIG_FS_IOMAP.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/Kconfig      | 1 +
 fs/ext2/Kconfig | 1 -
 fs/ext4/Kconfig | 1 -
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 8e9e5f4104f4..18024bfc6e2c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -38,6 +38,7 @@ config FS_DAX
 	bool "Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
+	select FS_IOMAP
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
diff --git a/fs/ext2/Kconfig b/fs/ext2/Kconfig
index 36bea5adcaba..c634874e12d9 100644
--- a/fs/ext2/Kconfig
+++ b/fs/ext2/Kconfig
@@ -1,6 +1,5 @@
 config EXT2_FS
 	tristate "Second extended fs support"
-	select FS_IOMAP if FS_DAX
 	help
 	  Ext2 is a standard Linux file system for hard disks.
 
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 7b90691e98c4..e38039fd96ff 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -37,7 +37,6 @@ config EXT4_FS
 	select CRC16
 	select CRYPTO
 	select CRYPTO_CRC32C
-	select FS_IOMAP if FS_DAX
 	help
 	  This is the next generation of the ext3 filesystem.
 
-- 
2.6.6


--3siQDZowHQqNOShm--
