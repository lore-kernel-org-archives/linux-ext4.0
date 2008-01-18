From: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCH] Shrink ext3_inode_info by 8 bytes for !POSIX_ACL.
Date: Sat, 19 Jan 2008 00:51:26 +0100 (CET)
Message-ID: <43651.81.207.0.53.1200700286.squirrel@secure.samage.net>
References: <1200170142-1151-1-git-send-email-indan@nul.nu>
    <1200683769.7261.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from neon.samage.net ([85.17.153.66]:45493 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143AbYARXvc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2008 18:51:32 -0500
In-Reply-To: <1200683769.7261.5.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, January 18, 2008 20:16, Mingming Cao wrote:
> On Sat, 2008-01-12 at 21:35 +0100, Indan Zupancic wrote:
>> i_file_acl and i_dir_acl aren't always needed.
>>
>> With certain configs this makes 10 ext3_inode_cache objects fit in
>> one slab instead of the current 9, as the size shrinks from 416 to
>> 408 bytes for 32 bit, !POSIX_ACL and !EXT3_FS_XATTR configs.
>>
>> Signed-off-by: Indan Zupancic <indan@nul.nu>
>> ---
>>  fs/ext3/ialloc.c          |    2 ++
>>  fs/ext3/inode.c           |   29 +++++++++++++++++++----------
>>  include/linux/ext3_fs_i.h |    2 ++
>>  3 files changed, 23 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
>> index 1bc8cd8..01745bc 100644
>> --- a/fs/ext3/ialloc.c
>> +++ b/fs/ext3/ialloc.c
>> @@ -574,8 +574,10 @@ got:
>>  	ei->i_frag_no = 0;
>>  	ei->i_frag_size = 0;
>>  #endif
>> +#ifdef CONFIG_EXT3_FS_POSIX_ACL
>>  	ei->i_file_acl = 0;
>>  	ei->i_dir_acl = 0;
>> +#endif
>
> For regular file, i_dir_acl is being reused as i_size_high to support
> large file.

Only the i_dir_acl of struct ext3_inode, not the one from ext3_inode_info.

Thanks,

Indan
