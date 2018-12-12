Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43531 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbeLLDQK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Dec 2018 22:16:10 -0500
Subject: Re: [PATCH V2 3/7] fscrypt: remove filesystem specific build config
 option
To: Eric Biggers <ebiggers@kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
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
References: <20181204095650.12562-1-chandan@linux.vnet.ibm.com>
 <20181204095650.12562-4-chandan@linux.vnet.ibm.com>
 <20181212015211.GA23905@roeck-us.net> <20181212024811.GB722@sol.localdomain>
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <a006332b-a5cd-188b-d0bf-f2b7da6bad3b@roeck-us.net>
Date: Tue, 11 Dec 2018 19:16:04 -0800
MIME-Version: 1.0
In-Reply-To: <20181212024811.GB722@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/11/18 6:48 PM, Eric Biggers wrote:
> On Tue, Dec 11, 2018 at 05:52:11PM -0800, Guenter Roeck wrote:
>> Hi,
>>
>> On Tue, Dec 04, 2018 at 03:26:46PM +0530, Chandan Rajendra wrote:
>>> In order to have a common code base for fscrypt "post read" processing
>>> for all filesystems which support encryption, this commit removes
>>> filesystem specific build config option (e.g. CONFIG_EXT4_FS_ENCRYPTION)
>>> and replaces it with a build option (i.e. CONFIG_FS_ENCRYPTION) whose
>>> value affects all the filesystems making use of fscrypt.
>>>
>>> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>
>> this patch causes a recursive dependency when trying to build ia64 images.
>>
>> make ARCH=ia64 allnoconfig:
>>
>> scripts/kconfig/conf  --allnoconfig Kconfig
>> arch/ia64/Kconfig:126:error: recursive dependency detected!
>> arch/ia64/Kconfig:126:	choice <choice> contains symbol IA64_HP_SIM
>> arch/ia64/Kconfig:200:	symbol IA64_HP_SIM is part of choice PM
>> kernel/power/Kconfig:144:	symbol PM is selected by PM_SLEEP
>> kernel/power/Kconfig:104:	symbol PM_SLEEP depends on HIBERNATE_CALLBACKS
>> kernel/power/Kconfig:31:	symbol HIBERNATE_CALLBACKS is selected by HIBERNATION
>> kernel/power/Kconfig:34:	symbol HIBERNATION depends on SWAP
>> init/Kconfig:250:	symbol SWAP depends on BLOCK
>> block/Kconfig:5:	symbol BLOCK is selected by UBIFS_FS
>> fs/ubifs/Kconfig:1:	symbol UBIFS_FS depends on MISC_FILESYSTEMS
>> fs/Kconfig:220:	symbol MISC_FILESYSTEMS is selected by ACPI_APEI
>> drivers/acpi/apei/Kconfig:8:	symbol ACPI_APEI depends on ACPI
>> drivers/acpi/Kconfig:9:	symbol ACPI depends on ARCH_SUPPORTS_ACPI
>> drivers/acpi/Kconfig:6:	symbol ARCH_SUPPORTS_ACPI is selected by IA64_HP_SIM
>> arch/ia64/Kconfig:200:	symbol IA64_HP_SIM is part of choice <choice>
>> For a resolution refer to Documentation/kbuild/kconfig-language.txt
>> subsection "Kconfig recursive dependency limitations"
>>
>> scripts/kconfig/Makefile:69: recipe for target 'allnoconfig' failed
>>
>> Reverting the patch fixes the problem.
>>
> 
> Thanks for the report.  Chandan, it appears the problem is UBIFS_FS selecting
> BLOCK.  It's actually not necessary because now the parts of fs/crypto/ that
> depend on BLOCK are separated out into a separate file fs/crypto/bio.c that is
> only compiled with CONFIG_BLOCK.  So how about just removing the selection of
> BLOCK from fs/ubifs/Kconfig:
> 
> 	select BLOCK if FS_ENCRYPTION
> 
The recursion is gone if I make this change.

Guenter
