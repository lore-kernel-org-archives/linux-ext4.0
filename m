From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Mon, 24 Mar 2008 20:00:54 +0900
Message-ID: <47E789E6.6000806@rs.jp.nec.com>
References: <200803141202.AA00330@TNESG9526.rs.jp.nec.com> <20080314125848.GE3542@webber.adilger.int> <47DE0F8D.2060106@rs.jp.nec.com> <20080317170846.GE3542@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:42246 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbYCXLBE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 07:01:04 -0400
In-Reply-To: <20080317170846.GE3542@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> On Mar 17, 2008  15:28 +0900, Akira Fujita wrote:
>   
>> Hi Andreas,
>>     
>>>> How about renaming this structure from ext4_extent_data to
>>>> ext4_extent_info which used the extent in-core structure
>>>> and put it into ext4_fs_extents.h? Because in-core super_block is 
>>>> ext4_sb_info.
>>>>
>>>> /*
>>>>  * This is the extent in-core structure.
>>>>  */
>>>> struct ext4_extent_info {
>>>> 	ext4_lblk_t	ee_block;	/* first logical block extent covers */
>>>> 	int		ee_len;		/* number of blocks covered by extent */
>>>> 	ext4_fsblk_t	ee_start;	/* first physical block extent covers */
>>>> };          
>>>>         
>>> Would it be possible to use the FIEMAP interface to get the file mapping
>>> data to userspace?  That would avoid the need to have a second ioctl
>>> with nearly the same data.
>>>       
>>   
>> Reducing ioctl makes sense.
>> But EXT4_EXTENTS_INFO needs to get the file mapping data
>> with inode number not file name.
>> So we should keep ext4_extents_info structure
>> or put ino entry in fiemap structure.
>>     
>
> We introduced a special ioctl for this which would allow root to perform
> ioctl() on any inode by inode number.  We call this EXT4_IOC_WRAPPER, and
> it is called on the root inode and specifies the inode number and real
> ioctl number before the rest of the ioctl data.
>
> struct ext4_ioctl_wrapper {
> 	__u32 ioctl_cmd;
> 	__u32 padding;
> 	__u64 ioctl_ino;
> 	char ioctl_data[0];
> };
>
> More patch is available, but it isn't in a self-contained patch.
>
>   
Is EXT4_IOC_FIEMAP going to be added to the ext4 patch queue?
I will try to use EXT4_IOC_FIEMAP instead of EXT4_IOC_EXTENTS_INFO
in ext4 online defrag when kernel supports it.

Regards, Akira

