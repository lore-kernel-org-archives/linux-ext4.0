From: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: Linux 2.6.24.atmel.1 MMC/SD
Date: Thu, 21 Feb 2008 12:35:43 +0100
Message-ID: <20080221123543.412096f7@dhcp-252-066.norway.atmel.com>
References: <71C39AE3DF382B4A9CD370AD1C63B855EA060C@stervanexmb01.teradici.local>
	<47BD1760.9080007@yahoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: James Stewart <jstewart@teradici.com>, kernel@avr32linux.org,
	linux-ext4@vger.kernel.org
To: Hein_Tibosch <hein_tibosch@yahoo.es>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nat-132.atmel.no ([80.232.32.132]:51926 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756544AbYBULgQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2008 06:36:16 -0500
In-Reply-To: <47BD1760.9080007@yahoo.es>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Adding the ext2/ext3/ext4 list to Cc)

Note that the MMC/SD card driver in question, atmel-mci, is not in
mainline, and may be the real cause of this problem. But it looks like
there might be a potential problem in the ext3 code as well?

Haavard

On Thu, 21 Feb 2008 14:17:04 +0800
Hein_Tibosch <hein_tibosch@yahoo.es> wrote:

> Hi James,
> 
> 
> I've had all kinds of problems with the SD-card hooked to an NGW100, just as John Voltz reported earlier:
> 
>     http://www.avr32linux.org/archives/kernel/2007-November/000421.html
>     http://www.avr32linux.org/archives/kernel/2007-November/000425.html
> 
> I debugged this problem and my conclusion is: using an SD-card may lead to both BUS-errors and a complete hanging of the system, with 2.6.23.atmel.5 as well as 2.6.24.atmel.1.
> 
> Both the driver for ext2 and ext3 are using this type of function to iterate through a array of inodes:
> 
>     static inline ext2_dirent *ext2_next_entry(ext2_dirent *p)
>     {
>         return (ext2_dirent *)((char*)p + le16_to_cpu(p->rec_len));
>     }
> 
>     static inline struct ext3_dir_entry_2 *
>         ext3_next_entry(struct ext3_dir_entry_2 *p)
>     {
>         return (struct ext3_dir_entry_2 *)((char *)p +
>             ext3_rec_len_from_disk(p->rec_len));
>     }
> 
> 
> Sometimes, rec_len is checked for a zero-value, sometimes the entry is checked thoroughly for validity (like with ext2_check_page() or ext3_check_dir_entry()), but in other cases rec_len isn't checked at all! This is the case in e.g. fs/ext3/namei.c, function ext3_dx_find_entry(). This function is always enabled since 2.6.24 (CONFIG_EXT3_INDEX not used anymore).
> 
> I had a card on which at one place rec_len turned out to be a small negative number. When iterating, it would either cycle for ever (until WDT) or it could enter invalid memory (OOPS: BUS error).
> 
> ( strange though that the rec_len appeared to have a negative number, I just did a "mkfs -t ext3" on Ubuntu. Could that be caused by the Atmel-driver? )
> 
> I don't yet feel qualified to make a patch for this, I only did it for myself. Maybe someone can pick this up: a validity check should be made before any call to xxx_next_entry().
> 
> 
> Regards,
> 
> Hein Tibosch (HeinBali at avr32linux)
> 
> 
> 
> James Stewart wrote:
> Hi,
>  
> I'm wondering if there are any known issues with booting from SD card on the ATNGW100 using this kernel. I get a bunch of ext2 looking errors and then a stack dump immediately after mounting VFS. 2.6.23.atmel.5 runs perfectly, however.
>  
> This is just compiling using atngw100_defconfig.
>  
> Thanks,
>  
> James
> 
> ------------------------------------------------
> 
> _______________________________________________
> Kernel mailing list
> Kernel@avr32linux.org
> http://duppen.flaskehals.net/cgi-bin/mailman/listinfo/kernel
>   
