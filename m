From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH] ext4: remove double definitions of xattr macros
Date: Thu, 29 May 2008 10:06:07 +0800
Message-ID: <483E0F8F.9040506@cn.fujitsu.com>
References: <48368E5B.7010909@cn.fujitsu.com> <1212009541.3791.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbYE2CIn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 22:08:43 -0400
In-Reply-To: <1212009541.3791.39.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Mingming Cao Wrote:
> On Fri, 2008-05-23 at 17:28 +0800, Shen Feng wrote:
>> remove the definitions of macros:
>> XATTR_TRUSTED_PREFIX
>> XATTR_USER_PREFIX
>> since they are defined in linux/xattr.h
>>
>> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> BTW, the similar duplication also appear in in ext2/3/reiserfs, clean up
> should also done there too?

Yes. I will send a patch series to fix this.

> 
>> ---
>>  fs/ext4/xattr_trusted.c |    4 +---
>>  fs/ext4/xattr_user.c    |    4 +---
>>  2 files changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ext4/xattr_trusted.c b/fs/ext4/xattr_trusted.c
>> index fff3338..ac1a52c 100644
>> --- a/fs/ext4/xattr_trusted.c
>> +++ b/fs/ext4/xattr_trusted.c
>> @@ -13,13 +13,11 @@
>>  #include "ext4.h"
>>  #include "xattr.h"
>>
>> -#define XATTR_TRUSTED_PREFIX "trusted."
>> -
>>  static size_t
>>  ext4_xattr_trusted_list(struct inode *inode, char *list, size_t list_size,
>>  			const char *name, size_t name_len)
>>  {
>> -	const size_t prefix_len = sizeof(XATTR_TRUSTED_PREFIX)-1;
>> +	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
>>  	const size_t total_len = prefix_len + name_len + 1;
>>
>>  	if (!capable(CAP_SYS_ADMIN))
>> diff --git a/fs/ext4/xattr_user.c b/fs/ext4/xattr_user.c
>> index 67be723..d91aa61 100644
>> --- a/fs/ext4/xattr_user.c
>> +++ b/fs/ext4/xattr_user.c
>> @@ -12,13 +12,11 @@
>>  #include "ext4.h"
>>  #include "xattr.h"
>>
>> -#define XATTR_USER_PREFIX "user."
>> -
>>  static size_t
>>  ext4_xattr_user_list(struct inode *inode, char *list, size_t list_size,
>>  		     const char *name, size_t name_len)
>>  {
>> -	const size_t prefix_len = sizeof(XATTR_USER_PREFIX)-1;
>> +	const size_t prefix_len = XATTR_USER_PREFIX_LEN;
>>  	const size_t total_len = prefix_len + name_len + 1;
>>
>>  	if (!test_opt(inode->i_sb, XATTR_USER))
> 
> 
> 

