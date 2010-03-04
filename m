From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 11/28] ext4: correctly calculate number of blocks for
 fiemap
Date: Thu, 04 Mar 2010 14:40:22 +0900
Message-ID: <4B8F47C6.9060408@rs.jp.nec.com>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu> <1267553925-6308-12-git-send-email-tytso@mit.edu> <4B8E1410.1010107@rs.jp.nec.com> <20100303175217.GA3530@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu, Leonard Michlmayr <leonard.michlmayr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:45769 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab0CDFly (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Mar 2010 00:41:54 -0500
In-Reply-To: <20100303175217.GA3530@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(2010/03/04 2:52), tytso@mit.edu wrote:
> On Wed, Mar 03, 2010 at 04:47:28PM +0900, Akira Fujita wrote:
>>
>> In 1KB block size, the overflow occurs at above line.
>> Since last_blk is set 0xffffffff when len is equal to s_maxbytes.
>> Therefore ext4_fiemap() can not get correct extent information
>> with 0 length.  How about adding this change?
> 
> What do you think _is_ the correct thing to do when length is 0?  As
> Leonard has already pointed out, fiemap_check_ranges() already filters
> out the length=0 case.

/mnt/mp1/file1
 ext logical physical expected length flags
   0       0    49153            8192
   1    8192    77825    57344   2048 eof

For example, we do filefrag command for a above file (file1).
FS_IOC_FIEMAP tries to get whole extents information of file1,
so the output has to be 2 extents.
In this case, fm_length (requested block length) is passed
from the user-space to the kernel-space, as follows:

<user-space>
filefrag:
	fiemap->fm_start(0) fiemap->fm_length(~0ULL)

<kernel-space>
fs/ioctl.c ioctl_fimap():

filemap_check_ranges():
	len(~0ULL)
	new_len(4398046511103 = s_maxbytes)  <--- Because 'len > s_maxbytes'

fs/ext4/extents.c ext4_fiemap():
	last_blk = start(0) + len(4398046511103) - 1 >> s_blocksize_bits(11)
	         = 4294967295 (0xFFFFFFFF)
	len_blks = 4294967295 + 1 (0xFFFFFFFF + 0x00000001)
		 = 4294967296 (0x100000000)  <--- _OVERFLOW!!_
	
ext4_ext_walk_space():
	num = 0

This overflow leads to incorrect output like the below,
even though 2 extents exist.

[root@bsd086 akira]# filefrag -v  /mnt/mp1/file1
Filesystem type is: ef53
File size of /mnt/mp1/file1 is 10485760 (10240 blocks, blocksize 1024)
 ext logical physical expected length flags
/mnt/mp1/file6: 1 extent found

Regards,
Akira Fujita
