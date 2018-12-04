Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbeLDXnX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Dec 2018 18:43:23 -0500
Date: Tue, 4 Dec 2018 15:43:21 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-mips@linux-mips.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com,
        corbet@lwn.net, ralf@linux-mips.org, paul.burton@mips.com,
        jhogan@kernel.org, green.hu@gmail.com, deanbo422@gmail.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, richard@nod.at,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH V2 3/7] fscrypt: remove filesystem specific build config
 option
Message-ID: <20181204234320.GC70682@gmail.com>
References: <20181204095650.12562-1-chandan@linux.vnet.ibm.com>
 <20181204095650.12562-4-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204095650.12562-4-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Chandan,

On Tue, Dec 04, 2018 at 03:26:46PM +0530, Chandan Rajendra wrote:
> In order to have a common code base for fscrypt "post read" processing
> for all filesystems which support encryption, this commit removes
> filesystem specific build config option (e.g. CONFIG_EXT4_FS_ENCRYPTION)
> and replaces it with a build option (i.e. CONFIG_FS_ENCRYPTION) whose
> value affects all the filesystems making use of fscrypt.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
[...]
> -config F2FS_FS_ENCRYPTION
> -	bool "F2FS Encryption"
> -	depends on F2FS_FS
> -	depends on F2FS_FS_XATTR
> -	select FS_ENCRYPTION
> -	help
> -	  Enable encryption of f2fs files and directories.  This
> -	  feature is similar to ecryptfs, but it is more memory
> -	  efficient since it avoids caching the encrypted and
> -	  decrypted pages in the page cache.
> -
[...]
> -config UBIFS_FS_ENCRYPTION
> -	bool "UBIFS Encryption"
> -	depends on UBIFS_FS && UBIFS_FS_XATTR && BLOCK
> -	select FS_ENCRYPTION
> -	default n
> -	help
> -	  Enable encryption of UBIFS files and directories. This
> -	  feature is similar to ecryptfs, but it is more memory
> -	  efficient since it avoids caching the encrypted and
> -	  decrypted pages in the page cache.

Will it cause problems that now f2fs encryption can be "enabled" without
F2FS_FS_XATTR, and ubifs encryption without UBIFS_FS_XATTR && BLOCK?

Otherwise I think this patch looks fine.  I'm a bit concerned about the bloat
from making FS_ENCRYPTION non-modular, but given that it will make sharing I/O
code much easier, it's probably worthwhile.

It would help to strip down the dependencies of FS_ENCRYPTION to just the stuff
needed for just AES-256-XTS and AES-256-CTS.  I already sent out a patch a
couple months ago (https://patchwork.kernel.org/patch/10589319/) to remove
CONFIG_CTR which isn't used at all; I'll remind Ted to apply that.  But we could
also drop CONFIG_SHA256, which is only needed for AES-128-CBC contents
encryption.  If we do that, it should be a separate patch, though.

Thanks,

- Eric
