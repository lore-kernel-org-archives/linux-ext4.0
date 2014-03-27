From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH] e2fsprogs: misc/mke2fs.c: return error when failed to
 populate fs
Date: Thu, 27 Mar 2014 09:55:06 +0800
Message-ID: <533384FA.10807@windriver.com>
References: <1395295766-10637-1-git-send-email-liezhi.yang@windriver.com> <20140322041121.GA22353@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>
To: <linux-ext4@vger.kernel.org>, Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:62030 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaC0BzN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Mar 2014 21:55:13 -0400
In-Reply-To: <20140322041121.GA22353@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello Zheng,

Thanks for your comments, V2 is comming.

// Robert

On 03/22/2014 12:11 PM, Zheng Liu wrote:
> On Thu, Mar 20, 2014 at 02:09:26PM +0800, Robert Yang wrote:
>> We need return retval when "mke2fs -d" failed, otherwise the "$?" would
>> be 0 which is misleading.
>>
>> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
>> ---
>>   misc/mke2fs.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>> index aecd5d5..f659e6f 100644
>> --- a/misc/mke2fs.c
>> +++ b/misc/mke2fs.c
>> @@ -2990,10 +2990,11 @@ no_journal:
>>
>>   		retval = populate_fs(fs, EXT2_ROOT_INO, root_dir,
>>   				     EXT2_ROOT_INO);
>> -		if (retval)
>> +		if (retval) {
>>   			fprintf(stderr, "%s",
>> -				_("\nError while populating file system"));
>                          ^^^
> Using com_err() is sane.  After we get an error, the user can know which
> error has occured.
>> -		else if (!quiet)
>> +				_("\nError while populating file system\n"));
>> +			return retval;
>                          ^^^^
> Maybe exit(1) is better.  We just need to notify the user that an error
> has occured.  An internal error of libext2fs should not be returned
> to user.
>
> Regards,
>                                                  - Zheng
>
>> +		} else if (!quiet)
>>   			printf("%s", _("done\n"));
>>   	}
>>
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
