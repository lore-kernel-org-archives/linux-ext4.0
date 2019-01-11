Return-Path: <SRS0=9YHU=PT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbfAKBBT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Jan 2019 20:01:19 -0500
Date: Thu, 10 Jan 2019 17:01:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>, Theodore Ts'o <tytso@mit.edu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH] fscrypt: remove filesystem specific build
 config option
Message-ID: <20190111010116.GG149637@gmail.com>
References: <20190110233230.GA23953@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190110233230.GA23953@roeck-us.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 10, 2019 at 03:32:30PM -0800, Guenter Roeck wrote:
> On Sat, Dec 08, 2018 at 12:21:38PM +0530, Chandan Rajendra wrote:
> > In order to have a common code base for fscrypt "post read" processing
> > for all filesystems which support encryption, this commit removes
> > filesystem specific build config option (e.g. CONFIG_EXT4_FS_ENCRYPTION)
> > and replaces it with a build option (i.e. CONFIG_FS_ENCRYPTION) whose
> > value affects all the filesystems making use of fscrypt.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> This results in:
> 
> Building ia64:allnoconfig ... failed
> --------------
> Error log:
> make[1]: Entering directory '/tmp/buildbot-builddir.7Wft3'
>   GEN     Makefile
> scripts/kconfig/conf  --allnoconfig Kconfig
> arch/ia64/Kconfig:128:error: recursive dependency detected!
> arch/ia64/Kconfig:128:	choice <choice> contains symbol IA64_HP_SIM
> arch/ia64/Kconfig:202:	symbol IA64_HP_SIM is part of choice PM
> kernel/power/Kconfig:144:	symbol PM is selected by PM_SLEEP
> kernel/power/Kconfig:104:	symbol PM_SLEEP depends on HIBERNATE_CALLBACKS
> kernel/power/Kconfig:31:	symbol HIBERNATE_CALLBACKS is selected by HIBERNATION
> kernel/power/Kconfig:34:	symbol HIBERNATION depends on SWAP
> init/Kconfig:250:	symbol SWAP depends on BLOCK
> block/Kconfig:5:	symbol BLOCK is selected by UBIFS_FS
> fs/ubifs/Kconfig:1:	symbol UBIFS_FS depends on MISC_FILESYSTEMS
> fs/Kconfig:227:	symbol MISC_FILESYSTEMS is selected by ACPI_APEI
> drivers/acpi/apei/Kconfig:8:	symbol ACPI_APEI depends on ACPI
> drivers/acpi/Kconfig:9:	symbol ACPI depends on ARCH_SUPPORTS_ACPI
> drivers/acpi/Kconfig:6:	symbol ARCH_SUPPORTS_ACPI is selected by IA64_HP_SIM
> arch/ia64/Kconfig:202:	symbol IA64_HP_SIM is part of choice <choice>
> For a resolution refer to Documentation/kbuild/kconfig-language.txt
> subsection "Kconfig recursive dependency limitations"
> 
> Didn't we have exactly the same problem before ?
> 
> Guenter

Indeed, Chandan Rajendra sent out a new version of the patch which fixes the
problem (by removing the 'select BLOCK' from fs/ubifs/Kconfig), but it never
made it into the fscrypt tree and hence never made it into linux-next.

Ted, what you are planning to do with the fscrypt tree following the fsverity
discussion?  IMO, we should keep the fsverity stuff in its own branch, separate
from any fscrypt changes.  As a suggestion, in the branch "fscrypt" of my
linux.git repo [1], I applied just these four patches on top of v5.0-rc1 and
resolved the conflicts with them no longer being on top of fsverity:

	fscrypt: remove CRYPTO_CTR dependency
	ext4: use IS_ENCRYPTED() to check encryption status
	f2fs: use IS_ENCRYPTED() to check encryption status
	fscrypt: remove filesystem specific build config option

(The last patch is the fixed version.)

Please consider doing the same with the official fscrypt tree.  Thanks!

[1] https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=fscrypt

- Eric
