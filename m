From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: + ext4-uninitialized-block-groups-fix.patch added to -mm tree
Date: Fri, 21 Sep 2007 11:19:51 +0530
Message-ID: <46F35B7F.6070302@linux.vnet.ibm.com>
References: <200709210502.l8L52HRw019656@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mm-commits@vger.kernel.org, mathur@linux.vnet.ibm.com,
	adilger@clusterfs.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	mathur@us.ibm.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:35050 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbXIUFu0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 01:50:26 -0400
In-Reply-To: <200709210502.l8L52HRw019656@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



akpm@linux-foundation.org wrote:
> The patch titled
>      Ext4: Uninitialized Block Groups (fix)
> has been added to the -mm tree.  Its filename is
>      ext4-uninitialized-block-groups-fix.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: Ext4: Uninitialized Block Groups (fix)
> From: Avantika Mathur <mathur@linux.vnet.ibm.com>
> 
> Andreas Dilger wrote:
>> On Sep 18, 2007  20:03 -0700, Andrew Morton wrote:
>>
>>> On Tue, 18 Sep 2007 17:25:31 -0700 Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:
>>>
>>>
>>>> +#if !defined(CONFIG_CRC16)
>>>> +/** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
>>>> +__u16 const crc16_table[256] = { me
>>>> +	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
>>>>
>>> That's rather sad.  A plain old "depends on" would be better.
>>>
>> My bad.  We wrote this patch and it had to run on older kernels that might
>> not even have lib/crc16.c (it was added around 2.6.15 or so, so e.g. RHEL4
>> doesn't have it).  I forgot to remove it from the upstream submission,
>> and since it didn't cause problems nobody else complained...
> The incremental patch below removes the local crc16 code, and also resolves an
> issue with properly updating bg_itable_unused when an inode is allocated in an
> unused block groups.
> 
> Cc: Andreas Dilger <adilger@clusterfs.com>
> Cc: Avantika Mathur <mathur@us.ibm.com>
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Cc: <linux-ext4@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


> ---
> 
>  fs/Kconfig       |    1 
>  fs/ext4/ialloc.c |    8 ++++++-
>  fs/ext4/super.c  |   51 ---------------------------------------------
>  3 files changed, 9 insertions(+), 51 deletions(-)
> 
> diff -puN fs/ext4/ialloc.c~ext4-uninitialized-block-groups-fix fs/ext4/ialloc.c
> --- a/fs/ext4/ialloc.c~ext4-uninitialized-block-groups-fix
> +++ a/fs/ext4/ialloc.c
> @@ -632,12 +632,18 @@ got:
>  	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
>  		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
>  			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
> -			free = EXT4_INODES_PER_GROUP(sb);


I guess a comment as below would help to explain why are we not decrementing
bg_itable_unused by 1.


/* When marking the block group with ~EXT4_BG_INODE_UNINIT we don't want to depend
 * on the value of bg_itable_unsed even though mke2fs could have initialized the 
 * same for us. Instead we calculated the value below
 */


> +			free = 0;
>  		} else {
>  			free = EXT4_INODES_PER_GROUP(sb) -
>  				le16_to_cpu(gdp->bg_itable_unused);
>  		}
> 
> +		/*
> +		 * Check the relative inode number against the last used
> +		 * relative inode number in this group. if it is greater
> +		 * we need to  update the bg_itable_unused count
> +		 *
> +		 */
>  		if (ino > free)
>  			gdp->bg_itable_unused =
>  				cpu_to_le16(EXT4_INODES_PER_GROUP(sb) - ino);
> diff -puN fs/ext4/super.c~ext4-uninitialized-block-groups-fix fs/ext4/super.c
> --- a/fs/ext4/super.c~ext4-uninitialized-block-groups-fix
> +++ a/fs/ext4/super.c
> @@ -37,6 +37,7 @@
>  #include <linux/quotaops.h>
>  #include <linux/seq_file.h>
>  #include <linux/log2.h>
> +#include <linux/crc16.h>
> 
>  #include <asm/uaccess.h>
> 
> @@ -1337,56 +1338,6 @@ static int ext4_setup_super(struct super
>  	return res;
>  }
> 
> -#if !defined(CONFIG_CRC16)
> -/** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
> -__u16 const crc16_table[256] = {
> -	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
> -	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
> -	0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
> -	0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
> -	0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
> -	0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
> -	0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
> -	0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
> -	0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
> -	0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
> -	0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
> -	0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
> -	0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
> -	0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
> -	0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
> -	0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
> -	0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
> -	0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
> -	0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
> -	0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
> -	0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
> -	0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
> -	0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
> -	0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
> -	0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
> -	0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
> -	0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
> -	0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
> -	0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
> -	0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
> -	0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
> -	0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
> -};
> -
> -static inline __u16 crc16_byte(__u16 crc, const __u8 data)
> -{
> -	return (crc >> 8) ^ crc16_table[(crc ^ data) & 0xff];
> -}
> -
> -__u16 crc16(__u16 crc, __u8 const *buffer, size_t len)
> -{
> -	while (len--)
> -		crc = crc16_byte(crc, *buffer++);
> -	return crc;
> -}
> -#endif
> -
>  __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
>  			    struct ext4_group_desc *gdp)
>  {
> diff -puN fs/Kconfig~ext4-uninitialized-block-groups-fix fs/Kconfig
> --- a/fs/Kconfig~ext4-uninitialized-block-groups-fix
> +++ a/fs/Kconfig
> @@ -140,6 +140,7 @@ config EXT4DEV_FS
>  	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL
>  	select JBD2
> +	select CRC16
>  	help
>  	  Ext4dev is a predecessor filesystem of the next generation
>  	  extended fs ext4, based on ext3 filesystem code. It will be
> _
> 
> Patches currently in -mm which might be from mathur@linux.vnet.ibm.com are
> 
> ext4-uninitialized-block-groups-fix.patch
> 
> 
