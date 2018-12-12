Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36915 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbeLLBwP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Dec 2018 20:52:15 -0500
Date: Tue, 11 Dec 2018 17:52:11 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-mips@linux-mips.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com, corbet@lwn.net, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, green.hu@gmail.com,
        deanbo422@gmail.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, richard@nod.at, dedekind1@gmail.com,
        adrian.hunter@intel.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH V2 3/7] fscrypt: remove filesystem specific build config
 option
Message-ID: <20181212015211.GA23905@roeck-us.net>
References: <20181204095650.12562-1-chandan@linux.vnet.ibm.com>
 <20181204095650.12562-4-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204095650.12562-4-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Tue, Dec 04, 2018 at 03:26:46PM +0530, Chandan Rajendra wrote:
> In order to have a common code base for fscrypt "post read" processing
> for all filesystems which support encryption, this commit removes
> filesystem specific build config option (e.g. CONFIG_EXT4_FS_ENCRYPTION)
> and replaces it with a build option (i.e. CONFIG_FS_ENCRYPTION) whose
> value affects all the filesystems making use of fscrypt.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

this patch causes a recursive dependency when trying to build ia64 images.

make ARCH=ia64 allnoconfig:

scripts/kconfig/conf  --allnoconfig Kconfig
arch/ia64/Kconfig:126:error: recursive dependency detected!
arch/ia64/Kconfig:126:	choice <choice> contains symbol IA64_HP_SIM
arch/ia64/Kconfig:200:	symbol IA64_HP_SIM is part of choice PM
kernel/power/Kconfig:144:	symbol PM is selected by PM_SLEEP
kernel/power/Kconfig:104:	symbol PM_SLEEP depends on HIBERNATE_CALLBACKS
kernel/power/Kconfig:31:	symbol HIBERNATE_CALLBACKS is selected by HIBERNATION
kernel/power/Kconfig:34:	symbol HIBERNATION depends on SWAP
init/Kconfig:250:	symbol SWAP depends on BLOCK
block/Kconfig:5:	symbol BLOCK is selected by UBIFS_FS
fs/ubifs/Kconfig:1:	symbol UBIFS_FS depends on MISC_FILESYSTEMS
fs/Kconfig:220:	symbol MISC_FILESYSTEMS is selected by ACPI_APEI
drivers/acpi/apei/Kconfig:8:	symbol ACPI_APEI depends on ACPI
drivers/acpi/Kconfig:9:	symbol ACPI depends on ARCH_SUPPORTS_ACPI
drivers/acpi/Kconfig:6:	symbol ARCH_SUPPORTS_ACPI is selected by IA64_HP_SIM
arch/ia64/Kconfig:200:	symbol IA64_HP_SIM is part of choice <choice>
For a resolution refer to Documentation/kbuild/kconfig-language.txt
subsection "Kconfig recursive dependency limitations"

scripts/kconfig/Makefile:69: recipe for target 'allnoconfig' failed

Reverting the patch fixes the problem.

Guenter

---
bisect log:

# bad: [60bec71b5acb0b469d07e73a348f6610236ae7fa] Add linux-next specific files for 20181211
# good: [40e020c129cfc991e8ab4736d2665351ffd1468d] Linux 4.20-rc6
git bisect start 'HEAD' 'v4.20-rc6'
# bad: [9d9400c203d670e3b002336bf3a70a34c8023853] Merge remote-tracking branch 'spi-nor/spi-nor/next'
git bisect bad 9d9400c203d670e3b002336bf3a70a34c8023853
# bad: [98d439a801d02e313d762fa08368b680e4c0d961] Merge remote-tracking branch 'vfs/for-next'
git bisect bad 98d439a801d02e313d762fa08368b680e4c0d961
# good: [79271eb86e6aca36f962657ea4efa248fc84e2fa] Merge remote-tracking branch 'samsung-krzk/for-next'
git bisect good 79271eb86e6aca36f962657ea4efa248fc84e2fa
# good: [b506abfb5f33d7358cfc9818054e3a834813f7af] Merge remote-tracking branch 'mips/mips-next'
git bisect good b506abfb5f33d7358cfc9818054e3a834813f7af
# bad: [d58e2b0647688a51a96e373589c0597f493ba066] Merge remote-tracking branch 'befs/for-next'
git bisect bad d58e2b0647688a51a96e373589c0597f493ba066
# good: [39f8d343f04868e14abdf1c7ca31d53855bf6f81] Merge remote-tracking branch 'risc-v/for-next'
git bisect good 39f8d343f04868e14abdf1c7ca31d53855bf6f81
# good: [e2f3efdaf1b66f9ac1a5ae16a99a1ff5b0956515] Merge branch 'xtensa-cleanups' into xtensa-for-next
git bisect good e2f3efdaf1b66f9ac1a5ae16a99a1ff5b0956515
# bad: [25da54f1d777ac4a612d9b036f8ac41baf746674] fsverity: Move verity status check to fsverity_prepare_setattr
git bisect bad 25da54f1d777ac4a612d9b036f8ac41baf746674
# good: [a391d6149e706be54aeed8757769910f1b2445d4] fs-verity: add CRC-32C support
git bisect good a391d6149e706be54aeed8757769910f1b2445d4
# good: [848a010287e6a02f1e46c344bbffeb987ed2a0aa] f2fs: use IS_ENCRYPTED() to check encryption status
git bisect good 848a010287e6a02f1e46c344bbffeb987ed2a0aa
# bad: [9f55ada08b452bde55c02ae9bc97c19990ff5c36] ext4: use IS_VERITY() to check inode's fsverity status
git bisect bad 9f55ada08b452bde55c02ae9bc97c19990ff5c36
# bad: [824834dc4a5e595ef24ba44086efa56b97ad4990] Add S_VERITY and IS_VERITY()
git bisect bad 824834dc4a5e595ef24ba44086efa56b97ad4990
# bad: [6956097c429aae498d26b8603b2dec39250b8940] fscrypt: remove filesystem specific build config option
git bisect bad 6956097c429aae498d26b8603b2dec39250b8940
# first bad commit: [6956097c429aae498d26b8603b2dec39250b8940] fscrypt: remove filesystem specific build config option
