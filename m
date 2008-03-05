From: Andreas Dilger <adilger@sun.com>
Subject: Re: Ext2 - ext3 unstable under 2.6.24: now solved (?)
Date: Tue, 04 Mar 2008 17:22:17 -0700
Message-ID: <20080305002217.GY3616@webber.adilger.int>
References: <71C39AE3DF382B4A9CD370AD1C63B855EA060C@stervanexmb01.teradici.local>
 <47BD1760.9080007@yahoo.es>
 <20080221123543.412096f7@dhcp-252-066.norway.atmel.com>
 <47CDA618.9040007@yahoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: James Stewart <jstewart@teradici.com>, linux-ext4@vger.kernel.org
To: Hein_Tibosch <hein_tibosch@yahoo.es>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:37992 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbYCEAWy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 19:22:54 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m250MpJk007120
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 16:22:52 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JX800H01E3PKG00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 04 Mar 2008 16:22:51 -0800 (PST)
In-reply-to: <47CDA618.9040007@yahoo.es>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 05, 2008  03:42 +0800, Hein_Tibosch wrote:
> Could someone please check the following?
>
> The ext2 and ext3 filesystems of 2.6.24 show many Oops and hangups. After 
> debugging I found the following common cause:
>
> In a new 2.6.24 function an unwanted sign-extension takes place in:
>
> fs/ext2/dir.c
>
> static inline unsigned ext2_rec_len_from_disk(__le16 dlen)
> {
>   unsigned len = le16_to_cpu(dlen);
>
>   if (len == EXT2_MAX_REC_LEN)
>       return 1 << 16;
>   return len;
> }
>
> include/ext3_fs.h :
>
> static inline unsigned ext3_rec_len_from_disk(__le16 dlen)
> {
>    unsigned len = le16_to_cpu(dlen);
>
>    if (len == EXT3_MAX_REC_LEN)
>        return 1 << 16;
>    return len;
> }
>
> 00A0 will be returned as 0xFFFFA000 !!

Presumably this is a big-endian architecture?  It would appear to be a bug
in the le16_to_cpu() code rather than the functions above, since they are
always using an unsigned variable.

I suppose it would be possible to mask off the returned value, but this
seems like it is fixing the problem at the wrong level:

	return (len & 0xffffU);

> Many code which iterates through dirent's, uses the above function to 
> determine the start of the next dirent.(ext2_dirent, ext3_dir_entry_2)
> See fs/ext2/dir.c and fs/ext3/namei.c
>
> As a test I replaced "le16_to_cpu()" by a simple:
>
> static inline unsigned my_le16_to_cpu (__le16 value)
> {
>    return ((value & 0x00FF) << 8) | ((value & 0xFF00) >> 8);
> }
>
> It showed no more "negative" rec_len values which cause the crashes, and 
> both ext2/3 now run stable.
>
> Compiler: gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)
> Kernel: 2.6.24.atmel.1
> Platform: Atmel AP7000 CPU, compiling with "ARCH=avr32 
> CROSS_COMPILE=avr32-linux-"
>
>
> Hein Tibosch
>
>
> Haavard Skinnemoen wrote:
>> (Adding the ext2/ext3/ext4 list to Cc)
>>
>> Note that the MMC/SD card driver in question, atmel-mci, is not in
>> mainline, and may be the real cause of this problem. But it looks like
>> there might be a potential problem in the ext3 code as well?
>>
>> Haavard
>>
>> On Thu, 21 Feb 2008 14:17:04 +0800
>> Hein_Tibosch <hein_tibosch@yahoo.es> wrote:
>>
>>   
>>> Hi James,
>>>
>>>
>>> I've had all kinds of problems with the SD-card hooked to an NGW100, just as John Voltz reported earlier:
>>>
>>>     http://www.avr32linux.org/archives/kernel/2007-November/000421.html
>>>     http://www.avr32linux.org/archives/kernel/2007-November/000425.html
>>>
>>> I debugged this problem and my conclusion is: using an SD-card may lead to both BUS-errors and a complete hanging of the system, with 2.6.23.atmel.5 as well as 2.6.24.atmel.1.
>>>
>>> Both the driver for ext2 and ext3 are using this type of function to iterate through a array of inodes:
>>>
>>>     static inline ext2_dirent *ext2_next_entry(ext2_dirent *p)
>>>     {
>>>         return (ext2_dirent *)((char*)p + le16_to_cpu(p->rec_len));
>>>     }
>>>
>>>     static inline struct ext3_dir_entry_2 *
>>>         ext3_next_entry(struct ext3_dir_entry_2 *p)
>>>     {
>>>         return (struct ext3_dir_entry_2 *)((char *)p +
>>>             ext3_rec_len_from_disk(p->rec_len));
>>>     }
>>>
>>>
>>> Sometimes, rec_len is checked for a zero-value, sometimes the entry is checked thoroughly for validity (like with ext2_check_page() or ext3_check_dir_entry()), but in other cases rec_len isn't checked at all! This is the case in e.g. fs/ext3/namei.c, function ext3_dx_find_entry(). This function is always enabled since 2.6.24 (CONFIG_EXT3_INDEX not used anymore).
>>>
>>> I had a card on which at one place rec_len turned out to be a small negative number. When iterating, it would either cycle for ever (until WDT) or it could enter invalid memory (OOPS: BUS error).
>>>
>>> ( strange though that the rec_len appeared to have a negative number, I just did a "mkfs -t ext3" on Ubuntu. Could that be caused by the Atmel-driver? )
>>>
>>> I don't yet feel qualified to make a patch for this, I only did it for myself. Maybe someone can pick this up: a validity check should be made before any call to xxx_next_entry().
>>>
>>>
>>> Regards,
>>>
>>> Hein Tibosch (HeinBali at avr32linux)
>>>
>>>
>>>
>>> James Stewart wrote:
>>> Hi,
>>>  I'm wondering if there are any known issues with booting from SD card on 
>>> the ATNGW100 using this kernel. I get a bunch of ext2 looking errors and 
>>> then a stack dump immediately after mounting VFS. 2.6.23.atmel.5 runs 
>>> perfectly, however.
>>>  This is just compiling using atngw100_defconfig.
>>>  Thanks,
>>>  James
>>>
>>> ------------------------------------------------
>>>
>>> _______________________________________________
>>> Kernel mailing list
>>> Kernel@avr32linux.org
>>> http://duppen.flaskehals.net/cgi-bin/mailman/listinfo/kernel
>>>       
>>
>>   
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

