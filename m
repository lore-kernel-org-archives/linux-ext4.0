From: "=?UTF-8?B?5L6v5pmuKOiwt+eGoCk=?=" <houpu.hp@alibaba-inc.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gZGVidWdmczogQWRkIGlubGluZSBkYXRhIGZlYXR1cmUgZm9yIHN5bWxp?=
  =?UTF-8?B?bmsu?=
Date: Fri, 01 Aug 2014 18:37:56 +0800
Message-ID: <63e6941e-70ab-4fec-941c-f13f47585594@alibaba-inc.com>
References: <1406789932-13770-1-git-send-email-houpu.hp@alibaba-inc.com>,20140801013802.GS8628@birch.djwong.org
Reply-To: "=?UTF-8?B?5L6v5pmuKOiwt+eGoCk=?=" <houpu.hp@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "Ext4 Developers List" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [42.120.133.98] ([42.120.133.98]:46344 "EHLO
	out4133-98.mail.aliyun.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbaHALLc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2014 07:11:32 -0400
In-Reply-To: 20140801013802.GS8628@birch.djwong.org
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2014 at 02:58:52PM +0800, Pu Hou wrote:
>> Symlink in debugfs can take advantage of inline data feature. The path name of the target of the symbol link which is longer than 60 byte and shorter than 132 byte can stay in inline data area.
>
>I think Ted prefers wrapping commit messages at 70 bytes.
>
Thanks for reminding me. I will fix it.

>> +	data.ea_size = size - EXT4_MIN_INLINE_DATA_SIZE;
>> +	data.ea_data = buf + EXT4_MIN_INLINE_DATA_SIZE;
>> +	return ext2fs_inline_data_ea_set(&data);
>
>Doesn't ext2fs_inline_data_set() suffice?
>
It is unnecessary to use this dedicated function.

>> +					sizeof(__u32)+
>> +					EXT4_MIN_INLINE_DATA_SIZE;
>> +			inline_link = (target_len < max_inline);
>
>Does ext2fs_xattr_inode_max_size() + EXT4_MIN_INLINE_DATA_SIZE return incorrect
>results?  I don't think we should have all xattr specific stuff belongs here in
>the symlink routines.

Sorry. I did not notice that some xattr might be existed  when an inode
number is passed to ext2fs_symlink(). But, as far as I can see, when 0
is pass as inode number. ext2fs_xattr_inode_max_size() will read inode
by ext2fs_read_inode_full(). But at that time, we have not writen the
inode back. and the size of inline data for symlink is uncertain.
I will try to find a workaround.

>> -		if (retval)
>> -			goto cleanup;
>> +		  retval = io_channel_write_blk64(fs->io, blk, 1, block_buf);
>> +		  if (retval)
>> +		    goto cleanup;
>
>Please fix the indentation inconsistency (tabs, not spaces).

>> -	if (!fastlink)
>> +	if ((!fastlink) && (!inline_link))
>
>Probably unnecessary to put !fastlink and !inline_link in parentheses.
>
>--D
Darrick, thank again for your generous help.
